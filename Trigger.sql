DELIMITER //
CREATE TRIGGER before_insert_data
	BEFORE INSERT
    ON course FOR EACH ROW
    BEGIN
    	if(NEW.credits > 4) THEN
        	SET NEW.credits=4;
        
        END IF;
    END //
    DELIMITER ;



DELIMITER //
CREATE TRIGGER before_update_data
	BEFORE UPDATE
    ON course FOR EACH ROW
    BEGIN
    	if(NEW.credits > 4) THEN
        	SET NEW.credits=4;
        
        END IF;
    END //
    DELIMITER ;




DELIMITER //
CREATE TRIGGER data_back_up_course
	BEFORE UPDATE
    ON course FOR EACH ROW
    BEGIN
    	Insert into back_up_course VALUES
        (old.course_id,old.title,old.dept_name,old.credits);
        
    END //
    DELIMITER ;


DELIMITER //
CREATE TRIGGER data_back_up_course
	BEFORE DELETE
    ON course FOR EACH ROW
    BEGIN
    	Insert into back_up_course VALUES
        (old.course_id,old.title,old.dept_name,old.credits);
        
    END //
    DELIMITER ;


DELIMITER //
CREATE TRIGGER ERROR_MESS
	BEFORE UPDATE
    ON course FOR EACH ROW
    BEGIN
    	DECLARE error_msg varchar(255);
        
        set error_msg = ("not possible");
        
        if(new.credits > old.credits)
        	THEN
             SIGNAL SQLSTATE '45000'
            set MESSAGE_TEXT=error_msg;
           
        END if;
        
    END //
    DELIMITER ;



---task




DELIMITER //
CREATE TRIGGER insert_check_pop
	AFTER INSERT
    ON city FOR EACH ROW
    BEGIN
    	UPDATE country
        	set Population = (SELECT sum(Population) FROM city WHERE CountryCode=new.CountryCode) WHERE Code=new.CountryCode;
        
    END //
    DELIMITER ;


-- TASK


DELIMITER //
CREATE TRIGGER UPADTE_check_pop
	AFTER UPDATE
    ON city FOR EACH ROW
    BEGIN
    	UPDATE country
        	set Population = (SELECT sum(Population) FROM city WHERE CountryCode=new.CountryCode) WHERE Code=new.CountryCode;
        
    END //
    DELIMITER ;


DELIMITER //
CREATE TRIGGER delete_check_pop
	AFTER DELETE
    ON city FOR EACH ROW
    BEGIN
    	UPDATE country
        	set Population = (SELECT sum(Population) FROM city WHERE CountryCode=old.CountryCode) WHERE Code=old.CountryCode;
        
    END //
    DELIMITER ;







