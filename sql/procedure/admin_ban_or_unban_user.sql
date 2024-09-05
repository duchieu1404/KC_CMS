CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_ban_or_unban_user`(in V_IN_ADMIN_ID int,
in V_IN_USER_ID int,
in V_IS_BAN int)
LB_SELECT:BEGIN
	declare x_banned bit;
	
	select is_banned into x_banned from user_recently where id = V_IN_USER_ID;
	
	IF(x_banned is not null and x_banned = 1 and V_IS_BAN = 1)then
		select 1 status, "Don't ban this user just because they were banned before" msg; 
		leave LB_SELECT;
	end if;
	
	IF(x_banned is null or (x_banned = 0 and V_IS_BAN = 0))then
		select 1 status, "Don't unban this user just because they are not currently banned." msg; 
		leave LB_SELECT;
	end if;
	
	
	if(V_IS_BAN is not null and V_IS_BAN = 1) then
		update user_recently set is_banned = V_IS_BAN , type_banned = 0 ,last_time_banned = NOW() where id = V_IN_USER_ID ;
		select 0 status, CONCAT("Banned user id = ",V_IN_USER_ID," successfuly")  msg; 
	else 
		update user_recently set is_banned = V_IS_BAN , type_banned = 0 where id = V_IN_USER_ID ;
		select 0 status, CONCAT("UnBanned user id = ",V_IN_USER_ID," successfuly")  msg; 
	end if;
	

END