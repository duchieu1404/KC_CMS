CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_user_data_delete_all_info_by_category`(in V_IN_USER_ID int, in V_IN_CATE varchar(100))
BEGIN
  
	
	set @V_IN_USER_ID:= V_IN_USER_ID;
	set @V_IN_CATE := V_IN_CATE;
	

SET @sql_create_table = concat("delete from `user_data_",V_IN_CATE,"_recently` where user_id = ",V_IN_USER_ID," limit 1;");
PREPARE stmt FROM @sql_create_table;
EXECUTE stmt;

commit;
END