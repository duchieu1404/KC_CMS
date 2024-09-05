CREATE DEFINER=`root`@`localhost` PROCEDURE `cooking_crush_002`.`user_login_by_cloud_username`(in V_IN_LOGIN_TYPE int,
in V_IN_USERNAME varchar(100),
in V_IN_FULLNAME varchar(100),
in V_IN_CURRENT_TOKEN varchar(500),
in V_IN_LAST_USER_ID int,
in V_IN_DEVICE_ID varchar(100),
in V_IN_CLIENT_INFO longtext,
in V_IN_USER_BASIC_INFO text,
in V_IN_AVATAR_URL varchar(2000))
LB_LOGIN:BEGIN
  
  
DECLARE x_current_user_id int;
DECLARE x_user_basic_data text;
DECLARE x_fullname varchar(100);
DECLARE x_other_info longtext;
DECLARE x_all_data longtext;
DECLARE x_last_time_sync datetime;

DECLARE x_user_id_by_device_id int; 
DECLARE x_last_id_is_login_by_device int; 

DECLARE x_last_device_id varchar(100);

DECLARE x_check_show_popup int;
DECLARE x_is_version_154 int;
DECLARE x_is_version_161 int;
DECLARE x_old_user_id int;


DECLARE x_avatar_id int;
DECLARE x_avatar_url varchar(2000);
DECLARE x_ref_code varchar(10);

DECLARE x_user_start_version varchar(20);
DECLARE x_checked int;
DECLARE x_is_banned int default 0;

set x_user_start_version:= JSON_UNQUOTE(JSON_EXTRACT(ifnull(V_IN_CLIENT_INFO,'{}'), "$.app_version"));

call utils_http_to_https(V_IN_AVATAR_URL);

call user_partion_get_id(V_IN_USERNAME, V_IN_LOGIN_TYPE, x_old_user_id);

call user_move_to_recently(x_old_user_id);

select id,fullname,other_info,last_time_sync,other_info,last_device_id,avatar_id,avatar_url,ref_code, is_banned
				into x_current_user_id ,x_fullname , x_other_info,x_last_time_sync,x_other_info,x_last_device_id,x_avatar_id,x_avatar_url,x_ref_code, x_is_banned
				from user_recently
				where username = V_IN_USERNAME and login_type = V_IN_LOGIN_TYPE 
				limit 0,1;

call user_move_to_recently_by_us_type(V_IN_DEVICE_ID, 0);


select id into x_user_id_by_device_id from user_recently where username = V_IN_DEVICE_ID and login_type = 0 limit 0,1;
	if(V_IN_LAST_USER_ID >0) then 
			call user_move_to_recently(V_IN_LAST_USER_ID) ;
			select id into x_last_id_is_login_by_device from user_recently where id = V_IN_LAST_USER_ID and login_type = 0 limit 0,1;
	end if;

if(x_is_banned is null) then
	set x_is_banned:= 0;
end if;

