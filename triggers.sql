Use practice;
show tables;
SELECT * from employees;
SELect * from customers;

CREATE TABLE car_inventory (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2),
    status VARCHAR(20)
);
SELECT * FROM car_inventory;
CREATE TABLE car_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    action_type VARCHAR(20),
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO car_inventory (model, brand, price, status)
VALUES 
('Swift', 'Maruti', 550000, 'Available'),
('i20', 'Hyundai', 650000, 'Available'),
('Tiago', 'Tata', 500000, 'Sold');

SELECT * FROM car_inventory;
SELECT * FROM car_log;

	DELIMITER $$
	CREATE TRIGGER new_car
	AFTER INSERT ON car_inventory
	FOR EACH ROW
    BEGIN 
		 INSERT INTO car_log (car_id , action_type , new_price , log_time)
		 VALUES (new.car_id , 'INSERT' , new.price, now());
		
	END $$
DELIMITER ;
show triggers;
DROP trigger price_log;
DELIMITER $$

CREATE TRIGGER price_log
AFTER UPDATE ON car_inventory
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT INTO car_log (car_id, action_type, old_price, new_price, log_time)
        VALUES (NEW.car_id, 'UPDATE', OLD.price, NEW.price, NOW());
    END IF;
END $$
DELIMITER ;
UPDATE car_inventory SET `price` = 750000 WHERE car_id = 1;
SELECT * FROM car_log;
DESCRIBE car_inventory;


DELIMITER $$

CREATE TRIGGER log_car_delete
AFTER DELETE ON car_inventory
FOR EACH ROW
BEGIN
    INSERT INTO car_log (car_id, action_type, old_price, log_time)
    VALUES (OLD.car_id, 'DELETE', OLD.price, NOW());
END $$

DELIMITER ;
DELETE FROM car_inventory WHERE car_id = 4;
