CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_login`(in V_IN_USERNAME varchar(100), in V_IN_PASSWORD varchar(100), in V_IN_CLIENT_DATA text)
LB_LOGIN:BEGIN
  
	DECLARE x_user_id int;
	select id into x_user_id from admin_user where username = V_IN_USERNAME and `password` = V_IN_PASSWORD limit 0,1;
	if(x_user_id is null) then 
		select 1 status, "Login fail, not found user." msg, '{}' data;

	LEAVE LB_LOGIN;
	end if;
	
	
	select 0 status, "success" msg, JSON_OBJECT('id',id,"fullname",fullname,"roles",roles,"address",address,"mobile",mobile,"is2Fa",is2Fa,"secret",secret) data
	from admin_user
	where id = x_user_id 
	limit 0,1;

END