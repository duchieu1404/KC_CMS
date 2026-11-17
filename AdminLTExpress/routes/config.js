var express = require('express');
var router = express.Router();
const fs = require('fs')
const fsex = require('fs-extra')
const request = require('request');
var app_configs = require('../configs/app_config');
/* GET home page. */
router.get('/', function (req, res) {
    res.redirect('/index.html');
});

/* GET home page. */
router.get('/sync_category', function (req, res) {
    console.log("get sync_category ");
    req.app.ConfigDA.admin_config_data_sync_category_get_all({}, function admin_config_data_sync_type_get_all(err, dataX) {
        console.log(err, dataX);
        if (err || !dataX) {
            return res.render('config/sync_category', { dataConfigs: [] });
        }
        return res.render('config/sync_category', { dataConfigs: dataX });
    });
});

router.post('/sync_category', function (req, res) {
    req.app.ConfigDA.admin_config_data_sync_category_save({
        id: req.body.edt_Id,
        name: req.body.edt_Name,
        description: req.body.edt_Description
    }, function (errSave, dataSave) {
        return res.redirect('/config/sync_category');
    });
});

router.get('/sync_type', function (req, res) {
    req.app.ConfigDA.admin_config_data_sync_type_get_all({}, function admin_config_data_sync_type_get_all(err, dataX) {
        if (err || !dataX) {
            console.log(err, dataX);
            return res.render('config/sync_type', { dataConfigs: [] });
        }
        return res.render('config/sync_type', { dataConfigs: dataX });
    });
});



router.post('/sync_type', function (req, res) {
    req.app.ConfigDA.admin_config_data_sync_type_save({
        id: req.body.edt_Id,
        key: req.body.edt_Key,
        code: req.body.edt_Code,
        cate_type: req.body.edt_Cate_type,
        value_type: req.body.edt_Value_type,
        is_not_sync: req.body.edt_Is_not_sync,
        level: req.body.edt_Level,
        description: req.body.edt_Description
    }, function (errSave, dataSave) {
        return res.redirect('/config/sync_type');
    });
});


router.get('/refresh_sync_type_file', function (req, res) {
    let path = './../public/file_configs/';



    fs.unlink(path, (err) => {
        if (err && err.code == 'ENOENT') {
            // file doens't exist
            console.info("File doesn't exist, won't remove it.");
        } else if (err) {
            // other errors, e.g. maybe we don't have enough permission
            console.error("Error occurred while trying to remove file");
        } else {
            console.info(`removed`);
        }
    });

    // With a callback:
    fsex.writeJson('./package.json', { name: 'fs-extra' }, err => {
        if (err) return console.error(err)

        console.log('success!')
    })



});



router.get('/tester', function (req, res) {
    console.log("get tester ");
    req.app.ConfigDA.admin_tester_get_all({}, function admin_config_data_sync_type_get_all(err, dataX) {
        console.log(err, dataX);
        if (err || !dataX) {
            return res.render('config/tester', { dataConfigs: [] });
        }
        return res.render('config/tester', { dataConfigs: dataX });
    });
});

router.post('/tester', function (req, res) {
    req.app.ConfigDA.admin_tester_save({
        id: req.body.edt_id,
        device_id: req.body.edt_device_id,
        os_type: req.body.edt_os_type,
        version: req.body.edt_version,
        status: req.body.edt_status,
        note: req.body.edt_note
    }, function (errSave, dataSave) {
        return res.redirect('/config/tester');
    });
});


