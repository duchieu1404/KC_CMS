"use strict";

var _DBModel = require("../shared_class/db_models/DBModel.js");

var ConfigDA = function (app) {
    this.app = app;
    this.dbModel = new _DBModel(app.dbclient);
}

module.exports = ConfigDA;

ConfigDA.prototype.admin_config_data_sync_type_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_config_data_sync_type_get_all()", [], callback);
}

ConfigDA.prototype.admin_config_data_sync_category_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_config_data_sync_category_save(?,?,?,?)", [
        data.admin_id,
        data.id,
        data.name,
        data.description
    ], callback);
}

ConfigDA.prototype.admin_config_data_sync_category_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_config_data_sync_category_get_all()", [], callback);
}



ConfigDA.prototype.admin_config_data_sync_type_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_config_data_sync_type_save(?,?,?,?,?,?,?,?,?)", [
        data.admin_id,
        data.id,
        data.key,
        data.code,
        data.cate_type,
        data.value_type,
        data.is_not_sync,
        data.level,
        data.description
    ], callback);
}


ConfigDA.prototype.admin_tester_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_tester_get_all()", [], callback);
}


ConfigDA.prototype.admin_tester_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_tester_save(?,?,?,?,?,?,?)", [
        data.admin_id,
        data.id,
        data.device_id,
        data.os_type,
        data.version,
        data.status,
        data.note
    ], callback);
}


ConfigDA.prototype.admin_tester_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_tester_delete(?,?)", [
        data.admin_id,
        data.tester_id
    ], callback);
}



ConfigDA.prototype.admin_event_popup_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_popup_get_all()", [], callback);
}


ConfigDA.prototype.admin_event_popup_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_popup_save(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", [
        data.admin_id,
        data.id,
        data.os_type,
        data.version,
        data.show_from,
        data.show_to,
        data.check_type,
        data.force_view,
        data.asset_url,
        data.bundle_name,
        data.status,
        data.note,
        data.promote_iap_cnf,
        data.promote_bundle_cnf,
        data.img_url,
        data.data,
        data.template_type,
        data.order_by,
        data.show_map_count,
        data.only_users,
        data.ignore_users,
        data.show_condition
    ], callback);
}


ConfigDA.prototype.admin_event_popup_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_popup_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}

ConfigDA.prototype.admin_event_gcc_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_gcc_get_all()", [], callback);
}
ConfigDA.prototype.admin_event_gcc_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_gcc_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_gcc_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_gcc_save(?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.rest_ids,
        data.evt_copy
    ], callback);
}

ConfigDA.prototype.event_gcc_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call event_gcc_insert_test_data(?,?)", [
        data.event_id,
        data.rest_id,
    ], callback);
}
// kitchen reval new 
ConfigDA.prototype.admin_event_kr_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_kr_get_all()", [], callback);
}
ConfigDA.prototype.admin_event_kr_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_kr_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_kr_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_kr_save(?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.count_by, 
        data.time_show_from,
        data.time_show_to
      
    ], callback);
}

ConfigDA.prototype.admin_event_kr_add_score = function (data, callback) {
    return this.dbModel.query_callback_object("call event_kr_add_multi(?,?)", [
        data.user_id,
        data.list_score
    ], callback);
}
ConfigDA.prototype.admin_event_kr_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call event_kr_insert_test_data(?,?)", [
        data.event_id,
        data.total_user_id
    ], callback);
}

// event race 1 vs 1
ConfigDA.prototype.admin_event_1vs1_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_1vs1_get_all()", [], callback);
}
ConfigDA.prototype.admin_event_1vs1_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_1vs1_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_1vs1_save = function (data, callback) {
    console.log(data,"admin_event_1vs1_save");
    return this.dbModel.query_callback_array("call admin_event_1vs1_save(?,?,?,?,?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.member, 
        data.time_show_from,
        data.time_show_to,
        data.max_score,
        data.time_random_score_min_config ,
        data.time_random_score_max_config ,
        data.max_win
      
    ], callback);
}

ConfigDA.prototype.admin_event_1vs1_add_score = function (data, callback) {
    return this.dbModel.query_callback_object("call event_1vs1_add_multi(?,?)", [
        data.user_id,
        data.list_score
    ], callback);
}
ConfigDA.prototype.admin_event_1vs1_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call event_1vs1_insert_test_data(?,?)", [
        data.event_id,
        data.total_user_id
    ], callback);
}



// event race 1 hour
ConfigDA.prototype.admin_event_1hour_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_1hour_get_all()", [], callback);
}
ConfigDA.prototype.admin_event_1hour_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_1hour_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_1hour_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_1hour_save(?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.member, 
        data.time_show_from,
        data.time_show_to
      
    ], callback);
}