call utils_compare_string_version("1.5.3", x_user_start_version, x_is_version_154);
call utils_compare_string_version("1.6.0", x_user_start_version, x_is_version_161);
if (x_is_version_154 = 1 and x_is_version_161 = 0 ) then 


	

	if(  			V_IN_LAST_USER_ID is not null  and  V_IN_LAST_USER_ID <> 0 
				and  x_current_user_id is not null  and V_IN_LAST_USER_ID <> x_current_user_id
				and  x_last_id_is_login_by_device is not null and x_last_id_is_login_by_device <> V_IN_LAST_USER_ID
	) then 
	select 1 status,"LOGIN_CLOUD_FAILURE" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",0,
								"reason","Cloud id don't match with user_id ",
								"relogin_cloud_as_new",1
							) data;
				commit;
				LEAVE LB_LOGIN;
	end if;

	if(x_current_user_id is null) then 
				
				
				if(x_user_id_by_device_id is null) then 
				
										call user_create_referal_code(x_ref_code) ;

				
							insert into user_recently(username,login_type,last_device_id, last_time_sync, time_created,fullname,other_info,avatar_url,avatar_id,ref_code)
							values(V_IN_USERNAME, V_IN_LOGIN_TYPE, V_IN_DEVICE_ID, now(),now(),V_IN_FULLNAME, ifnull(V_IN_CLIENT_INFO,'{}'),V_IN_AVATAR_URL, -V_IN_LOGIN_TYPE,x_ref_code);
							
							set x_current_user_id:= LAST_INSERT_ID();
	
							call user_data_init_data_new_user_all_category(x_current_user_id);
							call user_partion_save(V_IN_USERNAME,V_IN_LOGIN_TYPE,x_current_user_id,0);
							call user_partion_save_ref_code(V_IN_USERNAME,V_IN_LOGIN_TYPE, x_ref_code);
							
										call user_first_version_set(x_current_user_id, x_user_start_version);
							call new_old_user_classification(x_current_user_id,x_checked);
							INSERT INTO user_data_log(user_id,type,username,last_time_active) values (x_current_user_id,"New Player",V_IN_FULLNAME,now());
							if (x_checked  = 0) then
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											"need_force_push",1,
											"is_first_login_cloud",1,
											"start_version",x_user_start_version,
											"user_type","N",
											"is_banned", x_is_banned

										) data;
							else 
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											"need_force_push",1,
											"is_first_login_cloud",1,
											"start_version",x_user_start_version,
											"user_type","O",
											"is_banned", x_is_banned
										) data;
							end if;
							commit;
							LEAVE LB_LOGIN;
				
				
				else 
				
						
					if(V_IN_LAST_USER_ID = 0 or  V_IN_LAST_USER_ID = x_user_id_by_device_id) then 
					
										update user_recently 
										set username = V_IN_USERNAME
										, fullname = V_IN_FULLNAME
										, avatar_url = V_IN_AVATAR_URL
										, login_type = V_IN_LOGIN_TYPE
										, avatar_id = - V_IN_LOGIN_TYPE
										, other_info = utils_func_update_json_data(ifnull(other_info,'{}'), ifnull(V_IN_CLIENT_INFO,'{}'),'[]')

										where id = x_user_id_by_device_id 
										limit 1;
										
										call user_partion_delete(V_IN_DEVICE_ID,0);
										call user_partion_save(V_IN_USERNAME,V_IN_LOGIN_TYPE,x_user_id_by_device_id,0);
										call user_partion_save_ref_code(V_IN_USERNAME,V_IN_LOGIN_TYPE, x_ref_code);

										select id,fullname,other_info,last_time_sync,other_info,avatar_id,avatar_url,ref_code
										into x_current_user_id ,x_fullname , x_other_info,x_last_time_sync,x_other_info,x_avatar_id,x_avatar_url,x_ref_code
										from user_recently
										where id  = x_user_id_by_device_id
										limit 0,1;
										
										call user_first_version_set(x_current_user_id, x_user_start_version);
										update user_recently 
										set `other_info` = ifnull(V_IN_CLIENT_INFO,'{}')
										where id = x_current_user_id
										limit 1;
										call new_old_user_classification(x_current_user_id,x_checked);
										if(x_checked = 0) then 
										select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											"need_force_push",1,
											"is_first_login_cloud",1,
											"start_version",x_user_start_version,
											"user_type","N",
											"is_banned", x_is_banned
										) data;
										else 
										select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											"need_force_push",1,
											"is_first_login_cloud",1,
											"start_version",x_user_start_version,
											"user_type","O",
											"is_banned", x_is_banned
										) data;
										end if; 
		
									commit;
										

									LEAVE LB_LOGIN;
									
				else
				
				
							select 1 status,"LOGIN_CLOUD_FAILURE" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",0,
											"reason","Cloud id don't match with user_id ",
											"relogin_cloud_as_new",1
										) data;
							LEAVE LB_LOGIN;
				
				end if;
		
	end if;  
	LEAVE LB_LOGIN;
	end if;  


	
	update user_recently  
	set
	`old_user_id`  = if(old_user_id is null, x_last_id_is_login_by_device,old_user_id),`last_time_active` = now()
	where id = x_current_user_id limit 1;
	call user_set_active_log(x_current_user_id);

	commit;

	call user_check_basic_data_to_show_sync(x_current_user_id,V_IN_USER_BASIC_INFO,x_check_show_popup);

	if(V_IN_LAST_USER_ID is null or V_IN_LAST_USER_ID = 0) then 
	
	
	call user_data_get_all_info(x_current_user_id, x_all_data);
	select ref_code into x_ref_code from user_recently where id = x_current_user_id limit 0,1;
				
				call user_first_version_set(x_current_user_id, x_user_start_version);
				call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then 
				
					if(x_check_show_popup = 0) then 
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
													"avatar_id",ifnull(x_avatar_id,0)
																	,"avatar_url",V_IN_AVATAR_URL
																	,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
														"basic_data","{}",
														"all_data",ifnull(x_all_data,'{}'),
														"start_version",x_user_start_version,
														"user_type","N",
														"is_banned", x_is_banned
													) data;
					elseif(x_check_show_popup = 1) then
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"need_pull",1,
														"fullname", x_fullname,
													"avatar_id",ifnull(x_avatar_id,0)
																	,"avatar_url",V_IN_AVATAR_URL
																	,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
														"basic_data","{}",
														"all_data",ifnull(x_all_data,'{}'),
														"start_version",x_user_start_version,
														"user_type","N",
														"is_banned", x_is_banned
													) data;
					elseif (x_check_show_popup = 2) then
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"last_time_sync",utils_format_datetime(x_last_time_sync),
								"need_force_push",1,
								"fullname", x_fullname,
							"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",V_IN_AVATAR_URL
											,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
							) data;
					end if;
				else 
					if(x_check_show_popup = 0) then 
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
													"avatar_id",ifnull(x_avatar_id,0)
																	,"avatar_url",V_IN_AVATAR_URL
																	,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
														"basic_data","{}",
														"all_data",ifnull(x_all_data,'{}'),
														"start_version",x_user_start_version,
														"user_type","O",
														"is_banned", x_is_banned
													) data;
					
					elseif(x_check_show_popup = 1) then
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"need_pull",1,
														"fullname", x_fullname,
													"avatar_id",ifnull(x_avatar_id,0)
																	,"avatar_url",V_IN_AVATAR_URL
																	,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
														"basic_data","{}",
														"all_data",ifnull(x_all_data,'{}'),
														"start_version",x_user_start_version,
														"user_type","O",
														"is_banned", x_is_banned
													) data;
					elseif (x_check_show_popup = 2) then
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"last_time_sync",utils_format_datetime(x_last_time_sync),
								"need_force_push",1,
								"fullname", x_fullname,
							"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",V_IN_AVATAR_URL
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
				update user_recently set other_info = ifnull(V_IN_CLIENT_INFO,'{}'),`last_time_active` = now() where id = x_current_user_id 
										limit 1;
				call user_set_active_log(x_current_user_id);
				LEAVE LB_LOGIN;
	end if;  

		if(x_last_device_id <> V_IN_DEVICE_ID) then 
				call user_data_get_all_info(x_current_user_id, x_all_data);
				
				select ref_code into x_ref_code from user_recently where id = x_current_user_id limit 0,1;
				
				call user_first_version_set(x_current_user_id, x_user_start_version);
				call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then

						if(x_check_show_popup = 0 ) then 
								select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
														JSON_OBJECT(
														"server_time",utils_format_datetime(now()),
															"user_id",x_current_user_id,
															"last_time_sync",utils_format_datetime(x_last_time_sync),
															"fullname", x_fullname,
															"check_show_popup",1,
															"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",V_IN_AVATAR_URL
															,"ref_code",ifnull(x_ref_code,""),
															"other_info", ifnull(x_other_info,"{}"),
															"all_data",ifnull(x_all_data,'{}'),
												"start_version",x_user_start_version,
												"user_type","N",
												"is_banned", x_is_banned
														) data;
							elseif(x_check_show_popup = 1 ) then 
								select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
														JSON_OBJECT(
														"server_time",utils_format_datetime(now()),
															"user_id",x_current_user_id,
															"last_time_sync",utils_format_datetime(x_last_time_sync),
															"fullname", x_fullname,
															"need_pull",1,
															"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",V_IN_AVATAR_URL
															,"ref_code",ifnull(x_ref_code,""),
															"other_info", ifnull(x_other_info,"{}"),
															"all_data",ifnull(x_all_data,'{}'),
												"start_version",x_user_start_version,
												"user_type","N",
												"is_banned", x_is_banned
														) data;
								
								elseif(x_check_show_popup = 2) then 
									select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
														JSON_OBJECT(
														"server_time",utils_format_datetime(now()),
															"user_id",x_current_user_id,
															"last_time_sync",utils_format_datetime(x_last_time_sync),
															"fullname", x_fullname,
															"show_choice_popup",0,
															"need_force_push",1,
															"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",V_IN_AVATAR_URL
															,"ref_code",ifnull(x_ref_code,""),
															"other_info", ifnull(x_other_info,"{}"),
												"start_version",x_user_start_version,
												"user_type","N",
												"sync_other_device",1,
												"is_banned", x_is_banned
														) data;
									end if;

						else
							if(x_check_show_popup = 0 ) then 
								select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
														JSON_OBJECT(
														"server_time",utils_format_datetime(now()),
															"user_id",x_current_user_id,
															"last_time_sync",utils_format_datetime(x_last_time_sync),
															"fullname", x_fullname,
															"need_pull",1,
															"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",V_IN_AVATAR_URL
															,"ref_code",ifnull(x_ref_code,""),
															"other_info", ifnull(x_other_info,"{}"),
															"all_data",ifnull(x_all_data,'{}'),
												"start_version",x_user_start_version,
												"user_type","O",
												"is_banned", x_is_banned
														) data;
								elseif(x_check_show_popup = 1 ) then 
										select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
											JSON_OBJECT(
											"server_time",utils_format_datetime(now()),
												"user_id",x_current_user_id,
												"last_time_sync",utils_format_datetime(x_last_time_sync),
												"fullname", x_fullname,
												"need_pull",1,
												"avatar_id",ifnull(x_avatar_id,0)
												,"avatar_url",V_IN_AVATAR_URL
												,"ref_code",ifnull(x_ref_code,""),
												"other_info", ifnull(x_other_info,"{}"),
												"all_data",ifnull(x_all_data,'{}'),
									"start_version",x_user_start_version,
									"user_type","O",
									"is_banned", x_is_banned
											) data;
							elseif(x_check_show_popup = 2) then 
									select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
														JSON_OBJECT(
														"server_time",utils_format_datetime(now()),
															"user_id",x_current_user_id,
															"last_time_sync",utils_format_datetime(x_last_time_sync),
															"fullname", x_fullname,
															"show_choice_popup",0,
															"need_force_push",1,
															"avatar_id",ifnull(x_avatar_id,0)
															,"avatar_url",V_IN_AVATAR_URL
															,"ref_code",ifnull(x_ref_code,""),
															"other_info", ifnull(x_other_info,"{}"),
												"start_version",x_user_start_version,
												"user_type","O",
												"sync_other_device",1,
												"is_banned", x_is_banned
														) data;
								end if;
					end if;
						update user_recently set other_info = ifnull(V_IN_CLIENT_INFO,'{}'),`last_time_active` = now() where id = x_current_user_id 
						
				limit 1;
				call user_set_active_log(x_current_user_id);
							commit;

							LEAVE LB_LOGIN;

	end if; 
	
	if(x_last_id_is_login_by_device  = x_user_id_by_device_id ) then 
				call user_data_get_all_info(x_current_user_id, x_all_data);
				select ref_code into x_ref_code from user_recently where id = x_current_user_id limit 0,1;
				call user_first_version_set(x_current_user_id, x_user_start_version);
				call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then
						if(x_check_show_popup = 0 ) then 
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
														"need_force_push",1,
														"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",V_IN_AVATAR_URL
														,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
														"all_data",ifnull(x_all_data,'{}'),
											"start_version",x_user_start_version,
											"user_type","N",
											"is_banned", x_is_banned
													) data;
						elseif(x_check_show_popup = 1 ) then 
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
														"need_pull",1,
														"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",V_IN_AVATAR_URL
														,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
														"all_data",ifnull(x_all_data,'{}'),
											"start_version",x_user_start_version,
											"user_type","N",
											"is_banned", x_is_banned
													) data;
							
							elseif(x_check_show_popup = 2) then 
								select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
														"need_force_push",1,
														"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",V_IN_AVATAR_URL
														,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
											"start_version",x_user_start_version,
											"user_type","N",
											"sync_other_device",1,
											"is_banned", x_is_banned
													) data;
							
							end if;
						else
						if(x_check_show_popup = 0 ) then 
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
														"need_force_push",1,
														"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",V_IN_AVATAR_URL
														,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
														"all_data",ifnull(x_all_data,'{}'),
											"start_version",x_user_start_version,
											"user_type","O",
											"is_banned", x_is_banned
													) data;
							elseif(x_check_show_popup = 1 ) then 
									select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"last_time_sync",utils_format_datetime(x_last_time_sync),
											"fullname", x_fullname,
											"need_pull",1,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",V_IN_AVATAR_URL
											,"ref_code",ifnull(x_ref_code,""),
											"other_info", ifnull(x_other_info,"{}"),
											"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
										) data;
						elseif(x_check_show_popup = 2) then 
								select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
														"need_force_push",1,
														"avatar_id",ifnull(x_avatar_id,0)
														,"avatar_url",V_IN_AVATAR_URL
														,"ref_code",ifnull(x_ref_code,""),
														"other_info", ifnull(x_other_info,"{}"),
											"start_version",x_user_start_version,
											"user_type","O",
											"sync_other_device",1,
											"is_banned", x_is_banned
													) data;
							
							end if;	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
					end if;
								update user_recently set other_info = ifnull(V_IN_CLIENT_INFO,'{}'),`last_time_active` = now() where id = x_current_user_id 
				limit 1;
				call user_set_active_log(x_current_user_id);
							commit;
							
						
							LEAVE LB_LOGIN;


	end if;  


				call user_data_get_all_info(x_current_user_id, x_all_data);
				call user_set_active_log(x_current_user_id);
				call user_first_version_set(x_current_user_id, x_user_start_version);

				call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then
					if(x_check_show_popup = 0) then 
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
														"show_popup_choice",x_check_show_popup,
													"avatar_id",ifnull(x_avatar_id,0)
																	,"avatar_url",V_IN_AVATAR_URL
																	,"ref_code",ifnull(x_ref_code,""),
	
														"start_version",x_user_start_version,
														"user_type","N",
														"is_banned", x_is_banned
													) data;
					elseif(x_check_show_popup = 1) then
						select 0 status
									, "LOGIN_CLOUD_SUCCESS" msg
									, JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
												"user_id",x_current_user_id,
												"last_time_sync",utils_format_datetime(x_last_time_sync),
						
												"need_pull",1,
												"fullname", x_fullname,
												"avatar_id",ifnull(x_avatar_id,0)
																,"avatar_url",ifnull(x_avatar_url,"")
																,"ref_code",ifnull(x_ref_code,""),
													"all_data",ifnull(x_all_data,'{}'),
													"start_version",x_user_start_version,
													"user_type","N",
													"is_banned", x_is_banned

						
						
						
										) data;
						elseif(x_check_show_popup = 2) then
							select 0 status
									, "LOGIN_CLOUD_SUCCESS" msg
									, JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
												"user_id",x_current_user_id,
												"last_time_sync",utils_format_datetime(x_last_time_sync),
						
												"need_force_push",1,
												"fullname", x_fullname,
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
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
													JSON_OBJECT(
													"server_time",utils_format_datetime(now()),
														"user_id",x_current_user_id,
														"last_time_sync",utils_format_datetime(x_last_time_sync),
														"fullname", x_fullname,
														"show_popup_choice",x_check_show_popup,
													"avatar_id",ifnull(x_avatar_id,0)
																	,"avatar_url",V_IN_AVATAR_URL
																	,"ref_code",ifnull(x_ref_code,""),
	
														"start_version",x_user_start_version,
														"user_type","O",
														"is_banned", x_is_banned
													) data;
					elseif(x_check_show_popup = 1) then
							select 0 status
						, "LOGIN_CLOUD_SUCCESS" msg
						, JSON_OBJECT(
						"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"last_time_sync",utils_format_datetime(x_last_time_sync),
			
									"need_pull",1,
									"fullname", x_fullname,
									"avatar_id",ifnull(x_avatar_id,0)
													,"avatar_url",ifnull(x_avatar_url,"")
													,"ref_code",ifnull(x_ref_code,""),
										"all_data",ifnull(x_all_data,'{}'),
										"start_version",x_user_start_version,
										"user_type","O",
										"is_banned", x_is_banned
			
			
			
							) data;
						elseif (x_check_show_popup = 2) then 
							select 0 status
						, "LOGIN_CLOUD_SUCCESS" msg
						, JSON_OBJECT(
						"server_time",utils_format_datetime(now()),
									"user_id",x_current_user_id,
									"last_time_sync",utils_format_datetime(x_last_time_sync),
			
									"need_force_push",1,
									"fullname", x_fullname,
									"avatar_id",ifnull(x_avatar_id,0)
													,"avatar_url",ifnull(x_avatar_url,"")
													,"ref_code",ifnull(x_ref_code,""),
	
										"start_version",x_user_start_version,
										"user_type","O",
										"is_banned", x_is_banned
			
			
			
							) data;
						end if;
					end if;
