"use strict";

var _DBModel = require("../shared_class/db_models/DBModel.js");

var EventDA = function (app) {
    this.app = app;
    this.dbModel = new _DBModel(app.dbclient);
}

/**
 * Lịch sử tác động đến điểm của user
 * @param {*} data 
 * @param {*} callback 
 * @returns 
 */
 EventDA.prototype.list_user_score_changed = function (data, callback) {
    return this.dbModel.query_callback_array("call event_list_user_score_changed()", [], callback);
}

/**
 * List danh sách user theo event_id và rest_id, phục vụ check user hack điểm
 * @param {*} data 
 * @param {*} callback 
 * @returns 
 */
 EventDA.prototype.list_user_score_by_event = function (data, callback) {
    return this.dbModel.query_callback_array("call event_list_user_score_by_event(?, ?, ?, ?)", [
        data.event_id,
        data.rest_id,
        data.page_size,
        data.page || 0
    ], callback);
}

EventDA.prototype.update_user_score_by_event = function (data, callback) {
    return this.dbModel.query_callback_array("call event_update_user_score_by_event(?, ?, ?, ?, ?, ?)", [
        data.event_id,
        data.rest_id,
        data.user_id,
        data.score,
        data.reason,
        data.creator
    ], callback);
}

module.exports = EventDA;
