CREATE DEFINER=`root`@`localhost` PROCEDURE `cooking_crush_002`.`user_login_by_device_id`(in V_IN_DEVICE_ID varchar(100),
in V_IN_LAST_USER_ID int,
in V_IN_CLIENT_INFO longtext,
in V_IN_USER_BASIC_INFO text)
LB_LOGIN:BEGIN
  
DECLARE x_current_user_id int;
DECLARE x_user_basic_data text;
DECLARE x_fullname varchar(100);
DECLARE x_other_info text;
DECLARE x_all_data longtext;
DECLARE x_last_time_sync datetime;

DECLARE x_old_user_id int;
DECLARE x_check_show_popup int; 

DECLARE x_avatar_id int;
DECLARE x_avatar_url varchar(2000);
DECLARE x_ref_code varchar(10);
DECLARE x_is_version_154 int;
DECLARE x_is_version_161 int;
DECLARE x_data_is_empty int;
DECLARE x_user_start_version varchar(20);
DECLARE x_checked int;
DECLARE x_is_banned int default 0;

set x_user_start_version:= JSON_UNQUOTE(JSON_EXTRACT(ifnull(V_IN_CLIENT_INFO,'{}'), "$.app_version"));



call user_partion_get_id(V_IN_DEVICE_ID, 0, x_old_user_id);
if(x_old_user_id is not null) then
		call user_move_to_recently(x_old_user_id);
end if; 



select id,fullname,other_info,last_time_sync,avatar_id,avatar_url,ref_code, is_banned
into x_current_user_id ,x_fullname , x_other_info,x_last_time_sync,x_avatar_id,x_avatar_url,x_ref_code, x_is_banned
from user_recently
where id = x_old_user_id 
limit 0,1;

if(x_is_banned is null) then
	set x_is_banned:= 0;
end if;


