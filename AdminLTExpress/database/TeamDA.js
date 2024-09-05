"use strict";

var _DBModel = require("../shared_class/db_models/DBModel.js");

var TeamDA = function (app) {
    this.app = app;
    this.dbModel = new _DBModel(app.dbclient);
}

/**
 * Lịch sử tác động đến điểm của user
 * @param {*} data 
 * @param {*} callback 
 * @returns 
 */

TeamDA.prototype.admin_search_team = function (data, callback) {
    console.log(data);
    return this.dbModel.query_callback_array("call admin_search_team(?,?,?,?,?)", [
        data.admin_id,
        data.team_id,
        data.team_name, 
        data.offset,
        data.limit
    ], callback);
}
TeamDA.prototype.list_user_score_changed = function (data, callback) {
    return this.dbModel.query_callback_array("call team_list_user_score_changed()", [], callback);
}
TeamDA.prototype.list_iap_history = function (data, callback) {
    console.log("data call ", data);
    return this.dbModel.query_callback_array("call admin_list_iap_history(?,?,?,?,?)", [data.user_id,data.start_time,data.end_time,data.page_size,data.page], callback);
}

/**
 * List danh sách user theo event_id và rest_id, phục vụ check user hack điểm
 * @param {*} data 
 * @param {*} callback 
 * @returns 
 */
 TeamDA.prototype.list_user_score_by_event = function (data, callback) {
    return this.dbModel.query_callback_array("call team_list_user_score_by_event(?, ?, ?, ?)", [
        data.event_id,
        data.rest_id,
        data.page_size,
        data.page || 0
    ], callback);
}

TeamDA.prototype.update_user_score_by_event = function (data, callback) {
    return this.dbModel.query_callback_array("call team_update_user_score_by_event(?, ?, ?, ?, ?, ?, ?)", [
        data.event_id,
        data.rest_id,
        data.team_id,
        data.user_id,
        data.score,
        data.reason,
        data.creator
    ], callback);
}


/***
    *@param {*} data 
    * @param {*} callback 
    * @returns 
 */
TeamDA.prototype.list_team_score_by_event = function (data, callback) {
    return this.dbModel.query_callback_array("call team_list_team_score_by_event(?, ?, ?, ?)", [
        data.event_id,
        data.rest_id,
        data.page_size,
        data.page || 0
    ], callback);
}

TeamDA.prototype.update_team_score_by_event = function (data, callback) {
    return this.dbModel.query_callback_array("call team_update_team_score_by_event(?, ?, ?, ?)", [
        data.event_id,
        data.rest_id,
        data.team_id,
        data.score,
    ], callback);
}
/** end for team leaderboard */
module.exports = TeamDA;
