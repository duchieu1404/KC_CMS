CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_list_iap_history`(in V_IN_USER_ID int,
IN  V_IN_START_DATE datetime ,IN  V_IN_END_DATE datetime ,IN V_PAGE_SIZE INT , IN V_PAGE INT)
LB_OUT: BEGIN 

IF (V_PAGE IS NULL ) THEN 
 SET V_PAGE := 0;
END IF ;

IF (V_PAGE_SIZE IS NULL) THEN
	SET V_PAGE_SIZE := 10;
END IF;

SELECT iap.user_id , iap.transaction_id  , iap_details.purchase_failure_reason,utils_format_datetime(iap_details.created_time)  created_time ,
iap.product_id, case when iap_details.purchase_state = "CLIENT_REWARDED" then utils_format_datetime(iap.time_reward) else "" end  as time_reward,
		 iap_details.purchase_state ,
		iap.purchase_pack ,
		iap_details.attempt


 FROM iap_transaction iap  join iap_transaction_fail_detail iap_details on iap.id  =  iap_details.id_iap_transaction WHERE iap.user_id = V_IN_USER_ID and (iap_details.created_time > V_IN_START_DATE  or iap_details.created_time = V_IN_START_DATE ) and (iap_details.created_time < V_IN_END_DATE or iap_details.created_time = V_IN_END_DATE) order by iap_details.id desc limit  V_PAGE,V_PAGE_SIZE ;

END