call utils_compare_string_version("1.5.3", x_user_start_version, x_is_version_154);
call utils_compare_string_version("1.6.0", x_user_start_version, x_is_version_161);
if (x_is_version_154 = 1 and x_is_version_161 = 0) then 
	if(V_IN_LAST_USER_ID is not null  and  V_IN_LAST_USER_ID <> 0 and  x_current_user_id is not null and V_IN_LAST_USER_ID <> x_current_user_id) then 
	
	select 1 status,"LOGIN_DEVICE_FAILURE" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",0,
								"reason","Device id and user id not match",
								"need_create_new_device",1
							) data;
				commit;
				LEAVE LB_LOGIN;

	end if;

	if(x_current_user_id is null) then 
				
				call user_create_referal_code(x_ref_code) ;
				insert into user_recently(username,login_type,last_device_id, last_time_sync, time_created, other_info,ref_code)
				values(V_IN_DEVICE_ID, 0, V_IN_DEVICE_ID, now(),now(),V_IN_CLIENT_INFO,x_ref_code);
				
				set x_current_user_id:= LAST_INSERT_ID();
				set x_fullname:= concat("Chef"); 

				update user_recently set fullname = x_fullname where id = x_current_user_id limit 1;
				
				call user_partion_save(V_IN_DEVICE_ID,0,x_current_user_id,0);
				call user_partion_save_ref_code(V_IN_DEVICE_ID,0, x_ref_code);
				
				call user_data_init_data_new_user_all_category(x_current_user_id);
				
				call user_first_version_set(x_current_user_id, x_user_start_version);
				call new_old_user_classification(x_current_user_id,x_checked);
				INSERT INTO user_data_log(user_id,type,username,last_time_active) values (x_current_user_id,"New Player",x_fullname,now());
				if (x_checked = 0) then 
				select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"fullname", x_fullname,
								"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											
								"need_force_push",1,
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
							) data;
				else 
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"fullname", x_fullname,
								"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											
								"need_force_push",1,
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
							) data;
				end if ;
				commit;
				LEAVE LB_LOGIN;
	end if;

	update user_recently set other_info = utils_func_update_json_data(ifnull(other_info,'{}'), ifnull(V_IN_CLIENT_INFO,'{}'),'[]'),last_time_active = now() where id = x_current_user_id limit 1;
	
	
	call user_check_basic_data_to_show_sync_device_id(x_current_user_id, V_IN_USER_BASIC_INFO, x_check_show_popup);
	if(V_IN_LAST_USER_ID is null or V_IN_LAST_USER_ID = 0) then 
	
	
	call user_data_get_all_info(x_current_user_id, x_all_data);
	select if(ifnull(data,'{}')="{}",1,0) into x_data_is_empty from user_data_cr_i_recently where user_id = x_current_user_id limit 0,1;
	call user_first_version_set(x_current_user_id, x_user_start_version);
	call new_old_user_classification(x_current_user_id,x_checked);
	
	if(x_checked = 0) then
				if(x_check_show_popup = 0 or x_check_show_popup is null) then 
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
								JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"need_force_push", 1,
									"show_choice_popup",0,
									"fullname", ifnull(x_fullname,concat("Chef")), 
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
													,"ref_code",ifnull(x_ref_code,""),
									"other_info", ifnull(x_other_info,"{}"),
									"basic_data","{}",
									"start_version",x_user_start_version,
									"user_type","N",
									"is_banned", x_is_banned
								) data;
				elseif(x_check_show_popup = 1) then 
												select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
											JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"need_force_push", if(x_data_is_empty = 1, 1,0),
									"need_pull",1,
									"show_choice_popup",0,
									"fullname", ifnull(x_fullname,concat("Chef")), 
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
													,"ref_code",ifnull(x_ref_code,""),
									"other_info", ifnull(x_other_info,"{}"),
									"basic_data","{}",
									"all_data",ifnull(x_all_data,'{}'),
									"start_version",x_user_start_version,
									"user_type","N",
									"is_banned", x_is_banned
								) data;
					elseif(x_check_show_popup = 2) then 
												select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
											JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"need_force_push", 1,
									"show_choice_popup",0,
									"fullname", ifnull(x_fullname,concat("Chef")), 
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
													,"ref_code",ifnull(x_ref_code,""),
									"other_info", ifnull(x_other_info,"{}"),
									"basic_data","{}",
									"start_version",x_user_start_version,
									"user_type","N",
									"is_banned", x_is_banned
								) data;			
					end if;
		else
				if(x_check_show_popup = 0 or x_check_show_popup is null) then 
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
								JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"need_force_push", 1,
									"show_choice_popup",0,
									"fullname", ifnull(x_fullname,concat("Chef")), 
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
													,"ref_code",ifnull(x_ref_code,""),
									"other_info", ifnull(x_other_info,"{}"),
									"basic_data","{}",
									"start_version",x_user_start_version,
									"user_type","O",
									"is_banned", x_is_banned
								) data;
				elseif(x_check_show_popup = 1) then 
												select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
											JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"need_force_push", if(x_data_is_empty = 1, 1,0),
									"need_pull",1,
									"show_choice_popup",0,
									"fullname", ifnull(x_fullname,concat("Chef")), 
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
													,"ref_code",ifnull(x_ref_code,""),
									"other_info", ifnull(x_other_info,"{}"),
									"basic_data","{}",
									"all_data",ifnull(x_all_data,'{}'),
									"start_version",x_user_start_version,
									"user_type","O",
									"is_banned", x_is_banned
								) data;
					elseif(x_check_show_popup = 2) then 
												select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
											JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"need_force_push", 1,
									"show_choice_popup",0,
									"fullname", ifnull(x_fullname,concat("Chef")), 
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
													,"ref_code",ifnull(x_ref_code,""),
									"other_info", ifnull(x_other_info,"{}"),
									"basic_data","{}",
									"start_version",x_user_start_version,
									"user_type","O",
									"is_banned", x_is_banned
								) data;			
					end if;
		end if;

				commit;
				call user_set_active_log(x_current_user_id);
				LEAVE LB_LOGIN;
	end if;

	call user_data_get_all_info(x_current_user_id, x_all_data);
	call user_first_version_set(x_current_user_id, x_user_start_version);
	call new_old_user_classification(x_current_user_id,x_checked);
	if( x_checked = 0) then
		if(x_check_show_popup = 0) then 
					select 0 status
								, "LOGIN_DEVICE_SUCCESS" msg
								, JSON_OBJECT(
											"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
					
					
											"last_time_sync",utils_format_datetime(x_last_time_sync),
					
											"fullname", ifnull(x_fullname,concat("Chef")), 
											"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",ifnull(x_avatar_url,"")
																,"ref_code",ifnull(x_ref_code,""),
	
												"start_version",x_user_start_version,
												"user_type","N",
												"is_banned", x_is_banned
					
											
									) data;
			elseif(x_check_show_popup = 1) then
					select 0 status
								, "LOGIN_DEVICE_SUCCESS" msg
								, JSON_OBJECT(
											"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
					
											"need_pull",1,
											"last_time_sync",utils_format_datetime(x_last_time_sync),
					
											"fullname", ifnull(x_fullname,concat("Chef")), 
											"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",ifnull(x_avatar_url,"")
																,"ref_code",ifnull(x_ref_code,""),
																"all_data",ifnull(x_all_data,"{}"),
												"start_version",x_user_start_version,
												"user_type","N",
												"is_banned", x_is_banned
					
					
											
									) data;
								
				elseif( x_check_show_popup = 2 or x_check_show_popup is null) then 
				
						select 0 status
								, "LOGIN_DEVICE_SUCCESS" msg
								, JSON_OBJECT(
											"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"need_force_push",1,

											"last_time_sync",utils_format_datetime(x_last_time_sync),
					
											"fullname", ifnull(x_fullname,concat("Chef")), 
											"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",ifnull(x_avatar_url,"")
																,"ref_code",ifnull(x_ref_code,""),
	
												"start_version",x_user_start_version,
												"user_type","N",
												"is_banned", x_is_banned
					
											
									) data;
					end if;
		else 
				if(x_check_show_popup = 0) then 
					select 0 status
								, "LOGIN_DEVICE_SUCCESS" msg
								, JSON_OBJECT(
											"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
					
					
											"last_time_sync",utils_format_datetime(x_last_time_sync),
					
											"fullname", ifnull(x_fullname,concat("Chef")), 
											"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",ifnull(x_avatar_url,"")
																,"ref_code",ifnull(x_ref_code,""),
	
												"start_version",x_user_start_version,
												"user_type","O",
												"is_banned", x_is_banned
					
					
											
									) data;
			elseif(x_check_show_popup = 1) then
					select 0 status
								, "LOGIN_DEVICE_SUCCESS" msg
								, JSON_OBJECT(
											"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
					
											"need_pull",1,
											"last_time_sync",utils_format_datetime(x_last_time_sync),
					
											"fullname", ifnull(x_fullname,concat("Chef")), 
											"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",ifnull(x_avatar_url,"")
																,"ref_code",ifnull(x_ref_code,""),
																"all_data",ifnull(x_all_data,"{}"),
												"start_version",x_user_start_version,
												"user_type","O",
												"is_banned", x_is_banned
					
					
											
									) data;
								
				elseif( x_check_show_popup = 2 or x_check_show_popup is null) then 
				
						select 0 status
								, "LOGIN_DEVICE_SUCCESS" msg
								, JSON_OBJECT(
											"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"need_force_push",1,
											"last_time_sync",utils_format_datetime(x_last_time_sync),
					
											"fullname", ifnull(x_fullname,concat("Chef")), 
											"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",ifnull(x_avatar_url,"")
																,"ref_code",ifnull(x_ref_code,""),
	
												"start_version",x_user_start_version,
												"user_type","O",
												"is_banned", x_is_banned
					
					
											
									) data;
			end if;
			call user_set_active_log(x_current_user_id);
		end if;