ConfigDA.prototype.admin_event_1hour_add_score = function (data, callback) {
    return this.dbModel.query_callback_object("call event_1hour_add_multi(?,?)", [
        data.user_id,
        data.list_score
    ], callback);
}
ConfigDA.prototype.admin_event_1hour_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call event_1hour_insert_test_data(?,?)", [
        data.event_id,
        data.total_user_id
    ], callback);
}

// event combo rush
ConfigDA.prototype.admin_event_combo_rush_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_combo_rush_get_all()", [], callback);
}
ConfigDA.prototype.admin_event_combo_rush_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_combo_rush_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_combo_rush_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_combo_rush_save(?,?,?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.member, 
        data.time_bot_join,
        data.time_end_group,
        data.time_show_from,
        data.time_show_to
      
    ], callback);
}

ConfigDA.prototype.admin_event_combo_rush_add_score = function (data, callback) {
    return this.dbModel.query_callback_object("call event_combo_rush_add_multi(?,?)", [
        data.user_id,
        data.list_score
    ], callback);
}
ConfigDA.prototype.admin_event_combo_rush_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call event_combo_rush_insert_test_data(?,?)", [
        data.event_id,
        data.total_user_id
    ], callback);
}

// kitchen rival 

ConfigDA.prototype.admin_event_ct_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_ct_get_all()", [], callback);
}
ConfigDA.prototype.admin_event_ct_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_ct_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_ct_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_ct_save(?,?,?,?,?,?,?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.count_by,
        data.join_require,
        data.join_reward,
        data.has_all_boost,
        data.max_rest_id,
        data.time_show_from,
        data.time_show_to,
        data.evt_popup_copy,
        data.champion_rest
    ], callback);
}

ConfigDA.prototype.admin_event_ct_add_score = function (data, callback) {
    return this.dbModel.query_callback_object("call event_ct_add_multi(?,?)", [
        data.user_id,
        data.list_score
    ], callback);
}
ConfigDA.prototype.admin_event_ct_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call event_ct_insert_test_data(?,?)", [
        data.event_id,
        data.rest_id
    ], callback);
}
 
ConfigDA.prototype.admin_event_champion_tournament_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_champion_tournament_get_all()", [], callback);
}
ConfigDA.prototype.admin_event_champion_tournament_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_champion_tournament_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_champion_tournament_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_champion_tournament_save(?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.count_by,
        // data.join_require,
        // data.join_reward,
        // data.has_all_boost,
        // data.max_rest_id,
        data.time_show_from,
        data.time_show_to,
        // data.evt_popup_copy,
        // data.champion_rest
    ], callback);
}


// Event top secret meal 
ConfigDA.prototype.admin_event_top_secret_meal_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_top_secret_meal_get_all()", [], callback);
}
ConfigDA.prototype.admin_event_top_secret_meal_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_event_top_secret_meal_delete(?,?)", [
        data.admin_id,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_top_secret_meal_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_top_secret_meal_save(?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.time_show_from,
        data.time_show_to
    ], callback);
}
// End top secret meal


ConfigDA.prototype.admin_reward_config_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_reward_config_get_all()", [], callback);
}
ConfigDA.prototype.admin_reward_config_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_reward_config_delete(?,?)", [
        data.admin_id,
        data.id_reward
    ], callback);
}
ConfigDA.prototype.admin_reward_config_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_reward_config_save(?,?,?,?)", [
        data.id_reward,
        data.name_reward,
        data.value_reward,
        data.code_reward
    ], callback);
}
 
ConfigDA.prototype.admin_event_champion_tournament_add_score = function (data, callback) {
    return this.dbModel.query_callback_object("call event_champion_tournament_add_multi(?,?)", [
        data.user_id,
        data.list_score
    ], callback);
}
ConfigDA.prototype.admin_event_champion_tournament_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call event_champion_tournament_insert_test_data(?,?)", [
        data.event_id,
        data.rest_id
    ], callback);
}


ConfigDA.prototype.admin_team_quest_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_team_quest_get_all()", [], callback);
}

ConfigDA.prototype.admin_event_team_quest_get_top_team = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_event_team_quest_get_top_team(?)",
                                            [data.event_id],
                                            callback);
}

