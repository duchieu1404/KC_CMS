"use strict";

var _DBModel = require("../shared_class/db_models/DBModel.js");

var IapDA = function (app) {
    this.app = app;
    this.dbModel = new _DBModel(app.dbclient);
}
/**
 * Lịch sử tác động đến điểm của user
 * @param {*} data 
 * @param {*} callback 
 * @returns 
 */
IapDA.prototype.list_iap_history = function (data, callback) {
    console.log(data);
    return this.dbModel.query_callback_array("call admin_list_iap_history(?,?,?,?,?)", [data.user_id,data.start_time,data.end_time,data.page_size,data.page], callback);
}
/** end for team leaderboard */
module.exports = IapDA;