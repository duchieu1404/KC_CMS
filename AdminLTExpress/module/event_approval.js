'use strict';
const crypto = require('crypto');
const registry = Object.create(null);

function isAdmin(roles) {
    try {
        const parsed = typeof roles === 'string' ? JSON.parse(roles) : roles;
        return (Array.isArray(parsed) ? parsed : [parsed]).some(role => role === 0 || role === '0');
    } catch (_) { return false; }
}
function query(app, sql, args) {
    return new Promise((resolve, reject) => app.dbclient.query(sql, args, (err, rows) => err ? reject(err) : resolve(rows)));
}
function token(req) {
    if (!req.session.eventApprovalToken) req.session.eventApprovalToken = crypto.randomBytes(32).toString('hex');
    return req.session.eventApprovalToken;
}
function validToken(req) {
    const supplied = req.get('X-Event-CSRF') || (req.body && req.body._event_csrf);
    return typeof supplied === 'string' && supplied === token(req);
}
async function currentUser(req) {
    const id = req.session && req.session.user_logined && req.session.user_logined.id;
    if (!id) { const err = new Error('Please log in.'); err.status = 401; throw err; }
    const rows = await query(req.app, 'SELECT id, username, fullname, roles FROM admin_user WHERE id = ? LIMIT 1', [id]);
    if (!rows.length) { const err = new Error('Account no longer exists.'); err.status = 403; throw err; }
    return rows[0];
}
function protectedConfig(method, path) {
    return method === 'post' && (/^\/event_/.test(path) || path === '/delete_event_popup') && path !== '/event_gcc_get_leaderboard';
}
function protectedEvent(method, path) {
    return method === 'post' && ['/events', '/duplicate/:event_id', '/delete/:event_id', '/update_user_score_by_event'].includes(path);
}
function protect(router, namespace, predicate) {
    router.stack.forEach(layer => {
        if (!layer.route) return;
        const route = layer.route;
        Object.keys(route.methods).forEach(method => {
            if (!predicate(method, route.path)) return;
            const key = namespace + ':' + method + ':' + route.path;
            const handler = route.stack[0].handle;
            registry[key] = { handler, method, path: route.path, namespace };
            route.stack[0].handle = function (req, res, next) {
                (async () => {
                    const actor = await currentUser(req);
                    if (!validToken(req)) return res.status(403).send('Invalid event CSRF token. Reload the page.');
                    if (isAdmin(actor.roles)) return handler(req, res, next);
                    const reason = String(req.body._approval_reason || '').trim();
                    if (!reason || reason.length > 2000) return res.status(400).send('A reason (1-2000 characters) is required.');
                    const body = Object.assign({}, req.body);
                    delete body._event_csrf;
                    delete body._approval_reason;
                    const payload = JSON.stringify({ body, params: req.params, query: req.query });
                    if (Buffer.byteLength(payload) > 100000) return res.status(413).send('Request is too large.');
                    const result = await query(req.app,
                        'INSERT INTO cms_event_request (requested_by, action_key, payload_json, reason) VALUES (?, ?, ?, ?)',
                        [actor.id, key, payload, reason]);
                    if (req.xhr || req.accepts(['html', 'json']) === 'json') {
                        return res.status(202).json({ status: 2, pending: true, request_id: result.insertId, msg: 'Request #' + result.insertId + ' is waiting for approval.' });
                    }
                    return res.redirect('/approvals/' + result.insertId);
                })().catch(next);
            };
        });
    });
}
function resultFailed(value) {
    if (Array.isArray(value)) return value.some(resultFailed);
    if (!value || typeof value !== 'object') return false;
    const status = value.status === undefined ? value.STATUS : value.status;
    return status !== undefined && Number(status) !== 0;
}
const eventMenuNames = {
    event_popup: 'Event Popup', event_gcc: 'Event GCC', event_ct: 'Event CT',
    event_champion_tournament: 'Event Champion Tournament', event_kr: 'Event Kitchen Rival',
    event_1vs1: 'Event Race 1 vs 1', event_top_secret_meal: 'Event top secret meal',
    event_1hour: 'Event Race 1 hour', event_combo_rush: 'Event Recipe Rumble',
    event_team_quest: 'Event Team Quest', 
    event_team_treasure: 'Event Team Treasure', 
    event_world_tour: 'Event World Tour',
    event_lava_quest: 'Event Lava Quest', event_royal_pass: 'Event Royal Pass',
    event_rainbow_lollipop: 'Event Rainbow Lollipop'
};
function requestMetadata(row) {
    let payload = {};
    try { payload = JSON.parse(row.payload_json || '{}'); } catch (_) { /* Legacy malformed payload. */ }
    const body = payload.body || {};
    const params = payload.params || {};
    const actionKey = String(row.action_key || '');
    let action = 'Update';
    if (/duplicate/i.test(actionKey)) action = 'Duplicate';
    else if (/(^|[_/])delete/i.test(actionKey)) action = 'Delete';
    else if (String(body.edt_id || body.id || '').match(/^(|-1|0)$/)) action = 'Create';
    const routeName = (actionKey.match(/:\/([^/:?]+)/) || [])[1];
    const eventKey = routeName === 'delete_event_popup' ? 'event_popup' : routeName;
    const menuName = eventMenuNames[eventKey];
    const fallbackName = routeName ? routeName.replace(/^event_/, '').replace(/_/g, ' ') : 'Event management';
    const name = menuName || body.edt_title || body.title || body.name || body.event_name || body.event_title ||
        body.edt_event_name || body.edt_note || body.edt_bundle_name || body.evt_popup_copy ||
        params.event_id || body.event_id || body.delete_edt_Id || body.edt_event_id || fallbackName;
    return { action, eventName: String(name) };
}
function execute(app, entry, payload, actor, sourceReq) {
    return new Promise((resolve, reject) => {
        let settled = false;
        let dbError = null;
        let calls = 0;
        const timer = setTimeout(() => finish(new Error('Execution timed out; inspect database before taking any further action.')), 30000);
        function finish(err, result) {
            if (settled) return;
            settled = true;
            clearTimeout(timer);
            if (err || dbError) reject(err || dbError); else resolve(result);
        }
        const localApp = Object.create(app);
        localApp.dbclient = { query(sql, args, cb) {
            calls++;
            app.dbclient.query(sql, args, (err, rows) => {
                if (err || resultFailed(rows)) dbError = err || new Error('Database procedure reported failure.');
                try { cb(err, rows); } catch (callbackError) { finish(callbackError); }
            });
        }};
        ['ConfigDA', 'EventDA', 'TeamDA', 'UserDA'].forEach(name => {
            if (app[name]) localApp[name] = new (require('../database/' + name))(localApp);
        });
        const req = Object.create(sourceReq);
        Object.assign(req, { app: localApp, body: payload.body, params: payload.params, query: payload.query,
            session: { user_logined: actor }, method: entry.method.toUpperCase() });
        req.DA = sourceReq.DA || app.DA;
        let httpStatus = 200;
        const response = {
            status(code) { httpStatus = code; return this; },
            send(value) { finish(httpStatus >= 400 || resultFailed(value) ? new Error('Handler reported failure.') : (!calls ? new Error('No database action was performed.') : null), value); return this; },
            json(value) { return this.send(value); },
            redirect(url) { return this.send({ redirect: url }); },
            render() { finish(new Error('Unexpected render during execution.')); }
        };
        try { entry.handler(req, response, err => finish(err || new Error('Handler did not execute.'))); }
        catch (err) { finish(err); }
    });
}
function router() {
    const router = require('express').Router();
    router.use((req, res, next) => currentUser(req).then(actor => {
        req.approvalActor = actor;
        res.locals.eventApprovalToken = token(req);
        res.locals.eventApprovalAdmin = isAdmin(actor.roles);
        next();
    }).catch(next));
    router.get('/', (req, res, next) => {
        const admin = isAdmin(req.approvalActor.roles);
        query(req.app, 'SELECT r.*, u.username AS requester FROM cms_event_request r LEFT JOIN admin_user u ON u.id = r.requested_by' +
            (admin ? '' : ' WHERE r.requested_by = ?') + ' ORDER BY r.id DESC LIMIT 200', admin ? [] : [req.approvalActor.id])
            .then(rows => res.render('approvals/list', { requests: rows.map(row => Object.assign(row, requestMetadata(row))) })).catch(next);
    });
    router.get('/:id', (req, res, next) => {
        query(req.app, 'SELECT * FROM cms_event_request WHERE id = ?', [req.params.id]).then(rows => {
            const row = rows[0];
            if (!row || (!isAdmin(req.approvalActor.roles) && row.requested_by !== req.approvalActor.id)) return res.sendStatus(404);
            res.render('approvals/detail', { request: row, payload: JSON.parse(row.payload_json) });
        }).catch(next);
    });
    router.post('/:id/:decision', (req, res, next) => {
        (async () => {
            if (!isAdmin(req.approvalActor.roles)) return res.sendStatus(403);
            if (!validToken(req)) return res.status(403).send('Invalid CSRF token.');
            if (!['approve', 'reject'].includes(req.params.decision)) return res.sendStatus(404);
            const rows = await query(req.app, 'SELECT * FROM cms_event_request WHERE id = ?', [req.params.id]);
            const row = rows[0];
            if (!row) return res.sendStatus(404);
            const entry = registry[row.action_key];
            if (req.params.decision === 'approve' && !entry) return res.status(409).send('This action is no longer registered.');
            const note = String(req.body.note || '').trim().slice(0, 2000);
            const claimed = await query(req.app,
                'UPDATE cms_event_request SET status = ?, reviewed_by = ?, reviewed_at = NOW(), review_note = ? WHERE id = ? AND status = ?',
                [req.params.decision === 'reject' ? 'rejected' : 'executing', req.approvalActor.id, note, row.id, 'pending']);
            if (claimed.affectedRows !== 1) return res.status(409).send('Request has already been reviewed.');
            if (req.params.decision === 'reject') return res.redirect('/approvals');
            try {
                const result = await execute(req.app, entry, JSON.parse(row.payload_json), req.approvalActor, req);
                await query(req.app, 'UPDATE cms_event_request SET status = ?, executed_at = NOW(), result_json = ? WHERE id = ? AND status = ?',
                    ['executed', JSON.stringify(result === undefined ? null : result).slice(0, 60000), row.id, 'executing']);
            } catch (err) {
                await query(req.app, 'UPDATE cms_event_request SET status = ?, error_message = ? WHERE id = ? AND status = ?',
                    ['needs_review', String(err.message).slice(0, 2000), row.id, 'executing']);
            }
            res.redirect('/approvals');
        })().catch(next);
    });
    return router;
}
function locals(req, res, next) {
    if (req.session && req.session.user_logined) {
        res.locals.eventApprovalToken = token(req);
        res.locals.eventApprovalAdmin = isAdmin(req.session.user_logined.roles);
    }
    next();
}
module.exports = { isAdmin, protectedConfig, protectedEvent, protect, router, locals, resultFailed, execute, requestMetadata };