router.post('/delete_tester', function (req, res) {
    console.log(req.body.delete_edt_Id);
    req.app.ConfigDA.admin_tester_delete({
        tester_id: req.body.delete_edt_Id
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});




router.get('/event_popup', function (req, res) {
    console.log("get tester ");
    req.app.ConfigDA.admin_event_popup_get_all({}, function admin_event_popup_get_all(err, dataX) {
        console.log(err, dataX);
        if (err || !dataX) {
            return res.render('config/event_popup', { dataConfigs: [] });
        }
        return res.render('config/event_popup', { dataConfigs: dataX });
    });
});


router.get('/event_team_quest', function (req, res) {
    console.log("event_guild");
    req.app.ConfigDA.admin_team_quest_get_all({}, function admin_team_quest_get_all(err, dataX) {
        console.log(err, dataX);
        if (err || !dataX) {
            return res.render('config/event_team_quest', { dataConfigs: [] });
        }
        return res.render('config/event_team_quest', { dataConfigs: dataX });
    });
});


router.post('/event_popup', function (req, res) {
    req.app.ConfigDA.admin_event_popup_save({
        id: req.body.edt_id,
        os_type: req.body.edt_os_type,
        version: req.body.edt_version,
        status: req.body.edt_status,
        show_from: req.body.edt_show_from,
        show_to: req.body.edt_show_to,
        check_type: req.body.edt_check_type,
        force_view: req.body.edt_force_view,
        asset_url: req.body.edt_asset_url,
        bundle_name: req.body.edt_bundle_name,
        note: req.body.edt_note,
        promote_iap_cnf: req.body.edt_promo_iap,
        promote_bundle_cnf: req.body.edt_promo_bundle,
        template_type: req.body.edt_template_type,
        img_url: req.body.edt_img_url,
        data: req.body.edt_data,
        order_by: req.body.edt_order,
        show_map_count: req.body.edt_show_map_count,
        only_users: req.body.edt_only_users,
        ignore_users: req.body.edt_ignore_users,
        show_condition: req.body.edt_show_condition,
    }, function (errSave, dataSave) {
        return res.redirect('/config/event_popup');
    });
});


router.post('/delete_event_popup', function (req, res) {
    console.log(req.body.delete_edt_Id);
    req.app.ConfigDA.admin_event_popup_delete({
        event_id: req.body.delete_edt_Id
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});


// event gcc api

router.get('/event_gcc', function (req, res) {
    req.app.ConfigDA.admin_event_gcc_get_all({}, function admin_event_gcc_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_gcc', { dataConfigs: [] });
        }
        return res.render('config/event_gcc', { dataConfigs: dataX });
    });
});

router.post('/event_gcc', function (req, res) {
    req.app.ConfigDA.admin_event_gcc_save({
        id: req.body.edt_id,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        status: req.body.edt_status,
        rest_ids: req.body.edt_rest_ids,
        evt_copy: req.body.edt_evt_copy,
    }, function (errSave, dataSave) {
    /**clear cache  */
    request.post(app_configs.option_clearCache, (err, res, body) => {
        if (err) {
          return console.log(err)
        }
        console.log(`Clear cache all successfully for request event_gcc in CMS Status: ${res.statusCode} ` );
      })
      
        return res.redirect('/config/event_gcc');
    });
});


router.post('/event_gcc_delete', function (req, res) {
    req.app.ConfigDA.admin_event_gcc_delete({}, function admin_event_gcc_get_all(err, dataX) {
        req.app.ConfigDA.admin_event_gcc_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_gcc_insert_test_data', function (req, res) {
    req.app.ConfigDA.event_gcc_insert_test_data({}, function event_gcc_insert_test_data(err, dataX) {
        req.app.ConfigDA.event_gcc_insert_test_data(
            {
                event_id: req.body.edt_event_id,
                rest_id: req.body.edt_rest_id
            }, function (err, data) {
                return res.send(data || { status: 1, msg: "err" });
            });
    });
});
// event kitchen rival 


router.get('/event_kr', function (req, res) {
    req.app.ConfigDA.admin_event_kr_get_all({}, function admin_event_kr_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_kr', { dataConfigs: [] });
        }
        return res.render('config/event_kr', { dataConfigs: dataX });
    });
});

router.post('/event_kr', function (req, res) {
    req.app.ConfigDA.admin_event_kr_save({
        status: req.body.edt_status,
        id: req.body.edt_id,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        count_by: req.body.edt_count_by, 
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to
        
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_kr in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_kr');
    });
});


router.post('/event_kr_delete', function (req, res) {
    req.app.ConfigDA.admin_event_kr_delete({}, function admin_ct_get_all(err, dataX) {
        req.app.ConfigDA.admin_event_kr_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_kr_add_score', function (req, res) {
    req.app.ConfigDA.admin_event_kr_add_score({}, function admin_event_kr_add_score(err, dataX) {

        var json = [];

        if (!req.body.edt_event_id || !req.body.edt_score) {
            return;
        }
        list_score =
        {
            "event_id": req.body.edt_event_id,
            "score": parseInt(req.body.edt_score)
        }
        json.push(list_score);
        req.app.ConfigDA.admin_event_kr_add_score({
            user_id: req.body.edt_user_id,
            list_score: JSON.stringify(list_score)
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_kr_insert_test_data', function (req, res) {
    req.app.ConfigDA.admin_event_kr_insert_test_data({}, function admin_event_kr_insert_test_data(err, dataX) {
        req.app.ConfigDA.admin_event_kr_insert_test_data({
            event_id: req.body.edt_event_id,
            total_user_id: req.body.edt_total_user_id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});


// event 1 vs 1

router.get('/event_1vs1', function (req, res) {
    req.app.ConfigDA.admin_event_1vs1_get_all({}, function admin_event_1vs1_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_1vs1', { dataConfigs: [] });
        }
        return res.render('config/event_1vs1', { dataConfigs: dataX });
    });
});

router.post('/event_1vs1', function (req, res) {
    req.app.ConfigDA.admin_event_1vs1_save({
        status: req.body.edt_status,
        id: req.body.edt_id,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        member: req.body.edt_member, 
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to,
        max_score : req.body.edt_max_score,
        time_random_score_min_config : req.body.edt_time_random_score_min_config && req.body.edt_time_random_score_min_config != '' ? req.body.edt_time_random_score_min_config : null,
        time_random_score_max_config : req.body.edt_time_random_score_max_config && req.body.edt_time_random_score_max_config  != '' ? req.body.edt_time_random_score_max_config : null,
        max_win : req.body.edt_max_win && req.body.edt_max_win != ''? req.body.edt_max_win : null
        
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_1vs1 in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_1vs1');
    });
});


router.post('/event_1vs1_delete', function (req, res) {
    req.app.ConfigDA.admin_event_1vs1_delete({}, function admin_ct_get_all(err, dataX) {
        req.app.ConfigDA.admin_event_1vs1_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_1vs1_add_score', function (req, res) {
    req.app.ConfigDA.admin_event_1vs1_add_score({}, function admin_event_1vs1_add_score(err, dataX) {

        var json = [];

        if (!req.body.edt_event_id || !req.body.edt_score) {
            return;
        }
        list_score =
        {
            "event_id": req.body.edt_event_id,
            "score": parseInt(req.body.edt_score)
        }
        json.push(list_score);
        req.app.ConfigDA.admin_event_1vs1_add_score({
            user_id: req.body.edt_user_id,
            list_score: JSON.stringify(list_score)
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_1vs1_insert_test_data', function (req, res) {
    req.app.ConfigDA.admin_event_1vs1_insert_test_data({}, function admin_event_1vs1_insert_test_data(err, dataX) {
        req.app.ConfigDA.admin_event_1vs1_insert_test_data({
            event_id: req.body.edt_event_id,
            total_user_id: req.body.edt_total_user_id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});
// end event 1vs1

/* Event 1hour */

router.get('/event_1hour', function (req, res) {
    req.app.ConfigDA.admin_event_1hour_get_all({}, function admin_event_1hour_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_1hour', { dataConfigs: [] });
        }
        return res.render('config/event_1hour', { dataConfigs: dataX });
    });
});

router.post('/event_1hour', function (req, res) {
    req.app.ConfigDA.admin_event_1hour_save({
        status: req.body.edt_status,
        id: req.body.edt_id,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        member: req.body.edt_member, 
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to
        
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_1hour in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_1hour');
    });
});


router.post('/event_1hour_delete', function (req, res) {
    req.app.ConfigDA.admin_event_1hour_delete({}, function admin_ct_get_all(err, dataX) {
        req.app.ConfigDA.admin_event_1hour_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_1hour_add_score', function (req, res) {
    req.app.ConfigDA.admin_event_1hour_add_score({}, function admin_event_1hour_add_score(err, dataX) {

        var json = [];

        if (!req.body.edt_event_id || !req.body.edt_score) {
            return;
        }
        list_score =
        {
            "event_id": req.body.edt_event_id,
            "score": parseInt(req.body.edt_score)
        }
        json.push(list_score);
        req.app.ConfigDA.admin_event_1hour_add_score({
            user_id: req.body.edt_user_id,
            list_score: JSON.stringify(list_score)
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_1hour_insert_test_data', function (req, res) {
    req.app.ConfigDA.admin_event_1hour_insert_test_data({}, function admin_event_1hour_insert_test_data(err, dataX) {
        req.app.ConfigDA.admin_event_1hour_insert_test_data({
            event_id: req.body.edt_event_id,
            total_user_id: req.body.edt_total_user_id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

/* Event combo rush */

router.get('/event_combo_rush', function (req, res) {
    req.app.ConfigDA.admin_event_combo_rush_get_all({}, function admin_event_combo_rush_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_combo_rush', { dataConfigs: [] });
        }
        return res.render('config/event_combo_rush', { dataConfigs: dataX });
    });
});

router.post('/event_combo_rush', function (req, res) {
    req.app.ConfigDA.admin_event_combo_rush_save({
        status: req.body.edt_status,
        id: req.body.edt_id,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        member: req.body.edt_member, 
        time_bot_join: req.body.edt_time_bot_join, 
        time_end_group: req.body.edt_time_end_group, 
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to
        
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_combo_rush in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_combo_rush');
    });
});


router.post('/event_combo_rush_delete', function (req, res) {
    req.app.ConfigDA.admin_event_combo_rush_delete({}, function admin_ct_get_all(err, dataX) {
        req.app.ConfigDA.admin_event_combo_rush_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_combo_rush_add_score', function (req, res) {
    req.app.ConfigDA.admin_event_combo_rush_add_score({}, function admin_event_combo_rush_add_score(err, dataX) {

        var json = [];

        if (!req.body.edt_event_id || !req.body.edt_score) {
            return;
        }
        list_score =
        {
            "event_id": req.body.edt_event_id,
            "score": parseInt(req.body.edt_score)
        }
        json.push(list_score);
        req.app.ConfigDA.admin_event_combo_rush_add_score({
            user_id: req.body.edt_user_id,
            list_score: JSON.stringify(list_score)
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_combo_rush_insert_test_data', function (req, res) {
    req.app.ConfigDA.admin_event_combo_rush_insert_test_data({}, function admin_event_combo_rush_insert_test_data(err, dataX) {
        req.app.ConfigDA.admin_event_combo_rush_insert_test_data({
            event_id: req.body.edt_event_id,
            total_user_id: req.body.edt_total_user_id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});







//event ct

router.get('/event_ct', function (req, res) {
    req.app.ConfigDA.admin_event_ct_get_all({}, function admin_event_ct_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_ct', { dataConfigs: [] });
        }
        return res.render('config/event_ct', { dataConfigs: dataX });
    });
});

router.post('/event_ct', function (req, res) {
    req.app.ConfigDA.admin_event_ct_save({
        status: req.body.edt_status,
        id: req.body.edt_id,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        count_by: req.body.edt_count_by,
        join_require: req.body.edt_join_require,
        join_reward: req.body.edt_join_reward,
        has_all_boost: req.body.edt_has_all_boost,
        max_rest_id: req.body.edt_max_rest_id,
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to,
        evt_popup_copy: req.body.edt_evt_popup_copy,
        champion_rest: req.body.edt_champion_rest
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_ct in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_ct');
    });
});


router.post('/event_ct_delete', function (req, res) {
    req.app.ConfigDA.admin_event_ct_delete({}, function admin_ct_get_all(err, dataX) {
        req.app.ConfigDA.admin_event_ct_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_ct_add_score', function (req, res) {
    req.app.ConfigDA.admin_event_ct_add_score({}, function admin_event_ct_add_score(err, dataX) {

        var json = [];

        if (!req.body.edt_event_id || !req.body.edt_score) {
            return;
        }
        list_score =
        {
            "event_id": req.body.edt_event_id,
            "score": parseInt(req.body.edt_score)
        }
        json.push(list_score);
        req.app.ConfigDA.admin_event_ct_add_score({
            user_id: req.body.edt_user_id,
            list_score: JSON.stringify(list_score)
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_ct_insert_test_data', function (req, res) {
    req.app.ConfigDA.admin_event_ct_insert_test_data({}, function admin_event_ct_insert_test_data(err, dataX) {
        req.app.ConfigDA.admin_event_ct_insert_test_data({
            event_id: req.body.edt_event_id,
            rest_id: req.body.edt_rest_id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});


 
router.get('/reward_config', function (req, res) {
    req.app.ConfigDA.admin_reward_config_get_all({}, function admin_reward_config_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/reward_config', { dataConfigs: [] });
        }
        return res.render('config/reward_config', { dataConfigs: dataX });
    });
});

router.post('/reward_config', function (req, res) {
    req.app.ConfigDA.admin_reward_config_save({
      
        id_reward: req.body.edt_id_reward,
		name_reward: req.body.edt_name_reward,
		code_reward: req.body.edt_code_reward,
		value_reward: req.body.edt_value_reward,
        
    }, function (errSave, dataSave) {
       
          
        return res.redirect('/config/reward_config');
    });
});


router.post('/reward_config_delete', function (req, res) {
    req.app.ConfigDA.admin_reward_config_delete({}, function admin_ct_get_all(err, dataX) {
        req.app.ConfigDA.admin_reward_config_delete({
            id_reward: req.body.delete_edt_Id_reward
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

//event champion

router.get('/event_champion_tournament', function (req, res) {
    req.app.ConfigDA.admin_event_champion_tournament_get_all({}, function admin_event_champion_tournament_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_champion_tournament', { dataConfigs: [] });
        }
        return res.render('config/event_champion_tournament', { dataConfigs: dataX });
    });
});

router.post('/event_champion_tournament', function (req, res) {
    req.app.ConfigDA.admin_event_champion_tournament_save({
        status: req.body.edt_status,
        id: req.body.edt_id,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        count_by: req.body.edt_count_by,
        // join_require: req.body.edt_join_require,
        // join_reward: req.body.edt_join_reward,
        // has_all_boost: req.body.edt_has_all_boost,
        // max_rest_id: req.body.edt_max_rest_id,
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to,
        // evt_popup_copy: req.body.edt_evt_popup_copy,
        // champion_rest: req.body.edt_champion_rest
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_champion_tournament in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_champion_tournament');
    });
});


router.post('/event_champion_tournament_delete', function (req, res) {
    req.app.ConfigDA.admin_event_champion_tournament_delete({}, function admin_ct_get_all(err, dataX) {
        req.app.ConfigDA.admin_event_champion_tournament_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});


router.post('/event_champion_tournament_add_score', function (req, res) {
    req.app.ConfigDA.admin_event_champion_tournament_add_score({}, function admin_event_champion_tournament_add_score(err, dataX) {

        var json = [];

        if (!req.body.edt_event_id || !req.body.edt_score) {
            return;
        }
        list_score =
        {
            "event_id": req.body.edt_event_id,
            "score": parseInt(req.body.edt_score)
        }
        json.push(list_score);
        req.app.ConfigDA.admin_event_champion_tournament_add_score({
            user_id: req.body.edt_user_id,
            list_score: JSON.stringify(list_score)
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_champion_tournament_insert_test_data', function (req, res) {
    req.app.ConfigDA.admin_event_champion_tournament_insert_test_data({}, function admin_event_champion_tournament_insert_test_data(err, dataX) {
        req.app.ConfigDA.admin_event_champion_tournament_insert_test_data({
            event_id: req.body.edt_event_id,
            rest_id: req.body.edt_rest_id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

// top secret 
router.get('/event_top_secret_meal', function (req, res) {
    req.app.ConfigDA.admin_event_top_secret_meal_get_all({}, function admin_event_top_secret_meal_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_tsm', { dataConfigs: [] });
        }
        return res.render('config/event_tsm', { dataConfigs: dataX });
    });
});

router.post('/event_top_secret_meal', function (req, res) {
    req.app.ConfigDA.admin_event_top_secret_meal_save({
        status: req.body.edt_status,
        id: req.body.edt_id,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_top_secret_meal in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_top_secret_meal');
    });
});


router.post('/event_top_secret_meal_delete', function (req, res) {
    req.app.ConfigDA.admin_event_top_secret_meal_delete({}, function admin_ct_get_all(err, dataX) {
        req.app.ConfigDA.admin_event_top_secret_meal_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});


//reward json

router.get('/reward_json', function (req, res) {
    return res.render('config/reward_json');
});


router.get('/event_team_quest', function (req, res) {
    req.app.ConfigDA.admin_event_team_quest_get_all({}, function admin_event_team_quest_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_team_quest', { dataConfigs: [] });
        }
        return res.render('config/event_team_quest', { dataConfigs: dataX });
    });
});

router.get('/event_team_quest_get_top_team', function (req, res) {
    // Lấy giá trị của tham số từ URL sử dụng req.query
    var eventId = req.query.event_id;

    // Kiểm tra nếu không có event_id được cung cấp
    if (!eventId) {
        return res.status(400).json({ error: "Missing event_id parameter" });
    }

    // Sử dụng eventId trong logic của bạn
    req.app.ConfigDA.admin_event_team_quest_get_top_team({
        event_id: eventId
    }, function admin_event_team_quest_get_top_team(err, dataX) {
        if (err || !dataX) {
            return res.json([]);
        }
        return res.json(dataX);
    });
});

router.post('/event_team_quest', function (req, res) {
    req.app.ConfigDA.admin_team_quest_save({
        id: req.body.edt_id,
        status: req.body.edt_status,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        count_by: req.body.edt_count_by,
        prev_event_id: req.body.edt_prev_event_id,
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to,
        evt_popup_copy: req.body.evt_popup_copy
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_team_quest in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_team_quest');
    });
});


router.post('/event_team_quest_delete', function (req, res) {
    req.app.ConfigDA.admin_team_quest_delete({}, function admin_team_quest_delete(err, dataX) {
        req.app.ConfigDA.admin_team_quest_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});


router.post('/event_team_quest_insert_test_data', function (req, res) {
    req.app.ConfigDA.team_quest_insert_test_data({}, function team_quest_insert_test_data(err, dataX) {
        req.app.ConfigDA.team_quest_insert_test_data(
            {
                event_id: req.body.edt_event_id,
                league_id : req.body.edt_league_id,
                user_id : req.body.edt_user_id
            }, function (err, data) {
                return res.send(data || { status: 1, msg: "err" });
            });
    });
});

router.post('/event_team_quest_insert_test_data_me', function (req, res) {
    req.app.ConfigDA.team_quest_insert_test_data_me({}, function team_quest_insert_test_data(err, dataX) {
        req.app.ConfigDA.team_quest_insert_test_data_me(
            {
                event_id: req.body.edt_event_id,
                league_id : req.body.edt_league_id,
                user_id : req.body.edt_user_id,
                score : req.body.edt_score
            }, function (err, data) {
                return res.send(data || { status: 1, msg: "err" });
            });
    });
});

router.get('/event_world_tour', function (req, res) {
    req.app.ConfigDA.admin_world_tour_get_all({}, function admin_world_tour_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_world_tour', { dataConfigs: [] });
        }
        return res.render('config/event_world_tour', { dataConfigs: dataX });
    });
});


router.post('/event_world_tour_delete', function (req, res) {
    req.app.ConfigDA.admin_world_tour_delete({}, function admin_world_tour_delete(err, dataX) {
        req.app.ConfigDA.admin_world_tour_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/event_world_tour', function (req, res) {
    req.app.ConfigDA.admin_world_tour_save({
        id: req.body.edt_id,
        status: req.body.edt_status,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to,
        evt_popup_copy: req.body.evt_popup_copy,
        file_url :req.body.edt_file_url,
        file_version:req.body.edt_file_version
    }, function (errSave, dataSave) {
        return res.redirect('/config/event_world_tour');
    });
});

router.post('/event_gcc_get_leaderboard', function (req, res) {
    req.app.ConfigDA.admin_event_gcc_get_leaderboard({}, function admin_event_gcc_get_leaderboard(err, dataX) {
        req.app.ConfigDA.event_gcc_get_leaderboard({
            event_id: req.body.event_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});
router.get('/event_lava_quest', function (req, res) {
    req.app.ConfigDA.admin_event_lava_quest_get_all({}, function admin_event_lava_quest_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_lava_quest', { dataConfigs: [] });
        }
        return res.render('config/event_lava_quest', { dataConfigs: dataX });
    });
});

// royal pass event 

router.get('/event_royal_pass', function (req, res) {
    req.app.ConfigDA.admin_event_royal_pass_get_all({}, function admin_event_royal_pass_get_all(err, dataX) {
        if (err || !dataX) {
            return res.render('config/event_royal_pass', { dataConfigs: [] });
        }
        return res.render('config/event_royal_pass', { dataConfigs: dataX });
    });
});

router.post('/event_royal_pass', function (req, res) {
    req.app.ConfigDA.admin_royal_pass_save({
        id: req.body.edt_id,
        status: req.body.edt_status,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to,
        key_bundle: req.body.edt_key_bundle,
        user_ids: req.body.edt_user_ids,
        version: req.body.edt_version,
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_royal_pass in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_royal_pass');
    });
});


router.post('/event_royal_pass_delete', function (req, res) {
    // ko hi?u sao ch? n�y call 2 l?n ?
    req.app.ConfigDA.admin_royal_pass_delete({}, function admin_royal_pass_delete(err, dataX) {
        req.app.ConfigDA.admin_royal_pass_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});

router.post('/change_log_event_royal_pass', function (req, res) {
    
    let search_form = {
        user_id: req.body.searchUserId,
        start_time: req.body.searchStartTime ? req.body.searchStartTime + " 00:00:00"   : new Date(),
        end_time : req.body.searchEndTime ? req.body.searchEndTime + " 23:59:00" : new Date(),
        start_time_inp: req.body.searchStartTime ? req.body.searchStartTime  : new Date(),
        end_time_inp : req.body.searchEndTime ? req.body.searchEndTime : new Date(),
        page_size: req.body.searchPageSize ? req.body.searchPageSize : 10,
        page: req.body.page || 0
    }

    req.app.ConfigDA.list_change_logs(search_form, function (err, data) { 
        return res.render('config/change_log_event_royal_pass', { search_form: search_form, listChangeLogs: data || [] });
    });
});
router.get('/change_log_event_royal_pass', function (req, res) {
    return res.render('config/change_log_event_royal_pass', {search_form: {}, listChangeLogs: []});
});


// event team treasure
router.get('/event_team_treasure', function (req, res) {
    req.app.ConfigDA.admin_team_treasure_get_all({}, function admin_team_treasure_get_all(err, dataX) {
        console.log(err, dataX);
        if (err || !dataX) {
            return res.render('config/event_team_treasure', { dataConfigs: [] });
        }
        return res.render('config/event_team_treasure', { dataConfigs: dataX });
    });
});

router.post('/event_team_treasure', function (req, res) {
    req.app.ConfigDA.admin_team_treasure_save({
        id: req.body.edt_id,
        status: req.body.edt_status,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        count_by: req.body.edt_count_by,
        prev_event_id: req.body.edt_prev_event_id,
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to,
        // evt_popup_copy: req.body.evt_popup_copy
        edt_evt_copy: req.body.edt_evt_copy
    }, function (errSave, dataSave) {
        return res.redirect('/config/event_team_treasure');
    });
});


router.post('/event_team_treasure_delete', function (req, res) {
    req.app.ConfigDA.admin_team_treasure_delete({}, function admin_team_treasure_delete(err, dataX) {
        req.app.ConfigDA.admin_team_treasure_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});


router.post('/event_team_treasure_insert_test_data', function (req, res) {
    req.app.ConfigDA.team_treasure_insert_test_data({}, function team_treasure_insert_test_data(err, dataX) {
        req.app.ConfigDA.team_treasure_insert_test_data(
            {
                event_id: req.body.edt_event_id,
                league_id : req.body.edt_league_id,
                user_id : req.body.edt_user_id
            }, function (err, data) {
                return res.send(data || { status: 1, msg: "err" });
            });
    });
});

router.post('/event_team_treasure_insert_test_data_me', function (req, res) {
    req.app.ConfigDA.team_treasure_insert_test_data_me({}, function team_treasure_insert_test_data(err, dataX) {
        req.app.ConfigDA.team_treasure_insert_test_data_me(
            {
                event_id: req.body.edt_event_id,
                league_id : req.body.edt_league_id,
                user_id : req.body.edt_user_id,
                score : req.body.edt_score
            }, function (err, data) {
                return res.send(data || { status: 1, msg: "err" });
            });
    });
});


router.post('/event_team_treasure_add_team_score', function (req, res) {
    console.log("request event_team_treasure_add_team_score =",req.body);
    req.app.ConfigDA.team_treasure_add_team_score(
        {
            event_id: req.body.edt_event_id,
            user_id : req.body.edt_user_id,
            score : req.body.edt_score,
            team_id :req.body.edt_team_id
        }, function (err, data) {
            console.log("result event_team_treasure_add_team_score data="+ JSON.stringify(data));
            return res.send(data || { status: 1, msg: "err" });
        });
});

router.post('/event_lava_quest', function (req, res) {
    req.app.ConfigDA.admin_lava_quest_save({
        id: req.body.edt_id,
        status: req.body.edt_status,
        time_from: req.body.edt_time_from,
        time_to: req.body.edt_time_to,
        time_show_from: req.body.edt_time_show_from,
        time_show_to: req.body.edt_time_show_to,
        key_bundle: req.body.edt_key_bundle,
        user_ids: req.body.edt_user_ids,
        version: req.body.edt_version,
    }, function (errSave, dataSave) {
        /**clear cache  */
        request.post(app_configs.option_clearCache, (err, res, body) => {
            if (err) {
              return console.log(err)
            }
            console.log(`Clear cache all successfully for request event_lava_quest in CMS Status: ${res.statusCode} ` );
          })
          
        return res.redirect('/config/event_lava_quest');
    });
});


router.post('/event_lava_quest_delete', function (req, res) {
    req.app.ConfigDA.admin_lava_quest_delete({}, function admin_lava_quest_delete(err, dataX) {
        req.app.ConfigDA.admin_lava_quest_delete({
            event_id: req.body.delete_edt_Id
        }, function (err, data) {
            return res.send(data || { status: 1, msg: "err" });
        });
    });
});
module.exports = router;
