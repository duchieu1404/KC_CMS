CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_tester_delete`(in V_IN_ADMIN_ID int, in V_IN_TESTER_ID int)
BEGIN
	
	delete from user_test where id = V_IN_TESTER_ID limit 1;
	select 0 status, "Delete success" msg;
END