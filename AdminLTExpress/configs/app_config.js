/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var app_config = {};

app_config.mySQLConfig = {
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'jEW9^Au@X_;[Qc{!Br}V)w',
    database:'Kitchen_Craze_Live_001',
    charset : 'utf8mb4_general_ci',
    waitForConnections : true,  // Determines the pool's action when no connections are available and the limit has been reached. If true, the pool will queue the connection request and call it when one becomes available. If false, the pool will immediately call back with an error. (Default: true)
    queueLimit :0, //The maximum number of connection requests the pool will queue before returning an error from
    getConnection:0 //. If set to 0, there is no limit to the number of queued connection requests. (Default: 0)
}

app_config.onesignal_config =  {
    userAuthKey: "",
    app: { appAuthKey: "MTBiOTYxYjUtYzFjZC00MGQyLTk5NTQtZjcwZTY5NTkwZjZi",
        appId: "7c076858-2a4d-48d9-8fbe-187d3f45d594" }
};

app_config.system_config = {
    auto_push_interval:10000
}

app_config.option_clearCache = {
    url: 'https://apicookingpublishdev.flowmotionentertainment.com/apix/clear_all_cache',
    json: true,
}
app_config.app_config_urlServer = 'https://apicookingpublishdev.flowmotionentertainment.com';
app_config.secret_key = 'c00K_crush@007';
app_config.apm={
    serviceName: 'APM-CMS-Crush',
    secretToken: '',
    serverUrl: 'http:127.0.0.1:8200', 
    environment: 'develop',
    exitSpanMinDuration: '10ms'
}

module.exports = exports = app_config;
