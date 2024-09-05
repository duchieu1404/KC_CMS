var express = require('express');
var router = express.Router();


router.get('/', function (req, res) {
    return res.render('team/index', { search_form: {}, listTeams: [] });
});

router.get('/user_leaderboards', function (req, res) {
    return res.render('team/user_leaderboards', {search_form: {}, listUsers: []});
});



router.post('/search_team', function (req, res) {
    let search_form = {
        team_id: req.body.searchTeamId || null, 
        team_name: req.body.searchTeamName || null, 
        offset: req.body.searchOffset || 0,
        limit: req.body.searchLimit || 100
    }

    req.app.TeamDA.admin_search_team(search_form, function (err, data) {
        console.log(data);
        return res.render('team/index', { search_form: search_form, listTeams: data });

    });

});

router.post('/user_leaderboards', function (req, res) {
    let search_form = {
        event_id: req.body.searchEventId,
        rest_id: req.body.searchRestId,
        page_size: req.body.searchPageSize,
        page: req.body.page || 0
    }

    req.app.TeamDA.list_user_score_by_event(search_form, function (err, data) {
        console.log(data);
        return res.render('team/user_leaderboards', { search_form: search_form, listUsers: data || [] });
    });
});

router.post('/update_user_score_by_event', function (req, res) {
    let params = {
        event_id: req.body.event_id,
        rest_id: req.body.rest_id,
        user_id: req.body.user_id,
        team_id: req.body.team_id,
        score: req.body.score,
        reason: req.body.reason,
        creator: req.body.creator,
    }

    req.app.TeamDA.update_user_score_by_event(params, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});
/** for team leaderboadrd */
router.get('/team_leaderboards', function (req, res) {
    return res.render('team/team_leaderboards', {search_form: {}, listUsers: []});
});


router.post('/team_leaderboards', function (req, res) {
    let search_form = {
        event_id: req.body.searchEventId,
        rest_id: req.body.searchRestId,
        page_size: req.body.searchPageSize,
        page: req.body.page || 0
    }

    req.app.TeamDA.list_team_score_by_event(search_form, function (err, data) {
        console.log(data);
        return res.render('team/team_leaderboards', { search_form: search_form, listUsers: data || [] });
    });
});


router.post('/update_team_score_by_event', function (req, res) {
    let params = {
        event_id: req.body.event_id,
        rest_id: req.body.rest_id,
        team_id: req.body.team_id,
        score: req.body.score,
    }

    req.app.TeamDA.update_team_score_by_event(params, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});
/** end for team leaderboard */
module.exports = router;