ConfigDA.prototype.admin_team_quest_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_team_quest_save(?,?,?,?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.count_by,
        data.prev_event_id,
        data.time_show_from,
        data.time_show_to,
        data.evt_popup_copy,
null
    ], callback);
}
ConfigDA.prototype.admin_team_quest_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_team_quest_delete(?,?)", [
        data.admin_id || 0,
        data.event_id
    ], callback);
}
ConfigDA.prototype.team_quest_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call team_quest_insert_test_data(?,?,?)", [
        data.event_id,
        data.league_id,
        data.user_id
    ], callback);
}
ConfigDA.prototype.team_quest_insert_test_data_me = function (data, callback) {
    return this.dbModel.query_callback_object("call team_quest_insert_test_data_me(?,?,?,?)", [
        data.event_id,
        data.league_id,
        data.user_id,
        data.score
    ], callback);

}

/*
event royal pass
*/

ConfigDA.prototype.admin_event_royal_pass_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_royal_pass_get_all()", [], callback);
}

ConfigDA.prototype.admin_royal_pass_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_royal_pass_save(?,?,?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.time_show_from,
        data.time_show_to,
        data.key_bundle,
        data.user_ids,
        data.version
    ], callback);
}

ConfigDA.prototype.admin_royal_pass_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_royal_pass_delete(?,?)", [
        data.admin_id || 0,
        data.event_id
    ], callback);
}

ConfigDA.prototype.royal_pass_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call royal_pass_insert_test_data(?,?,?)", [
        data.event_id,
        data.league_id,
        data.user_id
    ], callback);
}

ConfigDA.prototype.royal_pass_insert_test_data_me = function (data, callback) {
    return this.dbModel.query_callback_object("call royal_pass_insert_test_data_me(?,?,?,?)", [
        data.event_id,
        data.league_id,
        data.user_id,
        data.score
    ], callback);

}

ConfigDA.prototype.list_change_logs = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_change_log_event_royal_pass(?,?,?)", [data.user_id,data.page_size,data.page], callback);
}

// event team treasure
ConfigDA.prototype.admin_team_treasure_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_team_treasure_get_all()", [], callback);
}
ConfigDA.prototype.admin_team_treasure_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_team_treasure_save(?,?,?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.count_by,
        data.prev_event_id,
        data.time_show_from,
        data.time_show_to,
        data.edt_evt_copy,
        // data.evt_popup_copy
    ], callback);
}
ConfigDA.prototype.admin_team_treasure_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_team_treasure_delete(?,?)", [
        data.admin_id || 0,
        data.event_id
    ], callback);
}
ConfigDA.prototype.team_treasure_insert_test_data = function (data, callback) {
    return this.dbModel.query_callback_object("call team_treasure_insert_test_data(?,?,?)", [
        data.event_id,
        data.league_id,
        data.user_id
    ], callback);
}
ConfigDA.prototype.team_treasure_insert_test_data_me = function (data, callback) {
    return this.dbModel.query_callback_object("call team_treasure_insert_test_data_me(?,?,?,?)", [
        data.event_id,
        data.league_id,
        data.user_id,
        data.score
    ], callback);
}
ConfigDA.prototype.team_treasure_add_team_score = function (data, callback) {
    console.log("?? ~ data call proc team_treasure_add_nout=", data);
    try {
        this.dbModel.query_callback_object("call team_treasure_add_nout(?,?,?,?)", [
            data.user_id,
            data.event_id,
            data.team_id,
            data.score
        ], function (err, result) {
            if (err) {
                console.error("team_treasure_add_team_score error:", err);
                return callback({ status: 1, msg: "error: " + err });
            }
            return callback(data, { status: 0, msg: "OK" });
        });
    } catch (error) {
        console.error("team_treasure_add_team_score error:", error);
        return callback({ status: 1, msg: "error: " + error });
    }
};


ConfigDA.prototype.admin_world_tour_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_world_tour_get_all()", [], callback);
}

ConfigDA.prototype.admin_world_tour_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_world_tour_save(?,?,?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.time_show_from,
        data.time_show_to,
        data.evt_popup_copy,
        data.file_url,
        data.file_version
    ], callback);
}

ConfigDA.prototype.admin_world_tour_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_world_tour_delete(?,?)", [
        data.admin_id || 0,
        data.event_id
    ], callback);
}
ConfigDA.prototype.admin_event_lava_quest_get_all = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_lava_quest_get_all()", [], callback);
}

ConfigDA.prototype.admin_lava_quest_save = function (data, callback) {
    return this.dbModel.query_callback_array("call admin_lava_quest_save(?,?,?,?,?,?,?)", [
        data.id,
        data.status,
        data.time_from,
        data.time_to,
        data.time_show_from,
        data.time_show_to,
        data.user_ids
    ], callback);
}

ConfigDA.prototype.admin_lava_quest_delete = function (data, callback) {
    return this.dbModel.query_callback_object("call admin_lava_quest_delete(?,?)", [
        data.admin_id || 0,
        data.event_id
    ], callback);
}
