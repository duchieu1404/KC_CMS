/**
 * Created by luckyman on 4/19/17.
 */
var express = require('express');
var router = express.Router();
var app_configs = require('../configs/app_config');
const axios = require('axios');
router.get('/',function(req, res) {
    req.DA.admin_get_list_events([],function reload_list_events(err,dataX){
        if(err || !dataX)
        {
            return res.render('admin/events/events',{dataEvent:[]});
        }
        return res.render('admin/events/events',{dataEvent:dataX});
    });
});

router.post('/duplicate/:event_id',function(req, res){
    req.DA.admin_event_duplicate({event_id:req.param('event_id')},function reload_list_events(err,dataX){
        if(err || !dataX)
        {
            return res.redirect('/admin/events');
        }
        return res.redirect('/admin/events');
    });
});


router.post('/delete/:event_id',function(req, res){
    req.DA.admin_event_delete({event_id:req.param('event_id')},function reload_list_events(err,dataX){
        if(err || !dataX)
        {
            return res.redirect('/admin/events');
        }
        return res.redirect('/admin/events');
    });
});

router.post('/events',function(req, res) {
    console.log("charge_card search : ",req.body);
    req.DA.admin_save_events_info({
         id:req.body.edt_id
        ,os_show:req.body.edt_os_show
        ,version_name:req.body.edt_version_name
        ,disable_review:req.body.edt_disable_review
        ,event_status:req.body.edt_event_status
        ,from_time:req.body.edt_from_time
        ,to_time:req.body.edt_to_time
        ,force_view:req.body.edt_force_view
        ,title:req.body.edt_title
        ,content:req.body.edt_content
        ,img_small:req.body.edt_img_small
        ,img_full:req.body.edt_img_full
        ,web_url:req.body.edt_web_url
        ,btn1_skin:req.body.edt_btn1_skin
        ,btn1_label:req.body.edt_btn1_label
        ,btn1_action:req.body.edt_btn1_action
        ,btn1_data:req.body.edt_btn1_data
        ,btn2_skin:req.body.edt_btn2_skin
        ,btn2_label:req.body.edt_btn2_label
        ,btn2_action:req.body.edt_btn2_action
        ,btn2_data:req.body.edt_btn2_data
    },function getServerConfig(err,dataX){
        if(err || !dataX)
        {
            return res.redirect('/admin/events/events');
        }
        return res.redirect('/admin/events/events');
    });
});

router.get('/user_leaderboards', function (req, res) {
    return res.render('event/user_leaderboards', {search_form: {}, listUsers: []});
});

router.post('/user_leaderboards', function (req, res) {
    let search_form = {
        event_id: req.body.searchEventId,
        rest_id: req.body.searchRestId,
        page_size: req.body.searchPageSize,
        page: req.body.page || 0
    }

    req.app.EventDA.list_user_score_by_event(search_form, function (err, data) {
        return res.render('event/user_leaderboards', { search_form: search_form, listUsers: data || [] });
    });
});

router.post('/update_user_score_by_event', function (req, res) {
    let params = {
        event_id: req.body.event_id,
        rest_id: req.body.rest_id,
        user_id: req.body.user_id,
        score: req.body.score,
        reason: req.body.reason,
        creator: req.body.creator,
    }

    req.app.EventDA.update_user_score_by_event(params, function (err, data) {
        return res.send(data || { status: 1, msg: "err" });
    });
});

router.get('/user_score_changed', function (req, res) {
    return res.render('event/user_score_changed', {search_form: {}, listData: []});
});

router.post('/user_score_changed', function (req, res) {
    let search_form = {
    }
    req.app.TeamDA.list_user_score_changed(search_form, function (err, data) {
        return res.render('event/user_score_changed', { search_form: search_form, listData: data || [] });
    });
});

/** History */
router.get('/champion_tournament_history', function (req, res) {
    return res.render('event/champion_tournament_history', {search_form: {}, listHistorys: []});
});

router.post('/champion_tournament_history', function (req, res) {
    const data = {
        user_id: req.body.user_id,
        event_id: req.body.event_id,
        size: req.body.size ? req.body.size : 10,
        page: req.body.page || 0,
        secret_key: `${app_configs.secret_key}`
    }
//    console.log('request=', data);
    const url = `${app_configs.app_config_urlServer}/admin/getAllChampionPage`;
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
//        console.log('response=', response.data);
        return res.send(response.data);
      })
      .catch(error => {
        console.error('Error:', error);
        return res.send('{ status: 1, msg: "err" }');
      });
    // req.app.TeamDA.list_iap_history(search_form, function (err, data) {
    //     return res.render('iap/iap_history', { search_form: search_form, listIapHistorys: data || [] });
    // });
});
require('../module/event_approval').protect(router, 'events', require('../module/event_approval').protectedEvent);
module.exports = router;