elseif (x_is_version_154 = 0) then




if(  			V_IN_LAST_USER_ID is not null  and  V_IN_LAST_USER_ID <> 0 
			and  x_current_user_id is not null  and V_IN_LAST_USER_ID <> x_current_user_id
			and  x_last_id_is_login_by_device is not null and x_last_id_is_login_by_device <> V_IN_LAST_USER_ID
) then 
select 1 status,"LOGIN_CLOUD_FAILURE" msg,
						JSON_OBJECT(
						"server_time",utils_format_datetime(now()),
							"user_id",0,
							"reason","Cloud id don't match with user_id ",
							"relogin_cloud_as_new",1
						) data;
			commit;
			LEAVE LB_LOGIN;
end if;

if(x_current_user_id is null) then 
			
			
			if(x_user_id_by_device_id is null) then 
			
									call user_create_referal_code(x_ref_code) ;

			
						insert into user_recently(username,login_type,last_device_id, last_time_sync, time_created,fullname,other_info,avatar_url,avatar_id,ref_code)
						values(V_IN_USERNAME, V_IN_LOGIN_TYPE, V_IN_DEVICE_ID, now(),now(),V_IN_FULLNAME, ifnull(V_IN_CLIENT_INFO,'{}'),V_IN_AVATAR_URL, -V_IN_LOGIN_TYPE,x_ref_code);
						
						set x_current_user_id:= LAST_INSERT_ID();

						call user_data_init_data_new_user_all_category(x_current_user_id);
						call user_partion_save(V_IN_USERNAME,V_IN_LOGIN_TYPE,x_current_user_id,0);
						call user_partion_save_ref_code(V_IN_USERNAME,V_IN_LOGIN_TYPE, x_ref_code);
						
									call user_first_version_set(x_current_user_id, x_user_start_version);
						call new_old_user_classification(x_current_user_id,x_checked);
						if (x_checked  = 0) then
						select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
									JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,
										"fullname", x_fullname,
										"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",ifnull(x_avatar_url,"")
										,"ref_code",ifnull(x_ref_code,""),
										"need_force_push",1,
										"is_first_login_cloud",1,
							"start_version",x_user_start_version,
							"user_type","N",
							"is_banned", x_is_banned
									) data;
						else 
						select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
									JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,
										"fullname", x_fullname,
										"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",ifnull(x_avatar_url,"")
										,"ref_code",ifnull(x_ref_code,""),
										"need_force_push",1,
										"is_first_login_cloud",1,
							"start_version",x_user_start_version,
							"user_type","O",
							"is_banned", x_is_banned
									) data;
					  end if;
						commit;
						LEAVE LB_LOGIN;
			
			
			else 
			
					
				if(V_IN_LAST_USER_ID = 0 or  V_IN_LAST_USER_ID = x_user_id_by_device_id) then 
				
									update user_recently 
									set username = V_IN_USERNAME
									, fullname = V_IN_FULLNAME
									, avatar_url = V_IN_AVATAR_URL
									, login_type = V_IN_LOGIN_TYPE
									, avatar_id = - V_IN_LOGIN_TYPE
									, other_info = utils_func_update_json_data(ifnull(other_info,'{}'), ifnull(V_IN_CLIENT_INFO,'{}'),'[]')

									where id = x_user_id_by_device_id 
									limit 1;
									
									call user_partion_delete(V_IN_DEVICE_ID,0);
									call user_partion_save(V_IN_USERNAME,V_IN_LOGIN_TYPE,x_user_id_by_device_id,0);
									call user_partion_save_ref_code(V_IN_USERNAME,V_IN_LOGIN_TYPE, x_ref_code);

									select id,fullname,other_info,last_time_sync,other_info,avatar_id,avatar_url,ref_code
									into x_current_user_id ,x_fullname , x_other_info,x_last_time_sync,x_other_info,x_avatar_id,x_avatar_url,x_ref_code
									from user_recently
									where id  = x_user_id_by_device_id
									limit 0,1;
									
									call user_first_version_set(x_current_user_id, x_user_start_version);
									update user_recently 
									set `other_info` =  ifnull(V_IN_CLIENT_INFO,'{}')
									where id = x_current_user_id
									limit 1;
									call new_old_user_classification(x_current_user_id,x_checked);
									if(x_checked = 0) then 
									select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
									JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,
										"fullname", x_fullname,
										"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",ifnull(x_avatar_url,"")
										,"ref_code",ifnull(x_ref_code,""),
										"need_force_push",1,
										"is_first_login_cloud",1,
							"start_version",x_user_start_version,
							"user_type","N",
							"is_banned", x_is_banned
									) data;
									else 
									select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
									JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,
										"fullname", x_fullname,
										"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",ifnull(x_avatar_url,"")
										,"ref_code",ifnull(x_ref_code,""),
										"need_force_push",1,
										"is_first_login_cloud",1,
							"start_version",x_user_start_version,
							"user_type","O",
							"is_banned", x_is_banned
									) data;
									end if; 
	
								commit;
									

								LEAVE LB_LOGIN;
								
			else
			
			
						select 1 status,"LOGIN_CLOUD_FAILURE" msg,
									JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
										"user_id",0,
										"reason","Cloud id don't match with user_id ",
										"relogin_cloud_as_new",1
									) data;
						LEAVE LB_LOGIN;
			
			end if;
	
