CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_popup_delete`(in V_IN_ADMIN_ID int, in V_IN_ID int)
BEGIN
	
	delete from event_popup where id = V_IN_ID limit 1;
	select 0 status, "Delete success" msg;
END