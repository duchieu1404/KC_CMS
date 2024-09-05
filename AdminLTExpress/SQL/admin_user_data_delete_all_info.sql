CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_user_data_delete_all_info`(in V_IN_USER_ID int)
BEGIN
  
DECLARE finished INTEGER DEFAULT 0;
DECLARE x_table_name varchar(100);
DECLARE x_result_category text;
DECLARE x_temp CURSOR FOR 
select DISTINCT table_name
from config_sync_category 
;


DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
OPEN x_temp;
read_loop: LOOP
	FETCH x_temp INTO x_table_name;

	IF finished = 1 THEN 
		LEAVE read_loop;
	END IF;

call admin_user_data_delete_all_info_by_category(V_IN_USER_ID,x_table_name);

END LOOP read_loop;
CLOSE x_temp;
commit;
END