elseif (x_is_version_154 = 0) then
	if(V_IN_LAST_USER_ID is not null  and  V_IN_LAST_USER_ID <> 0 and  x_current_user_id is not null and V_IN_LAST_USER_ID <> x_current_user_id) then 

	select 1 status,"LOGIN_DEVICE_FAILURE" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",0,
								"reason","Device id and user id not match",
								"need_create_new_device",1
							) data;
				commit;
				LEAVE LB_LOGIN;

	end if;

	if(x_current_user_id is null) then 
				
				call user_create_referal_code(x_ref_code) ;
				insert into user_recently(username,login_type,last_device_id, last_time_sync, time_created, other_info,ref_code)
				values(V_IN_DEVICE_ID, 0, V_IN_DEVICE_ID, now(),now(),V_IN_CLIENT_INFO,x_ref_code);
				
				set x_current_user_id:= LAST_INSERT_ID();
				set x_fullname:= concat("Chef"); 

				update user_recently set fullname = x_fullname where id = x_current_user_id limit 1;
				
				call user_partion_save(V_IN_DEVICE_ID,0,x_current_user_id,0);
				call user_partion_save_ref_code(V_IN_DEVICE_ID,0, x_ref_code);
				
				call user_data_init_data_new_user_all_category(x_current_user_id);
				
				call user_first_version_set(x_current_user_id, x_user_start_version);
				call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then 
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
								JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"fullname", x_fullname,
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
												,"ref_code",ifnull(x_ref_code,""),
												
									"need_force_push",1,
									"start_version",x_user_start_version,
									"user_type","N",
									"is_banned", x_is_banned
								) data;
				else
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
								JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"fullname", x_fullname,
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
												,"ref_code",ifnull(x_ref_code,""),
												
									"need_force_push",1,
									"start_version",x_user_start_version,
									"user_type","O",
									"is_banned", x_is_banned
								) data;
				end if;
				commit;
				LEAVE LB_LOGIN;
	end if;

	update user_recently set other_info = utils_func_update_json_data(ifnull(other_info,'{}'), ifnull(V_IN_CLIENT_INFO,'{}'),'[]') where id = x_current_user_id limit 1;


	if(V_IN_LAST_USER_ID is null or V_IN_LAST_USER_ID = 0) then 


	call user_data_get_all_info(x_current_user_id, x_all_data);

	call user_check_basic_data_to_show_sync_device_id_161(x_current_user_id, V_IN_USER_BASIC_INFO, x_check_show_popup);

	select if(ifnull(data,'{}')="{}",1,0) into x_data_is_empty from user_data_cr_i_recently where user_id = x_current_user_id limit 0,1;

	call user_first_version_set(x_current_user_id, x_user_start_version);
	call new_old_user_classification(x_current_user_id,x_checked);
		if(x_checked = 0) then
				select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"need_force_push", if(x_data_is_empty = 1, 1,0),
								"need_pull",if(x_check_show_popup = 1,0,1),
								"show_choice_popup",if(x_check_show_popup = 1,1,0),
								"fullname", ifnull(x_fullname,concat("Chef")), 
								"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
												,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
							) data;
		else
				select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"need_force_push", if(x_data_is_empty = 1, 1,0),
								"need_pull",if(x_check_show_popup = 1,0,1),
								"show_choice_popup",if(x_check_show_popup = 1,1,0),
								"fullname", ifnull(x_fullname,concat("Chef")), 
								"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
												,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
							) data;
		end if;
		call user_set_active_log(x_current_user_id);
				commit;
				
				LEAVE LB_LOGIN;
	end if;


	call user_check_basic_data_to_show_sync_device_id_161(x_current_user_id, V_IN_USER_BASIC_INFO, x_check_show_popup);
	if(x_check_show_popup is not null and x_check_show_popup = 1) then 
	call user_data_get_all_info(x_current_user_id, x_all_data);

	call user_first_version_set(x_current_user_id, x_user_start_version);
	call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"show_choice_popup",1,
								"fullname", ifnull(x_fullname,concat("Chef")), 
								"avatar_id",ifnull(x_avatar_id,0)
								,"avatar_url",ifnull(x_avatar_url,"")
								,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
							) data;
				else
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"show_choice_popup",1,
								"fullname", ifnull(x_fullname,concat("Chef")), 
								"avatar_id",ifnull(x_avatar_id,0)
								,"avatar_url",ifnull(x_avatar_url,"")
								,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
							) data;
				end if;
				commit;

	LEAVE LB_LOGIN;

	end if;

	call user_first_version_set(x_current_user_id, x_user_start_version);
	call new_old_user_classification(x_current_user_id,x_checked);
			if(x_checked = 0) then
				select 0 status
							, "LOGIN_DEVICE_SUCCESS" msg
							, JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,

										"last_time_sync",utils_format_datetime(x_last_time_sync),

										"fullname", ifnull(x_fullname,concat("Chef")), 
										"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",ifnull(x_avatar_url,"")
															,"ref_code",ifnull(x_ref_code,""),
											"start_version",x_user_start_version,
											"user_type","N",
											"is_banned", x_is_banned
				

										
								) data;
				else
				select 0 status
							, "LOGIN_DEVICE_SUCCESS" msg
							, JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,

										"last_time_sync",utils_format_datetime(x_last_time_sync),

										"fullname", ifnull(x_fullname,concat("Chef")), 
										"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",ifnull(x_avatar_url,"")
															,"ref_code",ifnull(x_ref_code,""),
											"start_version",x_user_start_version,
											"user_type","O",
											"is_banned", x_is_banned
				

										
								) data;
				end if;

