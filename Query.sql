CREATE TABLE employee(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	employeeId VARCHAR(20) NOT NULL,
	empName VARCHAR(100) NOT NULL
	)

CREATE TABLE student(
	
	id INT PRIMARY KEY AUTO_INCREMENT,
	student_name VARCHAR(100) NOT NULL,
	dept_name VARCHAR(100) NOT NULL,
	`session` VARCHAR(20) NOT NULL,
	email VARCHAR(100),
	cgpa NUMERIC(4,3)
)

ALTER TABLE student DROP id;
ALTER TABLE student ADD roll VARCHAR(100) NOT NULL;
ALTER TABLE student ADD roll_no VARCHAR(100) NOT NULL AFTER id;
ALTER TABLE student MODIFY roll_no VARCHAR(20)

DROP TABLE student;
alter table student DROP column roll

INSERT INTO student(id,roll_no,student_name,dept_name,`session`,email,cgpa)
VALUES(NULL,"123","AA","CSE","2017-18","skdkfj@gmail.com",3.25),
(NULL,"235","AA","CSE","2017-18","skdkfj@gmail.com",4.25)

DELETE FROM student WHERE roll_no = 123;
TRUNCATE student;

INSERT INTO employee(employeeId,empName)
SELECT roll_no , student_name FROM student;

UPDATE instructor
SET salary = salary * 1.05;

UPDATE instructor
SET salary = salary * 1.02
WHERE salary > 84000;

UPDATE course
SET credits = credits * 1.05
WHERE credits < (SELECT AVG(credits)FROM course);

UPDATE instructor
SET salary = case
				when salary <= 100000 then salary * 1.05
				ELSE salary * 1.03
				end
			
DELETE FROM course
WHERE dept_name = 'Finance';

SELECT course_id,title,dept_name
FROM course
WHERE credits = 3;

SELECT * 
FROM course
WHERE credits = 3
ORDER BY dept_name DESC , title;

SELECT *
FROM course LIMIT 3 , 4;

SELECT *
FROM instructor
WHERE `name` IN('Mozart','Einstein');

SELECT *
FROM instructor
WHERE id IN(SELECT id from instructor WHERE id<30000);

SELECT *
FROM instructor
WHERE `name` Not IN('Mozart','Einstein');

SELECT `name`,salary
FROM instructor
WHERE salary BETWEEN 68000 AND 90000;

INSERT INTO instructor
VALUES('23443','MI',NULL,'400000');

SELECT *
FROM instructor
WHERE dept_name IS NULL;

SELECT *
FROM instructor
WHERE dept_name <=> NULL;

SELECT  * FROM course
WHERE BINARY   title LIKE '%History';

SELECT * FROM instructor
WHERE `name` LIKE '_i%';

SELECT * FROM instructor
WHERE EXISTS(
	SELECT Id
	FROM teaches
	WHERE 
		instructor.ID = teaches.Id and
		teaches.semester = 'fall'
	);
SELECT AVG(salary)
FROM instructor
WHERE dept_name = 'Comp. Sci.';

SELECT COUNT(DISTINCT dept_name)
FROM instructor;

SELECT COUNT(*) AS num_row
FROM instructor;

SELECT MIN(salary) FROM instructor;

SELECT dept_name,AVG(salary)AS avg_salary
FROM instructor
GROUP BY dept_name;

SELECT dept_name, COUNT(id) AS num_teacher
FROM instructor
GROUP BY dept_name
HAVING num_teacher > 1;

SELECT dept_name , MIN(salary) AS min_salary ,
		 MAX(salary) AS max_salary
FROM instructor
GROUP BY dept_name;

SELECT dept_name, COUNT(*) FROM instructor
WHERE salary IS NULL
GROUP BY dept_name

SELECT * FROM instructor , department

SELECT * FROM instructor , department
WHERE instructor.dept_name = department.dept_name

SELECT 
	name,instructor.dept_name , building
FROM
	instructor , department
WHERE 
	instructor.dept_name = department.dept_name;
	
SELECT 
	`name` , course_id , `year`
FROM instructor , teaches
WHERE instructor.ID = teaches.ID;

SELECT *
FROM instructor , teaches , course
WHERE instructor.ID = teaches.ID AND 
		teaches.course_id=course.course_id;
SELECT 
	`name`,teaches.course_id,title,`year`
FROM
	instructor , teaches , course
WHERE 
	instructor.ID = teaches.ID AND 
		teaches.course_id = course.course_id;	

SELECT DISTINCT S.name
FROM 
	instructor AS S , instructor AS T
WHERE 
	S.salary > T.salary AND T.dept_name = 'Comp. Sci.';

SELECT 
	`name`,teaches.course_id,title,`year`
FROM
	instructor NATURAL JOIN teaches NATURAL JOIN course;
	
SELECT 
	instructor.id , instructor.`name` , teaches.*
FROM 
	instructor LEFT JOIN teaches
ON 
	instructor.ID = teaches.ID
WHERE
	teaches.ID IS NULL

UNION 

SELECT 
	instructor.id , instructor.`name` , teaches.*
FROM 
	instructor RIGHT  JOIN teaches
