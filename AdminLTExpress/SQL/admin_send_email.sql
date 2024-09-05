CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_send_email`(in V_IN_ADMIN_ID int,
in V_IN_USER_ID int,
in V_IN_TITLE varchar(2000),
in V_IN_CONTENT text,
in V_IN_SEND_BY varchar(100),
in V_IN_GIFT text,
in V_IN_EMAIL_TYPE int,
in V_IN_TIME_EXPIRE datetime,
in V_IN_DATA_EXT longtext
)
BEGIN
DECLARE x_id_force_set int;

select id into x_id_force_set from email_user
where (V_IN_EMAIL_TYPE = 3 or V_IN_EMAIL_TYPE = 4) and  user_id = V_IN_USER_ID and (email_type = 3 or email_type = 4) limit 0,1;


if(x_id_force_set is not null) then

delete from email_user where id = x_id_force_set limit 1;
end if;

  
	insert into email_user(user_id,title,content,time_send,sent_by,gift,expire_time,email_type,data_etx)
	values(V_IN_USER_ID,V_IN_TITLE,V_IN_CONTENT,now(),V_IN_SEND_BY,if(V_IN_EMAIL_TYPE = 1 or V_IN_EMAIL_TYPE = 3 or V_IN_EMAIL_TYPE = 4 ,V_IN_GIFT,'{}'),V_IN_TIME_EXPIRE,V_IN_EMAIL_TYPE,V_IN_DATA_EXT);
	select 0 status,"Send email success" msg,"{}" data;
	commit;
END