call user_set_active_log(x_current_user_id);
			
elseif (x_is_version_161 = 1) then
	if(V_IN_LAST_USER_ID is not null  and  V_IN_LAST_USER_ID <> 0 and  x_current_user_id is not null and V_IN_LAST_USER_ID <> x_current_user_id) then 

	select 1 status,"LOGIN_DEVICE_FAILURE" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",0,
								"reason","Device id and user id not match",
								"need_create_new_device",1
							) data;
				commit;
				LEAVE LB_LOGIN;

	end if;

	if(x_current_user_id is null) then 
				
				call user_create_referal_code(x_ref_code) ;
				insert into user_recently(username,login_type,last_device_id, last_time_sync, time_created, other_info,ref_code)
				values(V_IN_DEVICE_ID, 0, V_IN_DEVICE_ID, now(),now(),V_IN_CLIENT_INFO,x_ref_code);
				
				set x_current_user_id:= LAST_INSERT_ID();
				set x_fullname:= concat("Chef"); 

				update user_recently set fullname = x_fullname where id = x_current_user_id limit 1;
				
				call user_partion_save(V_IN_DEVICE_ID,0,x_current_user_id,0);
				call user_partion_save_ref_code(V_IN_DEVICE_ID,0, x_ref_code);
				
				call user_data_init_data_new_user_all_category(x_current_user_id);
				
				call user_first_version_set(x_current_user_id, x_user_start_version);
				call new_old_user_classification(x_current_user_id,x_checked);
				
				if(x_checked = 0) then 
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
								JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"fullname", x_fullname,
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
												,"ref_code",ifnull(x_ref_code,""),
												
									"need_force_push",1,
									"start_version",x_user_start_version,
									"user_type","N",
									"is_banned", x_is_banned
								) data;
				else
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
								JSON_OBJECT(
								"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"fullname", x_fullname,
									"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",ifnull(x_avatar_url,"")
												,"ref_code",ifnull(x_ref_code,""),
												
									"need_force_push",1,
									"start_version",x_user_start_version,
									"user_type","O",
									"is_banned", x_is_banned
								) data;
				end if;
				commit;
				LEAVE LB_LOGIN;
	end if;

	update user_recently set other_info = utils_func_update_json_data(ifnull(other_info,'{}'), ifnull(V_IN_CLIENT_INFO,'{}'),'[]') where id = x_current_user_id limit 1;


	if(V_IN_LAST_USER_ID is null or V_IN_LAST_USER_ID = 0) then 


	call user_data_get_all_info(x_current_user_id, x_all_data);

	call user_check_basic_data_to_show_sync_device_id_161(x_current_user_id, V_IN_USER_BASIC_INFO, x_check_show_popup);
	
	select if(ifnull(data,'{}')="{}",1,0) into x_data_is_empty from user_data_cr_i_recently where user_id = x_current_user_id limit 0,1;

	call user_first_version_set(x_current_user_id, x_user_start_version);
	call new_old_user_classification(x_current_user_id,x_checked);
		if(x_checked = 0) then
				select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"need_force_push", if(x_data_is_empty = 1, 1,0),
								"need_pull",if(x_check_show_popup = 1,0,1),
								"show_choice_popup",if(x_check_show_popup = 1,1,0),
								"fullname", ifnull(x_fullname,concat("Chef")), 
								"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
												,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
							) data;
		else
				select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"need_force_push", if(x_data_is_empty = 1, 1,0),
								"need_pull",if(x_check_show_popup = 1,0,1),
								"show_choice_popup",if(x_check_show_popup = 1,1,0),
								"fullname", ifnull(x_fullname,concat("Chef")), 
								"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
												,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
							) data;
		end if;
		call user_set_active_log(x_current_user_id);
				commit;
				
				LEAVE LB_LOGIN;
	end if;


	call user_check_basic_data_to_show_sync_device_id_161(x_current_user_id, V_IN_USER_BASIC_INFO, x_check_show_popup);
	if(x_check_show_popup is not null and (x_check_show_popup = 1 or x_check_show_popup = 2)) then 
	call user_data_get_all_info(x_current_user_id, x_all_data);

	call user_first_version_set(x_current_user_id, x_user_start_version);
	call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"show_choice_popup",1,
								"fullname", ifnull(x_fullname,concat("Chef")), 
								"avatar_id",ifnull(x_avatar_id,0)
								,"avatar_url",ifnull(x_avatar_url,"")
								,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
							) data;
				else
					select 0 status,"LOGIN_DEVICE_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"show_choice_popup",1,
								"fullname", ifnull(x_fullname,concat("Chef")), 
								"avatar_id",ifnull(x_avatar_id,0)
								,"avatar_url",ifnull(x_avatar_url,"")
								,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
							) data;
				end if;
				commit;

	LEAVE LB_LOGIN;

	end if;

	call user_first_version_set(x_current_user_id, x_user_start_version);
	call new_old_user_classification(x_current_user_id,x_checked);
			if(x_checked = 0) then
				select 0 status
							, "LOGIN_DEVICE_SUCCESS" msg
							, JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,

										"last_time_sync",utils_format_datetime(x_last_time_sync),

										"fullname", ifnull(x_fullname,concat("Chef")), 
										"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",ifnull(x_avatar_url,"")
															,"ref_code",ifnull(x_ref_code,""),
											"start_version",x_user_start_version,
											"user_type","N",
											"is_banned", x_is_banned
				

										
								) data;
				else
				select 0 status
							, "LOGIN_DEVICE_SUCCESS" msg
							, JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,

										"last_time_sync",utils_format_datetime(x_last_time_sync),

										"fullname", ifnull(x_fullname,concat("Chef")), 
										"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",ifnull(x_avatar_url,"")
															,"ref_code",ifnull(x_ref_code,""),
											"start_version",x_user_start_version,
											"user_type","O",
											"is_banned", x_is_banned
				

										
								) data;
				end if;
end if;
call user_set_active_log(x_current_user_id);

commit;
END