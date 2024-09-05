CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_tester_get_all`()
BEGIN
	
	select * from user_test;
END