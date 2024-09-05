var express = require('express');
var router = express.Router();
var app_configs = require('../configs/app_config');
const axios = require('axios');
/* GET users listing. */
router.get('/', function (req, res) {
    return res.render('users/index', { search_form: {}, listUsers: [] });
});

router.get('/send-all-email', function (req, res) {
    return res.render('users/send_all_email', { search_form: {}, listUsers: [] });
});
router.get('/send-email-selected', function (req, res) {
    return res.render('users/send_email_selected', { search_form: {}, listUsers: [] });
});

router.post('/search_user', function (req, res) {
    let search_form = {
        user_id: req.body.searchUserId.replace(' ', '') == '' ? 0 : eval(req.body.searchUserId),
        fullname: req.body.searchFullName,
        device_id: req.body.searchDeviceId,
        user_pseudo_id: req.body.searchUserPseudoId,
        min_spent: req.body.searchMinSpent || 0,
        offset: req.body.searchOffset || 0,
        limit: req.body.searchLimit || 100
    }

    req.app.UserDA.admin_search_user(search_form, function (err, data) {

        return res.render('users/index', { search_form: search_form, listUsers: data });

    });

});

router.post('/delete_user', function (req, res) {
    console.log(req.body.delete_edt_Id);
    req.app.UserDA.admin_delete_user({
        user_id: req.body.delete_edt_Id
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});

router.post('/get_all_user_data', function (req, res) {
    console.log(req.body.user_id);
    req.app.UserDA.admin_get_all_user_data({
        user_id: req.body.user_id
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});


router.post('/get_back_up_user_data', function (req, res) {
    console.log(req.body.user_id);
    req.app.UserDA.admin_get_back_up_user_data({
        user_id: req.body.user_id
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});

router.post('/restore_user_data', function (req, res) {
    console.log(req.body.restore_edt_Id);
    req.app.UserDA.admin_restore_user_data({
        user_id: req.body.restore_edt_Id
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});

router.post('/reset_user_data',function(req,res){
    console.log(req.body.reset_edt_Id);
    req.app.UserDA.admin_reset_progress_user({
        user_id: req.body.reset_edt_Id
    },function(err,data){
        return res.send(data || {status: 1,msg: "err"});
    });
});

router.post('/email_send', function (req, res) {

    let expireTime = null;
    if (!req.body.edt_expire_time || req.body.edt_expire_time == "") {
        expireTime = null;
    }
    else {
        // need test try parse datetime and format it to server time
        // expireTime = req.body.edt_expire_time + " 23:59:00";
        expireTime = req.body.edt_expire_time ;
    }

    let arrIds = [];
    if (req.body.emailToNumberUser == 1) {
        arrIds.push(req.body.edt_Id);
    }
    else {
        arrIds = req.body.edt_IdMulti.split(/[ .:;?!~,`"&|()<>{}\[\]\t\r\n/\\]+/).filter(function (value, index, arr) {

            return value != "";

        });

    }
    console.log(arrIds);
    var dataSend = dataSend = {
        user_ids: JSON.stringify(arrIds),
        title: req.body.edt_Title,
        content: req.body.edt_Content,
        sent_by: req.body.edt_email_send_name,
        email_type: req.body.edt_MessageType
    };

    if (req.body.edt_MessageType == 1) {
        // gift
        let objGift = [];

        if (req.body.edt_email_Gem != 0) {
            objGift.push({
                "type": 1,
                "quantity": req.body.edt_email_Gem
            });
        }

        for (var coin_i = 1; coin_i <= 100; coin_i++) {
            if (req.body["edt_email_Coin" + coin_i] != 0 || req.body["edt_email_key_" + coin_i] != 0 ) {
                objGift.push({
                    "type": 0,
                    "quantity": req.body["edt_email_Coin" + coin_i],
                    "key": req.body["edt_email_key_" + coin_i],
                    "resId": coin_i
                });
            }
        }

        if (req.body.edt_email_boost_x2 != 0) {
            objGift.push({
                "type": 2,
                "quantity": req.body.edt_email_boost_x2
            });
        }


        if (req.body.edt_email_boost_pan != 0) {
            objGift.push({
                "type": 3,
                "quantity": req.body.edt_email_boost_pan
            });
        }

        if (req.body.edt_email_boost_time != 0) {
            objGift.push({
                "type": 4,
                "quantity": req.body.edt_email_boost_time
            });
        }

        if (req.body.edt_email_boost_cake != 0) {
            objGift.push({
                "type": 5,
                "quantity": req.body.edt_email_boost_cake
            });
        }

        if (req.body.edt_email_boost_ice != 0) {
            objGift.push({
                "type": 6,
                "quantity": req.body.edt_email_boost_ice
            });
        }

        if (req.body.edt_email_boost_serve != 0) {
            objGift.push({
                "type": 7,
                "quantity": req.body.edt_email_boost_serve
            });
        }

        if (req.body.edt_email_infinite_heart != 0) {
            objGift.push({
                "type": 8,
                "quantity": req.body.edt_email_infinite_heart
            });
        }

        if (req.body.edt_email_nm_time != 0) {
            objGift.push({
                "type": 12,
                "quantity": req.body.edt_email_nm_time
            });
        }

        if (req.body.edt_email_nm_cus != 0) {
            objGift.push({
                "type": 13,
                "quantity": req.body.edt_email_nm_cus
            });
        }

        if(req.body.edt_email_combo != 0) {
            objGift.push({
                "type":17,
                "quantity": req.body.edt_email_combo
            });
        }
        
        if(req.body.edt_email_happy_hand != 0) {
            objGift.push({
                "type":18,
                "quantity":req.body.edt_email_happy_hand
            });
        } 

        if(req.body.edt_email_mm_unlimit != 0) {
            objGift.push({
                "type":19,
                "quantity":req.body.edt_email_mm_unlimit
            });
        } 

        if(req.body.edt_email_telfon_unlimit != 0) {
            objGift.push({
                "type":20,
                "quantity":req.body.edt_email_telfon_unlimit
            });
        } 

        if(req.body.edt_email_ff_unlimit != 0) {
            objGift.push({
                "type":21,
                "quantity":req.body.edt_email_ff_unlimit
            });
        } 

        if(req.body.edt_email_nsc != 0) {
            objGift.push({
                "type":22,
                "quantity":req.body.edt_email_nsc
            });
        } 
        if(req.body.edt_email_ff_combo_unlimit != 0) {
            objGift.push({
                "type":24,
                "quantity":req.body.edt_email_ff_combo_unlimit
            });
        } 
        if(req.body.edt_email_helping_hand != 0) {
            objGift.push({
                "type":25,
                "quantity":req.body.edt_email_helping_hand
            });
        } 
        dataSend.gift = JSON.stringify(objGift);

    }
    else {
        if (req.body.edt_MessageType == 3 || req.body.edt_MessageType == 4) {

            let ress = [];
            for (var i = 1; i <= 100; i++) {
                if (req.body["edt_email_Coin" + i] != null) {
                    let res1 = {
                        "id": i,
                        "level": req.body["edt_email_levels_" + i],
                        "coin": req.body["edt_email_Coin" + i],
                        "lvl_stage": req.body["edt_email_tier_" + i],
                        "unlock_state": req.body["edt_email_unlock_state_" + i],
                        "total_stars": req.body["edt_email_total_stars_" + i],
                        "key": req.body["edt_email_key_" + i]
                    };
                    ress.push(res1);
                }
            }
            // console.log("ress: " +JSON.stringify(ress));

            let reward = [];
            if (req.body.edt_email_Gem != -1) {
                reward.push({
                    "type": 1,
                    "quantity": req.body.edt_email_Gem
                });
            }


            if (req.body.edt_email_boost_x2 != -1) {
                reward.push({
                    "type": 2,
                    "quantity": req.body.edt_email_boost_x2
                });
            }


            if (req.body.edt_email_boost_pan != -1) {
                reward.push({
                    "type": 3,
                    "quantity": req.body.edt_email_boost_pan
                });
            }

            if (req.body.edt_email_boost_time != -1) {
                reward.push({
                    "type": 4,
                    "quantity": req.body.edt_email_boost_time
                });
            }

            if (req.body.edt_email_boost_cake != -1) {
                reward.push({
                    "type": 5,
                    "quantity": req.body.edt_email_boost_cake
                });
            }

            if (req.body.edt_email_boost_ice != -1) {
                reward.push({
                    "type": 6,
                    "quantity": req.body.edt_email_boost_ice
                });
            }

            if (req.body.edt_email_boost_serve != -1) {
                reward.push({
                    "type": 7,
                    "quantity": req.body.edt_email_boost_serve
                });
            }

            if (req.body.edt_email_infinite_heart != -1) {
                reward.push({
                    "type": 8,
                    "quantity": req.body.edt_email_infinite_heart
                });
            }

            if (req.body.edt_email_nm_time != -1) {
                reward.push({
                    "type": 12,
                    "quantity": req.body.edt_email_nm_time
                });
            }

            if (req.body.edt_email_nm_cus != -1) {
                reward.push({
                    "type": 13,
                    "quantity": req.body.edt_email_nm_cus
                });
            }

            if(req.body.edt_email_combo != -1 ){
                reward.push({
                    "type":17,
                    "quantity": req.body.edt_email_combo
                });
            }

            if(req.body.edt_email_happy_hand != -1 ){
                reward.push({
                    "type":18,
                    "quantity": req.body.edt_email_happy_hand
                });
            }

            if(req.body.edt_email_mm_unlimit != -1 ){
                reward.push({
                    "type":19,
                    "quantity": req.body.edt_email_mm_unlimit
                });
            }

            if(req.body.edt_email_telfon_unlimit != -1 ){
                reward.push({
                    "type":20,
                    "quantity": req.body.edt_email_telfon_unlimit
                });
            }

            if(req.body.edt_email_ff_unlimit != -1 ){
                reward.push({
                    "type":21,
                    "quantity": req.body.edt_email_ff_unlimit
                });
            }

            if(req.body.edt_email_nsc != -1 ){
                reward.push({
                    "type":22,
                    "quantity": req.body.edt_email_nsc
                });
            }
            
            if(req.body.edt_email_ff_combo_unlimit != -1 ){
                reward.push({
                    "type":24,
                    "quantity": req.body.edt_email_ff_combo_unlimit
                });
            }
            if(req.body.edt_email_helping_hand != -1 ){
                reward.push({
                    "type":25,
                    "quantity": req.body.edt_email_helping_hand
                });
            }

            let objGiftForcset = {
                "res": ress,
                "reward": reward
            };



            dataSend.gift = JSON.stringify(objGiftForcset);

        }
    }
    const dataExtention = {
        disable_interstitial : req.body.disable_interstitial ?? '',
        buy_dailybonus_pack1 : req.body.buy_dailybonus_pack1 ?? '',
        total_money_spent : req.body.total_money_spent ?? '',
        buy_in_app_count : req.body.buy_in_app_count ?? '',
        set_delivery_pack : req.body.set_delivery_pack ?? ''
    }

 
    for (const key in dataExtention) {
        if (!dataExtention[key]) {
        delete dataExtention[key];
        }
    }

    console.log("dataExtention",dataExtention)
    var dataSendMulti = dataSendMulti = {
        user_ids: JSON.stringify(arrIds),
        title: req.body.edt_Title,
        content: req.body.edt_Content,
        sent_by: req.body.edt_email_send_name,
        email_type: req.body.edt_MessageType,
        content_notification : req.body.edt_PN,
        data_ext : JSON.stringify(dataExtention),
        time_expire:expireTime
    };
console.log("dataSendMulti",dataSendMulti);
    if (req.body.edt_MessageType == 1) {
        // gift
        let objGift = [];

        if (req.body.edt_email_Gem != 0) {
            objGift.push({
                "type": 1,
                "quantity": req.body.edt_email_Gem
            });
        }

        for (var coin_i = 1; coin_i <= 100; coin_i++) {
            if (req.body["edt_email_Coin" + coin_i] != 0 || req.body["edt_email_key_" + coin_i] != 0) {
                objGift.push({
                    "type": 0,
                    "quantity": req.body["edt_email_Coin" + coin_i],
                    "key": req.body["edt_email_key_" + coin_i],
                    "resId": coin_i
                });
            }
        }

        if (req.body.edt_email_boost_x2 != 0) {
            objGift.push({
                "type": 2,
                "quantity": req.body.edt_email_boost_x2
            });
        }


        if (req.body.edt_email_boost_pan != 0) {
            objGift.push({
                "type": 3,
                "quantity": req.body.edt_email_boost_pan
            });
        }

        if (req.body.edt_email_boost_time != 0) {
            objGift.push({
                "type": 4,
                "quantity": req.body.edt_email_boost_time
            });
        }

        if (req.body.edt_email_boost_cake != 0) {
            objGift.push({
                "type": 5,
                "quantity": req.body.edt_email_boost_cake
            });
        }

        if (req.body.edt_email_boost_ice != 0) {
            objGift.push({
                "type": 6,
                "quantity": req.body.edt_email_boost_ice
            });
        }

        if (req.body.edt_email_boost_serve != 0) {
            objGift.push({
                "type": 7,
                "quantity": req.body.edt_email_boost_serve
            });
        }

        if (req.body.edt_email_infinite_heart != 0) {
            objGift.push({
                "type": 8,
                "quantity": req.body.edt_email_infinite_heart
            });
        }

        if (req.body.edt_email_nm_time != 0) {
            objGift.push({
                "type": 12,
                "quantity": req.body.edt_email_nm_time
            });
        }

        if (req.body.edt_email_nm_cus != 0) {
            objGift.push({
                "type": 13,
                "quantity": req.body.edt_email_nm_cus
            });
        }

        if(req.body.edt_email_combo != 0) {
            objGift.push({
                "type":17,
                "quantity": req.body.edt_email_combo
            });
        }
        
        if(req.body.edt_email_happy_hand != 0) {
            objGift.push({
                "type":18,
                "quantity":req.body.edt_email_happy_hand
            });
        } 

        if(req.body.edt_email_mm_unlimit != 0) {
            objGift.push({
                "type":19,
                "quantity":req.body.edt_email_mm_unlimit
            });
        } 

        if(req.body.edt_email_telfon_unlimit != 0) {
            objGift.push({
                "type":20,
                "quantity":req.body.edt_email_telfon_unlimit
            });
        } 

        if(req.body.edt_email_ff_unlimit != 0) {
            objGift.push({
                "type":21,
                "quantity":req.body.edt_email_ff_unlimit
            });
        } 

        if(req.body.edt_email_nsc != 0) {
            objGift.push({
                "type":22,
                "quantity":req.body.edt_email_nsc
            });
        } 
        if(req.body.edt_email_ff_combo_unlimit != 0) {
            objGift.push({
                "type":24,
                "quantity":req.body.edt_email_ff_combo_unlimit
            });
        } 
        if(req.body.edt_email_helping_hand != 0) {
            objGift.push({
                "type":25,
                "quantity":req.body.edt_email_helping_hand
            });
        } 

        dataSendMulti.gift = JSON.stringify(objGift);

    }
    else {
        if (req.body.edt_MessageType == 3 || req.body.edt_MessageType == 4) {

            let ress = [];
            for (var i = 1; i <= 100; i++) {
                if (req.body["edt_email_Coin" + i] != null) {
                    let res1 = {
                        "id": i,
                        "level": req.body["edt_email_levels_" + i],
                        "coin": req.body["edt_email_Coin" + i],
                        "lvl_stage": req.body["edt_email_tier_" + i],
                        "unlock_state": req.body["edt_email_unlock_state_" + i],
                        "total_stars": req.body["edt_email_total_stars_" + i],
                        "key": req.body["edt_email_key_" + i]
                    };
                    ress.push(res1);
                }
            }
            // console.log("ress: " +JSON.stringify(ress));

            let reward = [];
            if (req.body.edt_email_Gem != -1) {
                reward.push({
                    "type": 1,
                    "quantity": req.body.edt_email_Gem
                });
            }


            if (req.body.edt_email_boost_x2 != -1) {
                reward.push({
                    "type": 2,
                    "quantity": req.body.edt_email_boost_x2
                });
            }


            if (req.body.edt_email_boost_pan != -1) {
                reward.push({
                    "type": 3,
                    "quantity": req.body.edt_email_boost_pan
                });
            }

            if (req.body.edt_email_boost_time != -1) {
                reward.push({
                    "type": 4,
                    "quantity": req.body.edt_email_boost_time
                });
            }

            if (req.body.edt_email_boost_cake != -1) {
                reward.push({
                    "type": 5,
                    "quantity": req.body.edt_email_boost_cake
                });
            }

            if (req.body.edt_email_boost_ice != -1) {
                reward.push({
                    "type": 6,
                    "quantity": req.body.edt_email_boost_ice
                });
            }

            if (req.body.edt_email_boost_serve != -1) {
                reward.push({
                    "type": 7,
                    "quantity": req.body.edt_email_boost_serve
                });
            }

            if (req.body.edt_email_infinite_heart != -1) {
                reward.push({
                    "type": 8,
                    "quantity": req.body.edt_email_infinite_heart
                });
            }

            if (req.body.edt_email_nm_time != -1) {
                reward.push({
                    "type": 12,
                    "quantity": req.body.edt_email_nm_time
                });
            }

            if (req.body.edt_email_nm_cus != -1) {
                reward.push({
                    "type": 13,
                    "quantity": req.body.edt_email_nm_cus
                });
            }

            if(req.body.edt_email_combo != -1 ){
                reward.push({
                    "type":17,
                    "quantity": req.body.edt_email_combo
                });
            }

            if(req.body.edt_email_happy_hand != -1 ){
                reward.push({
                    "type":18,
                    "quantity": req.body.edt_email_happy_hand
                });
            }

            if(req.body.edt_email_mm_unlimit != -1 ){
                reward.push({
                    "type":19,
                    "quantity": req.body.edt_email_mm_unlimit
                });
            }

            if(req.body.edt_email_telfon_unlimit != -1 ){
                reward.push({
                    "type":20,
                    "quantity": req.body.edt_email_telfon_unlimit
                });
            }

            if(req.body.edt_email_ff_unlimit != -1 ){
                reward.push({
                    "type":21,
                    "quantity": req.body.edt_email_ff_unlimit
                });
            }

            if(req.body.edt_email_nsc != -1 ){
                reward.push({
                    "type":22,
                    "quantity": req.body.edt_email_nsc
                });
            }
            if(req.body.edt_email_ff_combo_unlimit != -1 ){
                reward.push({
                    "type":24,
                    "quantity": req.body.edt_email_ff_combo_unlimit
                });
            }
            if(req.body.edt_email_helping_hand != -1 ){
                reward.push({
                    "type":25,
                    "quantity": req.body.edt_email_helping_hand
                });
            }


            let objGiftForcset = {
                "res": ress,
                "reward": reward
            };



            dataSendMulti.gift = JSON.stringify(objGiftForcset);

        }
    }


    req.app.UserDA.admin_send_email_multi(dataSendMulti, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});

router.get('/gem_log', function (req, res) {
    return res.render('users/gem_log', { search_form: {}, listUsers: [] });
});

router.post('/gem_log', function (req, res) {
    let search_form = {
        user_id: req.body.searchUserId.replace(' ', '') == '' ? 0 : eval(req.body.searchUserId),
        page: req.body.page || 0
    }

    req.app.UserDA.admin_user_gem_log(search_form, function (err, data) {
        console.log(data);
        return res.render('users/gem_log', { search_form: search_form, listUsers: data || [] });

    });

});

router.get('/email_list', function (req, res) {
    return res.render('users/email_list', { search_form: {}, listUsers: [] });
});

router.post('/email_list', function (req, res) {
    let search_form = {
        user_id: req.body.searchUserId.replace(' ', '') == '' ? 0 : eval(req.body.searchUserId),
        page: req.body.page || 0
    }

    req.app.UserDA.admin_email_list_get(search_form, function (err, data) {
        console.log(data);
        return res.render('users/email_list', { search_form: search_form, listUsers: data || [] });

    });

});

router.post('/delete_email', function (req, res) {
    console.log(req.body.delete_edt_Id);
    req.app.UserDA.admin_delete_email({
        user_id: req.body.delete_edt_Id
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});

router.get("/user_banned",function(req,res){
    return res.render('users/user_banned', { search_form: {}, listUsers: [] });
})
router.get("/user_unbanned",function(req,res){
    return res.render('users/user_unbanned', { search_form: {}, listUsers: [] });
})

router.post('/ban_user', function (req, res) {
    console.log(req.body.delete_edt_Id);
    req.app.UserDA.admin_ban_or_unban_user({
        user_id: req.body.delete_edt_Id,
        is_banned: 1
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });


    const url = `${app_configs.app_config_urlServer}/admin/user_add_banned_cache`;
    const data = {
      user_id: req.body.delete_edt_Id,
      secret_key: `${app_configs.secret_key}`
    };
    const config = {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      transformRequest: [(data) => {
        const params = new URLSearchParams();
        for (const key in data) {
          params.append(key, data[key]);
        }
        return params.toString();
      }]
    };
    
    axios.post(url, data, config)
      .then(response => {
        console.log('user_add_banned_cache Response:', response.data);
     
        console.log(`Add banned user redis user = ${req.body.delete_edt_Id} from CMS :  $ ${response.status} ` );
      })
      .catch(error => {
        console.error('Error:', error);
      });

});


router.post('/unban_user', function (req, res) {
    console.log(req.body.delete_edt_Id);
    req.app.UserDA.admin_ban_or_unban_user({
        user_id: req.body.delete_edt_Id,
        is_banned: 0
    }, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
    // Post data to ban 
    const url = `${app_configs.app_config_urlServer}/admin/user_clear_banned_cache`;
    const data = {
      user_id: req.body.delete_edt_Id,
      secret_key: `${app_configs.secret_key}`
    };
    const config = {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      transformRequest: [(data) => {
        const params = new URLSearchParams();
        for (const key in data) {
          params.append(key, data[key]);
        }
        return params.toString();
      }]
    };
    
    axios.post(url, data, config)
      .then(response => {
        console.log('user_clear_banned_cache Response:', response.data);
     
        console.log(`Clear banned user redis user = ${req.body.delete_edt_Id} from CMS :  $ ${response.status} ` );
      })
      .catch(error => {
        console.error('Error:', error);
      });

    });
 

module.exports = router;
