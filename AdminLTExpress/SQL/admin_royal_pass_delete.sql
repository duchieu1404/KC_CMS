CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_royal_pass_delete`(in V_IN_ADMIN_ID int,
in V_IN_EVENT_ID int)
BEGIN


delete from event_royal_pass_config where id = V_IN_EVENT_ID and status <> 1;
	select 0 status, "Delete success" msg;

END