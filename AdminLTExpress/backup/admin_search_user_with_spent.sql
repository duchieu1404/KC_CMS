CREATE DEFINER=`root`@`localhost` PROCEDURE `cooking_crush_002`.`admin_search_user_with_spent`(in V_IN_ADMIN_ID int,
in V_IN_USER_ID int,
in V_IN_FULLNAME varchar(100),
in V_IN_DEVICE_ID varchar(100),
in V_IN_USER_PSEUDO_ID varchar(100),
in V_IN_MIN_SPENT float,
in V_IN_OFFSET int,
in V_IN_LIMIT_RECORD int)
LB_SELECT:BEGIN
  
	
	DECLARE x_user_id_with_device_id int;
	if(V_IN_USER_ID <> 0 ) then 
			call user_move_to_recently(V_IN_USER_ID);
			select 
				a.id,
				a.fullname,
				a.last_device_id,
				a.login_type,
				a.username,
				a.other_info,
				ifnull(a.is_banned, 0) "is_banned",

				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.language')) `language`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.device_name')) `device_name`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.os')) `os`,	
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.user_pseudo_id')) `user_pseudo_id`,
				JSON_EXTRACT(b.`data`, '$.pg') gem,		
				JSON_EXTRACT(b.`data`, '$.total_stars') star,
				JSON_EXTRACT(d.`data`, '$.total_money_spent') money_spent,
				JSON_UNQUOTE(JSON_EXTRACT(f.`data`, '$.start_version')) start_version


		from user_recently a
		 left join user_data_cr_i_recently b on  a.id = V_IN_USER_ID and  a.id = b.user_id
		 left join user_data_cr_s_recently c on  a.id = V_IN_USER_ID and  a.id = c.user_id
		 left join user_data_cr_f_recently d on  a.id = V_IN_USER_ID and  a.id = d.user_id
		 left join user_data_write_one_s_recently f on a.id = V_IN_USER_ID and a.id = f.user_id

		 where id = V_IN_USER_ID limit 0,1
;
		
			LEAVE LB_SELECT;
	end if;
		if(V_IN_DEVICE_ID is not null and V_IN_DEVICE_ID <> '0' and V_IN_DEVICE_ID <> '') then
			select 
				a.id,
				a.fullname,
				a.last_device_id,
				a.login_type,
				a.username,
				a.other_info,
				ifnull(a.is_banned, 0) "is_banned",

				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.language')) `language`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.device_name')) `device_name`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.os')) `os`,	
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.user_pseudo_id')) `user_pseudo_id`,
				JSON_EXTRACT(b.`data`, '$.pg') gem,		
				JSON_EXTRACT(b.`data`, '$.total_stars') star,
				JSON_EXTRACT(d.`data`, '$.total_money_spent') money_spent,
				JSON_UNQUOTE(JSON_EXTRACT(f.`data`, '$.start_version')) start_version


		from user_recently a
		 left join user_data_cr_i_recently b on  a.id = b.user_id
		 left join user_data_cr_s_recently c on  a.id = c.user_id
		 left join user_data_cr_f_recently d on  a.id = d.user_id
		 left join user_data_write_one_s_recently f on a.id = f.user_id

		 where a.last_device_id = V_IN_DEVICE_ID limit 0,5;

		
			LEAVE LB_SELECT;
	end if;
	
	
	if(V_IN_FULLNAME is not null and V_IN_FULLNAME <> '0' and V_IN_FULLNAME <> '' ) then
			select 
				a.id,
				a.fullname,
				a.last_device_id,
				a.login_type,
				a.username,
				a.other_info,
				ifnull(a.is_banned, 0) "is_banned",

				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.language')) `language`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.device_name')) `device_name`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.os')) `os`,	
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.user_pseudo_id')) `user_pseudo_id`,
				JSON_EXTRACT(b.`data`, '$.pg') gem,		
				JSON_EXTRACT(b.`data`, '$.total_stars') star,
				JSON_EXTRACT(d.`data`, '$.total_money_spent') money_spent,
				JSON_UNQUOTE(JSON_EXTRACT(f.`data`, '$.start_version')) start_version


		from user_recently a
		 left join user_data_cr_i_recently b on  a.id = b.user_id
		 left join user_data_cr_s_recently c on a.id = c.user_id
		 left join user_data_cr_f_recently d on   a.id = d.user_id
		 left join user_data_write_one_s_recently f on a.id = f.user_id

		 where a.fullname = V_IN_FULLNAME limit 0,10;

		
			LEAVE LB_SELECT;
	end if;
	
	if(V_IN_USER_PSEUDO_ID is not null and V_IN_USER_PSEUDO_ID <> '0' and V_IN_USER_PSEUDO_ID <> '' ) then
			select 
				a.id,
				a.fullname,
				a.last_device_id,
				a.login_type,
				a.username,
				a.other_info,
				ifnull(a.is_banned, 0) "is_banned",

				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.language')) `language`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.device_name')) `device_name`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.os')) `os`,	
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.user_pseudo_id')) `user_pseudo_id`,
				JSON_EXTRACT(b.`data`, '$.pg') gem,		
				JSON_EXTRACT(b.`data`, '$.total_stars') star,
				JSON_EXTRACT(d.`data`, '$.total_money_spent') money_spent,
				JSON_UNQUOTE(JSON_EXTRACT(f.`data`, '$.start_version')) start_version


		from user_recently a
		 left join user_data_cr_i_recently b on  a.id = b.user_id
		 left join user_data_cr_s_recently c on a.id = c.user_id
		 left join user_data_cr_f_recently d on   a.id = d.user_id
		 left join user_data_write_one_s_recently f on a.id = f.user_id

		 where JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.user_pseudo_id')) = V_IN_USER_PSEUDO_ID limit 0,10;

		
			LEAVE LB_SELECT;
	end if;
	
	
	set @v_in_min_spent := V_IN_MIN_SPENT;
select 
		a.id,
		a.fullname,
		a.last_device_id,
		a.login_type,
				a.username,
				a.other_info,
				ifnull(a.is_banned, 0) "is_banned",
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.language')) `language`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.device_name')) `device_name`,		
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.os')) `os`,	
				JSON_UNQUOTE(JSON_EXTRACT(a.`other_info`, '$.user_pseudo_id')) `user_pseudo_id`,
				JSON_EXTRACT(b.`data`, '$.pg') gem,		
				JSON_EXTRACT(b.`data`, '$.total_stars') star,
				JSON_EXTRACT(d.`data`, '$.total_money_spent') money_spent,
				JSON_UNQUOTE(JSON_EXTRACT(f.`data`, '$.start_version')) start_version
		from user_recently a 
					left join user_data_cr_i_recently b on   a.id = b.user_id
				left join user_data_cr_f_recently d on   a.id = d.user_id
				left join user_data_write_one_s_recently f on a.id = f.user_id
 where (JSON_EXTRACT(d.`data`, '$.total_money_spent') >= @v_in_min_spent) order by 
 JSON_EXTRACT(d.`data`, '$.total_money_spent') asc LIMIT V_IN_OFFSET,V_IN_LIMIT_RECORD;commit;
		


END