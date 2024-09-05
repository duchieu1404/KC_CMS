CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_get_all_user_data`(in V_IN_ADMIN_ID int,
in V_IN_USER_ID int)
BEGIN
DECLARE x_data text;
call user_data_get_all_info(V_IN_USER_ID,x_data);

select 0 status,"OK" msg, x_data data;
END