CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_send_email_all`(in V_IN_ADMIN_ID int,
in V_IN_USER_ID int,
in V_IN_TITLE varchar(2000) CHARSET utf8mb4,
in V_IN_CONTENT text CHARSET utf8mb4,
in V_IN_SEND_BY varchar(100),
in V_IN_GIFT text,
in V_IN_EMAIL_TYPE int,
in V_IN_TIME_EXPIRE datetime,
in V_IN_DATA_EXT longtext,
in V_IN_NOTIFICATION text CHARSET utf8mb4
)
BEGIN
DECLARE x_notification text;
DECLARE x_additional_data text;
set x_notification = JSON_OBJECT("en",V_IN_NOTIFICATION);
set x_additional_data = JSON_OBJECT("action","OPEN_MAIL_BOX","data","{}");

INSERT INTO `email_user_for_all`( `title`, `content`, `time_send`, `sent_by`, `gift`, `expire_time`, `email_type`, `is_deleted`, `is_auto_delete`, `user_send_id`, `user_send_avatar_id`, `user_send_avatar_url`, `user_send_fullname`, `tracking_location`)
VALUES ( V_IN_TITLE ,V_IN_CONTENT , now(), V_IN_SEND_BY, if(V_IN_EMAIL_TYPE = 1 or V_IN_EMAIL_TYPE = 3 or V_IN_EMAIL_TYPE = 4, V_IN_GIFT,'{}') ,V_IN_TIME_EXPIRE, V_IN_EMAIL_TYPE ,0 , 1, V_IN_USER_ID, NULL, NULL, NULL, 'SEND_ALL_EMAIL');
 
	if(V_IN_NOTIFICATION is not null or V_IN_NOTIFICATION <> '') then
	insert into push_schedule (included_segments,contents,data) VALUES ('["Test_Users"]',x_notification,x_additional_data);
	end if;
END