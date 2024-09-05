CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_delete_user`(in V_IN_ADMIN_ID int,
in V_IN_USER_ID int)
BEGIN
DECLARE x_username varchar(100);
DECLARE x_login_type int;

DECLARE x_team_id int;

select username,login_type into x_username,x_login_type
from user_recently where id = V_IN_USER_ID limit 0,1;

delete from user_recently where id =V_IN_USER_ID limit 1;
call admin_user_data_delete_all_info(V_IN_USER_ID);

delete from user_ref where user_id =V_IN_USER_ID limit 1;

delete from user_partions where username = x_username and login_type  = x_login_type limit 1;

delete from email_user where user_id = V_IN_USER_ID; 

select team_id into x_team_id from team_member where user_id = V_IN_USER_ID limit 0,1;
if(x_team_id is not null) then 
		call team_leave_no_out(V_IN_USER_ID,x_team_id);
		call team_request_cancel_no_out(V_IN_USER_ID,x_team_id);
		call team_refresh_total_star(x_team_id);
end if;



select 0 status, "OK" msg, '{}' data;	
commit;
END