ON 
	instructor.ID = teaches.ID
WHERE
	teaches.ID IS NULL;
	
CREATE USER 'riyad'@'localhost' IDENTIFIED BY '1234';

SHOW GRANTS FOR 'root'@'localhost';

SELECT * FROM mysql.user;

GRANT 
	permission1,permission2
ON
	DATABASE_name.`table_name`
TO 
	`database_user`@'hostname';
	
GRANT 
	ALL PRIVILEGES 
ON
	university_db.instructor
TO
	'riyad'@'localhost';
	
FLUSH PRIVILEGES;

DROP USER 'riyad'@'localhost';

CREATE TRIGGER trigger_name
	(AFTER|BEFORE)(INSERT|UPDATE|DELETE)
		ON `table_name` FOR  EACH row
			begin
				--variable declarations
				--`trigger` `code`
			END
			
CREATE TABLE employee(  
    name varchar(45) NOT NULL,    
    occupation varchar(35) NOT NULL,    
    working_date date,  
    working_hours varchar(10)  
);  

University_db_pracINSERT INTO employee VALUES    
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER //

CREATE TRIGGER before_update_emworkinghousrs
before update ON employee FOR EACH ROW 
	begin
		if NEW.working_hours < 0 Then SET NEW.working_hours = 0;
		END if;
	END //

DELIMITER ;  

DROP trigger trigger_name;

INSERT INTO employee VALUES    
('Alexander', 'Actor', '2020-10-012', -13); 

SHOW TRIGGERS;
SHOW TRIGGERS LIKE pattern;
SHOW TRIGGERS FROM database_name LIKE pattern;
SHOW TRIGGERS WHERE search_conditon;
SHOW TRIGGERS FROM University_db_prac WHERE TABLE = 'employee';

CREATE TABLE if NOT EXISTS employee_backup(
	`name` VARCHAR(45) NOT NULL,
	`occupation`VARCHAR(35) NOT NULL,
	`working_date` DATE DEFAULT NULL,
	`working_hours` VARCHAR(10) DEFAULT NULL,
	`last_update` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER before_update_employee
BEFORE UPDATE ON employee FOR EACH ROW
BEGIN
	INSERT INTO employee_backup values
	(OLD.`name`,OLD.occupation,OLD.working_date,old.working_hours,CURRENT_TIMESTAMP());
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER before_update_salesInfo
BEFORE UPDATE 
ON sales_info FOR EACH ROW
BEGIN
	DECLARE error_msg VARCHAR(255);
	SET error_msg = ("quantity cannot be greater than 2");
	if NEW.quantity > OLD.quantity * 2 then
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = error_msg;
	END if;
END //

DELIMITER ;

CREATE TABLE salary_archives (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    emp_num INT,  
    valid_from DATE NOT NULL,  
    amount DEC(18 , 2 ) NOT NULL DEFAULT 0,  
    deleted_time TIMESTAMP DEFAULT NOW()  
);  

DELIMITER $$  
  
CREATE TRIGGER before_delete_salaries  
BEFORE DELETE  
ON salaries FOR EACH ROW  
BEGIN  
    INSERT INTO salary_archives (emp_num, valid_from, amount)  
    VALUES(OLD. emp_num, OLD.valid_from, OLD.amount);  
END$$   
  
DELIMITER ;

UPDATE country
	SET country.Population = (SELECT SUM(Population) FROM city WHERE CountryCode = 'BGD')
WHERE country.code = 'BGD';

UPDATE country as t1
	Inner JOIN(SELECT CountryCode , SUM(Population) as sum_population FROM city GROUP BY CountryCode) as t2
	ON t2.CountryCode = t1.`Code`
	SET t1.Population = t2.sum_population
WHERE t1.CountryCode = t2.`code`

DELIMITER //

CREATE TRIGGER after_insert_cityPopulation
AFTER INSERT 
ON city FOR EACH ROW 
	BEGIN 
		UPDATE country
		SET country.Population = country.Population + NEW.population
		WHERE country.`code` = NEW.CountryCode;
	END //
	
DELIMITER ;

INSERT INTO city VALUES
(NULL,'pijush','BGD','ABCDE',10000000);

SELECT * 
	FROM city
	WHERE city.Name = 'pijush';

DELIMITER //

CREATE TRIGGER after_update_cityPopulation
AFTER Update
ON city FOR EACH ROW 
	BEGIN 
		UPDATE country
		SET country.Population = country.Population + NEW.population - OLD.population
		WHERE country.`code` = NEW.CountryCode;
	END //
	
DELIMITER ;

UPDATE city
SET city.Population = 0
WHERE city.CountryCode = 'BGD' AND city.Name = 'AAa';

SELECT * FROM country
WHERE country.code = 'BGD';

DELIMITER //

CREATE TRIGGER after_delete_cityPopulation
AFTER DELETE 
ON city FOR EACH ROW 
	BEGIN 
		UPDATE country
		SET country.Population = country.Population - OLD.population
		WHERE country.`code` = OLD.CountryCode;
	END //
	
DELIMITER ;

DELETE FROM city WHERE city.CountryCode = 'BGD' AND city.Name = 'AAa';