end if;  
LEAVE LB_LOGIN;
end if;  



update user_recently  
set
`old_user_id`  = if(old_user_id is null, x_last_id_is_login_by_device,old_user_id),`last_time_active` = now()
where id = x_current_user_id limit 1;
call user_set_active_log(x_current_user_id);
commit;

call user_check_basic_data_to_show_sync(x_current_user_id,V_IN_USER_BASIC_INFO,x_check_show_popup);

if(V_IN_LAST_USER_ID is null or V_IN_LAST_USER_ID = 0) then 


call user_data_get_all_info(x_current_user_id, x_all_data);
select ref_code into x_ref_code from user_recently where id = x_current_user_id limit 0,1;
			
			call user_first_version_set(x_current_user_id, x_user_start_version);
			call new_old_user_classification(x_current_user_id,x_checked);
			if(x_checked = 0) then 

select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
						JSON_OBJECT(
						"server_time",utils_format_datetime(now()),
							"user_id",x_current_user_id,
							"last_time_sync",utils_format_datetime(x_last_time_sync),
								"show_choice_popup",if(x_check_show_popup=1,1,0),
							"need_pull",if(x_check_show_popup=1,0,1),
							"fullname", x_fullname,
						"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",V_IN_AVATAR_URL
										,"ref_code",ifnull(x_ref_code,""),
							"other_info", ifnull(x_other_info,"{}"),
							"basic_data","{}",
							"all_data",ifnull(x_all_data,'{}'),
							"start_version",x_user_start_version,
							"user_type","N",
							"is_banned", x_is_banned
						) data;
						else 
