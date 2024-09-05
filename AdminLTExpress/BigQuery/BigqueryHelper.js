
const {BigQuery} = require('@google-cloud/bigquery');
const moment = require('moment');
const options = {
    keyFilename: '../AdminLTExpress/BigQuery/Token/cook-it-rewrite-bfb713d9aa68.json',
    projectId: 'cook-it-rewrite',
  };
 const bigqueryClient = new BigQuery(options);
  // Tạo table thành công
  async function createTableToBigquery(dataSetId,tableId,dataInsert){
    const schema = [
        { name :"user_id",type :"INTEGER",node :"required"},
        { name :"gan_user_pseudo_id",type :"STRING"},
        { name :"DEVICE_ID",type :"STRING"},
        { name :"gem_balance",type :"INTEGER"},
        { name :"banned_time",type :"STRING"},
        { name :"start_version",type :"STRING"},
        {name :"app_version",type :"STRING"},
        { name :"total_buy_iap",type :"INTEGER"},
        {name :"total_money_spent",type :"float"}
    ]
    const optional = {
        location : "US",
        schema :schema
    };
    await bigqueryClient.dataset(dataSetId).createTable(tableId,optional);
    console.log(`table created  ${tableId} created`);
}
//  thêm mới vào bảng 
async function insertRows(dataSetId,tableId,data_insert){
     
    try{
        console.log("data insert push to biquery at ", JSON.stringify(data_insert) );
        if(data_insert.length > 0){
            await bigqueryClient.dataset(dataSetId).table(tableId).insert(data_insert);
            console.log("push data user banned successfully to  biquery at ",  moment(new Date()).format("YYYY:MM:DD hh:mm:ss"));
         }else {
            console.log("Because this data users banned is empty at ",  moment(new Date()).format("YYYY:MM:DD hh:mm:ss"));
         }
    }catch(e){
        console.error("Error when push data users banned to bigquery is message ", JSON.stringify(e) , " ",  moment(new Date()).format("YYYY:MM:DD hh:mm:ss"));
    }
}

 module.exports.helperBigquery =  function(dataSetId,tableId,data_insert){
   try {
     insertRows(dataSetId,tableId,data_insert);
   } catch (error) {
    console.error(error);
   }
 }