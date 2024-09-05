var express = require('express');
var router = express.Router();

router.post('/iap_history', function (req, res) {
    console.log(req.body);
    
    let search_form = {
        user_id: req.body.searchUserId,
        start_time: req.body.searchStartTime ? req.body.searchStartTime + " 00:00:00"   : new Date(),
        end_time : req.body.searchEndTime ? req.body.searchEndTime + " 23:59:00" : new Date(),
        start_time_inp: req.body.searchStartTime ? req.body.searchStartTime  : new Date(),
        end_time_inp : req.body.searchEndTime ? req.body.searchEndTime : new Date(),
        page_size: req.body.searchPageSize ? req.body.searchPageSize : 10,
        page: req.body.page || 0
    }

    req.app.TeamDA.list_iap_history(search_form, function (err, data) { 
        return res.render('iap/iap_history', { search_form: search_form, listIapHistorys: data || [] });
    });
});
router.get('/iap_history', function (req, res) {
    return res.render('iap/iap_history', {search_form: {}, listIapHistorys: []});
});
module.exports = router;