select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
						JSON_OBJECT(
						"server_time",utils_format_datetime(now()),
							"user_id",x_current_user_id,
							"last_time_sync",utils_format_datetime(x_last_time_sync),
								"show_choice_popup",if(x_check_show_popup=1,1,0),
							"need_pull",if(x_check_show_popup=1,0,1),
							"fullname", x_fullname,
						"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",V_IN_AVATAR_URL
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
			update user_recently set other_info = ifnull(V_IN_CLIENT_INFO,'{}'),`last_time_active` = now() where id = x_current_user_id 
									limit 1;
			call user_set_active_log(x_current_user_id);

			LEAVE LB_LOGIN;
end if;  



if(x_last_device_id <> V_IN_DEVICE_ID or (x_last_id_is_login_by_device  = x_user_id_by_device_id) or x_check_show_popup = 1) then 
			call user_data_get_all_info(x_current_user_id, x_all_data);
			
			select ref_code into x_ref_code from user_recently where id = x_current_user_id limit 0,1;
			call user_first_version_set(x_current_user_id, x_user_start_version);
			call new_old_user_classification(x_current_user_id,x_checked);
			if(x_checked = 0) then

			select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
									JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,
										"show_choice_popup",1,
										"last_time_sync",utils_format_datetime(x_last_time_sync),

										"fullname", x_fullname,
										"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",V_IN_AVATAR_URL
										,"ref_code",ifnull(x_ref_code,""),
										"other_info", ifnull(x_other_info,"{}"),
										"basic_data","{}",
										"all_data",ifnull(x_all_data,'{}'),
							"start_version",x_user_start_version,
							"user_type","N",
							"is_banned", x_is_banned
									) data;
					else
								select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
									JSON_OBJECT(
									"server_time",utils_format_datetime(now()),
										"user_id",x_current_user_id,
										"show_choice_popup",1,
										"last_time_sync",utils_format_datetime(x_last_time_sync),

										"fullname", x_fullname,
										"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",V_IN_AVATAR_URL
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
						update user_recently set other_info = ifnull(V_IN_CLIENT_INFO,'{}'),`last_time_active` = now() where id = x_current_user_id 
									limit 1;
									call user_set_active_log(x_current_user_id);
									
						LEAVE LB_LOGIN;

end if; 

			
			call user_first_version_set(x_current_user_id, x_user_start_version);
				
			call new_old_user_classification(x_current_user_id,x_checked);
			if(x_checked = 0) then 
select 0 status
			, "LOGIN_CLOUD_SUCCESS" msg
			, JSON_OBJECT(
			"server_time",utils_format_datetime(now()),
						"user_id",x_current_user_id,
						"last_time_sync",utils_format_datetime(x_last_time_sync),

						"fullname", x_fullname,
						"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",ifnull(x_avatar_url,"")
										,"ref_code",ifnull(x_ref_code,""),
							"start_version",x_user_start_version,
							"user_type","N",
							"is_banned", x_is_banned



				) data;
				else 
				select 0 status
			, "LOGIN_CLOUD_SUCCESS" msg
			, JSON_OBJECT(
			"server_time",utils_format_datetime(now()),
						"user_id",x_current_user_id,
						"last_time_sync",utils_format_datetime(x_last_time_sync),

						"fullname", x_fullname,
						"avatar_id",ifnull(x_avatar_id,0)
										,"avatar_url",ifnull(x_avatar_url,"")
										,"ref_code",ifnull(x_ref_code,""),
							"start_version",x_user_start_version,
							"user_type","O",
							"is_banned", x_is_banned



				) data;
				
				end if;
				
elseif (x_is_version_161 = 1 ) then 
		
	if(  			V_IN_LAST_USER_ID is not null  and  V_IN_LAST_USER_ID <> 0 
				and  x_current_user_id is not null  and V_IN_LAST_USER_ID <> x_current_user_id
				and  x_last_id_is_login_by_device is not null and x_last_id_is_login_by_device <> V_IN_LAST_USER_ID
	) then 
	select 1 status,"LOGIN_CLOUD_FAILURE" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",0,
								"reason","Cloud id don't match with user_id ",
								"relogin_cloud_as_new",1
							) data;
				commit;
				LEAVE LB_LOGIN;
	end if;

	if(x_current_user_id is null) then 
				
				
				if(x_user_id_by_device_id is null) then 
				
										call user_create_referal_code(x_ref_code) ;

				
							insert into user_recently(username,login_type,last_device_id, last_time_sync, time_created,fullname,other_info,avatar_url,avatar_id,ref_code)
							values(V_IN_USERNAME, V_IN_LOGIN_TYPE, V_IN_DEVICE_ID, now(),now(),V_IN_FULLNAME, ifnull(V_IN_CLIENT_INFO,'{}'),V_IN_AVATAR_URL, -V_IN_LOGIN_TYPE,x_ref_code);
							
							set x_current_user_id:= LAST_INSERT_ID();
	
							call user_data_init_data_new_user_all_category(x_current_user_id);
							call user_partion_save(V_IN_USERNAME,V_IN_LOGIN_TYPE,x_current_user_id,0);
							call user_partion_save_ref_code(V_IN_USERNAME,V_IN_LOGIN_TYPE, x_ref_code);
							
										call user_first_version_set(x_current_user_id, x_user_start_version);
							call new_old_user_classification(x_current_user_id,x_checked);
							if (x_checked  = 0) then
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											"need_force_push",1,
											"is_first_login_cloud",1,
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
										) data;
							else 
							select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											"need_force_push",1,
											"is_first_login_cloud",1,
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
										) data;
							end if;
							commit;
							LEAVE LB_LOGIN;
				
				
				else 
				
						
					if(V_IN_LAST_USER_ID = 0 or  V_IN_LAST_USER_ID = x_user_id_by_device_id) then 
					
										update user_recently 
										set username = V_IN_USERNAME
										, fullname = V_IN_FULLNAME
										, avatar_url = V_IN_AVATAR_URL
										, login_type = V_IN_LOGIN_TYPE
										, avatar_id = - V_IN_LOGIN_TYPE
										, other_info = utils_func_update_json_data(ifnull(other_info,'{}'), ifnull(V_IN_CLIENT_INFO,'{}'),'[]')

										where id = x_user_id_by_device_id 
										limit 1;
										
										call user_partion_delete(V_IN_DEVICE_ID,0);
										call user_partion_save(V_IN_USERNAME,V_IN_LOGIN_TYPE,x_user_id_by_device_id,0);
										call user_partion_save_ref_code(V_IN_USERNAME,V_IN_LOGIN_TYPE, x_ref_code);

										select id,fullname,other_info,last_time_sync,other_info,avatar_id,avatar_url,ref_code
										into x_current_user_id ,x_fullname , x_other_info,x_last_time_sync,x_other_info,x_avatar_id,x_avatar_url,x_ref_code
										from user_recently
										where id  = x_user_id_by_device_id
										limit 0,1;
										
										call user_first_version_set(x_current_user_id, x_user_start_version);
										update user_recently 
										set `other_info` =  ifnull(V_IN_CLIENT_INFO,'{}')
										where id = x_current_user_id
										limit 1;
										call new_old_user_classification(x_current_user_id,x_checked);
										if(x_checked = 0) then 
										select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											"need_force_push",1,
											"is_first_login_cloud",1,
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
										) data;
										else 
										select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
											"need_force_push",1,
											"is_first_login_cloud",1,
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
										) data;
										end if; 
		
									commit;
										

									LEAVE LB_LOGIN;
									
				else
				
				
							select 1 status,"LOGIN_CLOUD_FAILURE" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",0,
											"reason","Cloud id don't match with user_id ",
											"relogin_cloud_as_new",1
										) data;
							LEAVE LB_LOGIN;
				
				end if;
		
	end if;  
	LEAVE LB_LOGIN;
	end if;  


	
	update user_recently  
	set
	`old_user_id`  = if(old_user_id is null, x_last_id_is_login_by_device,old_user_id),`last_time_active` = now()
	where id = x_current_user_id limit 1;
	call user_set_active_log(x_current_user_id);
	commit;

	call user_check_basic_data_to_show_sync_161(x_current_user_id,V_IN_USER_BASIC_INFO,x_check_show_popup);

	if(V_IN_LAST_USER_ID is null or V_IN_LAST_USER_ID = 0) then 
	
	
	call user_data_get_all_info(x_current_user_id, x_all_data);
	select ref_code into x_ref_code from user_recently where id = x_current_user_id limit 0,1;
				
				call user_first_version_set(x_current_user_id, x_user_start_version);
				call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then 

	select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"last_time_sync",utils_format_datetime(x_last_time_sync),
									"show_choice_popup",if(x_check_show_popup=1,1,0),
								"need_pull",if(x_check_show_popup=1,0,1),
								"fullname", x_fullname,
							"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",V_IN_AVATAR_URL
											,"ref_code",ifnull(x_ref_code,""),
								"other_info", ifnull(x_other_info,"{}"),
								"basic_data","{}",
								"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
							) data;
							else 
	select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
							JSON_OBJECT(
							"server_time",utils_format_datetime(now()),
								"user_id",x_current_user_id,
								"last_time_sync",utils_format_datetime(x_last_time_sync),
									"show_choice_popup",if(x_check_show_popup=1,1,0),
								"need_pull",if(x_check_show_popup=1,0,1),
								"fullname", x_fullname,
							"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",V_IN_AVATAR_URL
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
				update user_recently set other_info = ifnull(V_IN_CLIENT_INFO,'{}'),`last_time_active` = now() where id = x_current_user_id 
										limit 1;
				call user_set_active_log(x_current_user_id);

				LEAVE LB_LOGIN;
	end if;  



	if(x_last_device_id <> V_IN_DEVICE_ID or (x_last_id_is_login_by_device  = x_user_id_by_device_id) or x_check_show_popup = 1) then 
				call user_data_get_all_info(x_current_user_id, x_all_data);
				
				select ref_code into x_ref_code from user_recently where id = x_current_user_id limit 0,1;
				call user_first_version_set(x_current_user_id, x_user_start_version);
				call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then

				select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"show_choice_popup",1,
											"last_time_sync",utils_format_datetime(x_last_time_sync),

											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",V_IN_AVATAR_URL
											,"ref_code",ifnull(x_ref_code,""),
											"other_info", ifnull(x_other_info,"{}"),
											"basic_data","{}",
											"all_data",ifnull(x_all_data,'{}'),
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
										) data;
						else
									select 0 status,"LOGIN_CLOUD_SUCCESS" msg,
										JSON_OBJECT(
										"server_time",utils_format_datetime(now()),
											"user_id",x_current_user_id,
											"show_choice_popup",1,
											"last_time_sync",utils_format_datetime(x_last_time_sync),

											"fullname", x_fullname,
											"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",V_IN_AVATAR_URL
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
							update user_recently set other_info = ifnull(V_IN_CLIENT_INFO,'{}'),`last_time_active` = now() where id = x_current_user_id 
										limit 1;
										call user_set_active_log(x_current_user_id);
										
							LEAVE LB_LOGIN;

	end if; 

				
				call user_first_version_set(x_current_user_id, x_user_start_version);
					
				call new_old_user_classification(x_current_user_id,x_checked);
				if(x_checked = 0) then 
	select 0 status
				, "LOGIN_CLOUD_SUCCESS" msg
				, JSON_OBJECT(
				"server_time",utils_format_datetime(now()),
							"user_id",x_current_user_id,
							"last_time_sync",utils_format_datetime(x_last_time_sync),
	
							"fullname", x_fullname,
							"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
								"start_version",x_user_start_version,
								"user_type","N",
								"is_banned", x_is_banned
	
	
	
					) data;
					else 
					select 0 status
				, "LOGIN_CLOUD_SUCCESS" msg
				, JSON_OBJECT(
				"server_time",utils_format_datetime(now()),
							"user_id",x_current_user_id,
							"last_time_sync",utils_format_datetime(x_last_time_sync),
	
							"fullname", x_fullname,
							"avatar_id",ifnull(x_avatar_id,0)
											,"avatar_url",ifnull(x_avatar_url,"")
											,"ref_code",ifnull(x_ref_code,""),
								"start_version",x_user_start_version,
								"user_type","O",
								"is_banned", x_is_banned
	
	
	
					) data;
					
					end if;

end if;

				update user_recently set other_info = ifnull(V_IN_CLIENT_INFO,'{}'),`last_time_active` = now() where id = x_current_user_id 
											limit 1;				
											call user_set_active_log(x_current_user_id);

		


END