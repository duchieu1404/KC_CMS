CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_search_user`(in V_IN_ADMIN_ID int,
in V_IN_USER_ID int,
in V_IN_FULLNAME varchar(100),
in V_IN_DEVICE_ID varchar(100))
LB_SELECT:BEGIN
  
	
	if(V_IN_USER_ID <> 0 ) then 
			call user_move_to_recently(V_IN_USER_ID);
			select 
				a.id,
				a.fullname,
				a.last_device_id,
				a.login_type,
				a.time_created,
				a.last_time_sync,
				a.is_banned,
				a.type_banned,
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.language')) `language`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.device_name')) `device_name`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.os')) `os`,
				JSON_EXTRACT(c.`data`, '$.unlock_res') unlock_res,		
				JSON_EXTRACT(b.`data`, '$.pg') gem,		
				JSON_EXTRACT(b.`data`, '$.total_stars') star,
				JSON_EXTRACT(b.`data`, '$.total_money_spent') money_spent,
			  JSON_UNQUOTE(JSON_EXTRACT(d.`data`, '$.start_version')) start_version

		from user_recently a
		left join user_data_cr_i_recently b on  a.id = V_IN_USER_ID and  a.id = b.user_id
		left join user_data_cr_s_recently c on  a.id = V_IN_USER_ID and  a.id = c.user_id
		left join user_data_write_one_s_recently d on a.id = V_IN_USER_ID and a.id = d.user_id
		;
		
			LEAVE LB_SELECT;
	end if;
	
	
		select 
		a.id,
		a.fullname,
		a.last_device_id,
		a.login_type,
		a.time_created,
		a.last_time_sync,
		a.is_banned,
		a.type_banned,
		JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.language')) `language`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.device_name')) `device_name`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.os')) `os`,
				JSON_EXTRACT(c.`data`, '$.unlock_res') unlock_res,		
				JSON_EXTRACT(b.`data`, '$.pg') gem,		
				JSON_EXTRACT(b.`data`, '$.total_stars') star,
				JSON_EXTRACT(b.`data`, '$.total_money_spent') money_spent,
				JSON_UNQUOTE(JSON_EXTRACT(d.`data`, '$.start_version')) start_version
			
		from user_recently a 
			left	join user_data_cr_i_recently b on    a.id = b.user_id
			left	join user_data_cr_s_recently c on    a.id = c.user_id
			left join user_data_write_one_s_recently d on a.id = d.user_id
				
		where ((V_IN_FULLNAME <> '' and a.fullname like concat('%',V_IN_FULLNAME,'%'))
		or (V_IN_FULLNAME = '' and (V_IN_DEVICE_ID = '' or a.last_device_id = V_IN_DEVICE_ID))) 
		limit 0,100;


END