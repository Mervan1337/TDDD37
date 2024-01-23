UNLOCK TABLES;
SET foreign_key_checks = 0;
DROP TABLE IF EXISTS reservation_on_passenger;
DROP TABLE IF EXISTS contact_person;
DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS route;
DROP TABLE IF EXISTS airport;
DROP TABLE IF EXISTS pricing;
DROP TABLE IF EXISTS passenger;
DROP TABLE IF EXISTS flight;
DROP TABLE IF EXISTS year;
DROP TABLE IF EXISTS weekday;

DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;
DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;
DROP TRIGGER IF EXISTS CreateUniqueTicket;
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP VIEW IF EXISTS allFlights;
DROP PROCEDURE IF EXISTS addPayment;
SET foreign_key_checks = 1;


CREATE TABLE IF NOT EXISTS airport(
    code VARCHAR(3) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    country VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS route (
    unique_id int PRIMARY KEY AUTO_INCREMENT,
    year int NOT NULL,
    price_for_route int NOT NULL,
    arrival VARCHAR(3) NOT NULL,
    departure VARCHAR(3) NOT NULL,
    FOREIGN KEY (arrival) REFERENCES airport(code),
    FOREIGN KEY (departure) REFERENCES airport(code)
);

CREATE TABLE IF NOT EXISTS schedule (
    id             int primary key AUTO_INCREMENT,
    year           int         NOT NULL,
    day            VARCHAR(10) NOT NULL,
    departure_time TIME        NOT NULL,
    route_unique_id int NOT NULL,
    departure      VARCHAR(3) NOT NULL,
    arrival        VARCHAR(3) NOT NULL,
    FOREIGN KEY (route_unique_id) REFERENCES route(unique_id),
    FOREIGN KEY (departure) REFERENCES airport(code),
    FOREIGN KEY (arrival) REFERENCES airport(code)
);

CREATE TABLE IF NOT EXISTS flight
(
    flightnumber    int PRIMARY KEY AUTO_INCREMENT,
    week            VARCHAR(10) NOT NULL,
    number_of_seats int         NOT NULL,
    schedule_id     int         NOT NULL,
    FOREIGN KEY (schedule_id) REFERENCES schedule(id)
);

CREATE TABLE IF NOT EXISTS passenger
(
    passport_number int PRIMARY KEY,
    name      VARCHAR(30) NOT NULL,
    reservation_number int NOT NULL,
    FOREIGN KEY (reservation_number) REFERENCES flight(flightnumber)
);

CREATE TABLE IF NOT EXISTS contact_person
(
    phone_number bigint NOT NULL,
    email        VARCHAR(30) NOT NULL,
    passport_number int,
    FOREIGN KEY (passport_number) REFERENCES passenger(passport_number),
    PRIMARY KEY (passport_number)
);

CREATE TABLE IF NOT EXISTS reservation
(
    reservation_number int PRIMARY KEY AUTO_INCREMENT,
    flight_number       int NOT NULL,
    contact_person_passport_number int,
    foreign key (flight_number) references flight(flightnumber),
    foreign key (contact_person_passport_number) references passenger(passport_number)
);

CREATE TABLE IF NOT EXISTS payment
(
    transaction_id int PRIMARY KEY,
    card_holder_name varchar(30)    NOT NULL,
    card_number      BIGINT    NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES reservation(reservation_number)
);

CREATE TABLE IF NOT EXISTS ticket
(
    ticket_id int,
    passenger_passport_number int NOT NULL,
    reservation_number int NOT NULL,
    PRIMARY KEY (passenger_passport_number, reservation_number),
    FOREIGN KEY (passenger_passport_number) REFERENCES passenger(passport_number),
    FOREIGN KEY (reservation_number) REFERENCES reservation(reservation_number)
);

CREATE TABLE IF NOT EXISTS year
(
    year int PRIMARY KEY,
    profit_factor double NOT NULL
);

CREATE TABLE IF NOT EXISTS weekday
(
    year int NOT NULL,
    weekday VARCHAR(10) PRIMARY KEY,
    weekday_factor double NOT NULL
);

CREATE TABLE IF NOT EXISTS reservation_on_passenger (
    passenger_passport_number int NOT NULL,
    reservation_number int NOT NULL,
    FOREIGN KEY (passenger_passport_number) REFERENCES passenger(passport_number),
    FOREIGN KEY (reservation_number) REFERENCES reservation (reservation_number)
);
DELIMITER //
CREATE PROCEDURE addYear(IN year int, IN factor double)
BEGIN
    INSERT INTO year VALUES(year, factor);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addDay(IN year int, IN weekday VARCHAR(10), IN factor double)
BEGIN
    INSERT INTO weekday VALUES(year, weekday, factor);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3), IN name VARCHAR(30), IN country VARCHAR(30))
BEGIN
    INSERT INTO airport VALUES(airport_code, name, country);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year2 int, IN routeprice double)
BEGIN
    INSERT INTO route(year, price_for_route, arrival, departure) VALUES(year2, routeprice, arrival_airport_code, departure_airport_code);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year2 int, IN day2 VARCHAR(10), IN departure_time2 TIME)
BEGIN
    DECLARE weekCounter INT DEFAULT 1;
    DECLARE route_id INT;

    SELECT route.unique_id INTO route_id FROM route WHERE route.year = year2 AND route.arrival = arrival_airport_code AND route.departure = departure_airport_code;
    INSERT INTO schedule(year, day, departure_time, route_unique_id, departure, arrival) VALUES (year2, day2, departure_time2, route_id, departure_airport_code, arrival_airport_code);
    while weekCounter <= 52 DO
        INSERT INTO flight(week, number_of_seats, schedule_id) VALUES(weekCounter, 40, (SELECT id FROM schedule WHERE schedule.year = year2 AND schedule.day = day2 AND schedule.departure_time = departure_time2));
        SET weekCounter = weekCounter + 1;
    END WHILE;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION calculateFreeSeats(flightnumber INT) RETURNS INT
BEGIN
    DECLARE freeSeats INT;
    SELECT COUNT(*) INTO freeSeats FROM passenger WHERE reservation_number IN (SELECT reservation_number FROM ticket WHERE reservation_number IN (SELECT reservation_number FROM reservation WHERE flight_number = flightnumber));
    IF freeSeats IS NULL THEN
        SET freeSeats = 0;
    END IF;


    RETURN 40 - freeSeats;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION calculatePrice(flightNumber_id INT) RETURNS DOUBLE
BEGIN
    DECLARE price DOUBLE DEFAULT 0;
    DECLARE routeprice DOUBLE;
    DECLARE weekdayfactor DOUBLE;
    DECLARE profitfactor DOUBLE;
    DECLARE bookedpassengers  INT;
    DECLARE y INT;
    DECLARE weekly_schedule_id INT;
    declare freeseats int;

    select schedule_id into weekly_schedule_id FROM flight WHERE flightnumber=flightNumber_id;
    SELECT year into y from schedule WHERE id = weekly_schedule_id;
    SELECT price_for_route into routeprice FROM route WHERE year = y and (route.arrival, route.departure) IN (SELECT arrival,departure from schedule where id = weekly_schedule_id);

    SELECT weekday_factor into weekdayfactor FROM weekday WHERE year = y and weekday.weekday in (SELECT day from schedule WHERE id = weekly_schedule_id);
    select calculateFreeSeats(flightNumber_id) into freeseats;
    SET bookedpassengers = 40 - freeseats;
    SELECT profit_factor into profitfactor from year WHERE year = y;
     -- SET routeprice = 1;
     -- SET weekdayfactor = 1;
     -- SET profitfactor = 1;
    -- SET bookedpassengers = 1;
    SELECT ((routeprice * weekdayfactor) * ((bookedpassengers + 1)/40) * profitfactor) into price;
    RETURN price;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER CreateUniqueTicket
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    DECLARE unique_number INT;
    -- Putting in lots of zeros to make sure that the id is unique --
    SET unique_number = 100000 * rand();
    SET NEW.ticket_id = unique_number;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(30), IN arrival_airport_code VARCHAR(30), IN year2 int, IN week VARCHAR(10), IN day VARCHAR(10), IN time TIME, IN number_of_passenger INT,OUT output_reservation_number INT)
BEGIN
    DECLARE flight_number2 INT;

    SELECT flight.flightnumber INTO flight_number2 FROM flight JOIN schedule ON flight.schedule_id = schedule.id
    JOIN route ON schedule.route_unique_id = route.unique_id
    WHERE flight.week = week AND schedule.year = year2 AND schedule.day = day AND departure_time = time AND route.departure = departure_airport_code AND route.arrival = arrival_airport_code;
    /*SELECT flightnumber INTO flight_number2 FROM flight WHERE week = flight.week AND
                                                              schedule_id IN (SELECT id FROM schedule WHERE schedule.year = year2 AND schedule.day = day AND departure_time = time AND
                                        ID IN (SELECT route_unique_id FROM route WHERE departure = departure_airport_code AND arrival = arrival_airport_code AND route.year = year2));
    */
    IF flight_number2 IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There exist no flight for the given route, date and time';
    end if;
    IF calculateFreeSeats(flight_number2) < number_of_passenger THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There are not enough seats available on the chosen flight';
    END IF;

    INSERT INTO reservation(flight_number) VALUES(flight_number2);
    SET output_reservation_number = LAST_INSERT_ID();
END //
DELIMITER ;

DELIMITER //
CREATE procedure addPassenger(IN reservation_nr INT ,IN passport_number2 INT,IN name2 VARCHAR(30))
begin
    IF NOT exists(SELECT * FROM reservation WHERE reservation_number = reservation_nr) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The given reservation number does not exist';
    end if;
    IF EXISTS(SELECT * FROM payment WHERE transaction_id = reservation_nr) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The booking has already been payed and no futher passengers can be added';
    end if;
    IF NOT exists(SELECT * FROM passenger WHERE passport_number = passport_number2) THEN
        INSERT INTO passenger(passport_number, name, reservation_number) VALUES(passport_number2, name2, reservation_nr);
    END IF;

    INSERT INTO reservation_on_passenger(passenger_passport_number, reservation_number) VALUES(passport_number2, reservation_nr);
end //
DELIMITER //

DELIMITER //
CREATE PROCEDURE addContact(IN reservation_number2 INT, IN passport_number2 INT, IN email2 VARCHAR(30), IN phonenumber bigint)
BEGIN
    declare passenger_name varchar(30);


    IF NOT exists(SELECT * FROM reservation WHERE reservation_number = reservation_number2) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The given reservation number does not exist';
    end if;

    IF NOT exists(SELECT * FROM passenger WHERE reservation_number = reservation_number2) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The given passenger is not part of the given reservation or doesnt exist';
    END IF;

    SELECT name INTO passenger_name from passenger WHERE passenger.passport_number = passport_number2;
    IF passenger_name IS NOT NULL THEN
        INSERT INTO contact_person(phone_number, email, passport_number) VALUES(phonenumber, email2, passport_number2);
        UPDATE reservation SET contact_person_passport_number = passport_number2 WHERE reservation_number = reservation_number2;
    END IF;


END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addPayment(IN reservation_number2 INT, IN card_holder_name2 VARCHAR(30), IN card_number2 BIGINT)
BEGIN
    IF NOT exists(SELECT * FROM reservation WHERE reservation_number = reservation_number2) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The given reservation number does not exist';
    end if;
    IF NOT exists(SELECT * FROM reservation WHERE reservation_number = reservation_number2 AND contact_person_passport_number IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The reservation has no contact yet';
    end if;
    IF calculateFreeSeats((SELECT flight_number FROM reservation WHERE reservation_number = reservation_number2)) < (SELECT COUNT(*) FROM reservation_on_passenger WHERE reservation_number = reservation_number2) THEN
        DELETE FROM reservation_on_passenger WHERE reservation_number = reservation_number2;
        DELETE FROM reservation WHERE reservation_number = reservation_number2;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There are not enough seats available on the flight anymore, deleting reservation';
    end if;
    INSERT INTO ticket(passenger_passport_number, reservation_number) VALUES ((SELECT contact_person_passport_number FROM reservation WHERE contact_person_passport_number in (SELECT passport_number from passenger where reservation_number = reservation_number2)), reservation_number2);
    INSERT INTO payment(transaction_id, card_holder_name, card_number) VALUES(reservation_number2, card_holder_name2, card_number2);
end //
DELIMITER ;

CREATE VIEW allFlights AS SELECT route.departure as 'departure_city_name', route.arrival as 'destination_city_name', schedule.departure_time as 'departure_time',
                                 schedule.day as 'departure_day', flight.week as 'departure_week', schedule.year as 'departure_year',
                                 calculateFreeSeats(flight.flightnumber) as 'nr_of_free_seats',
                                 calculatePrice(flight.flightnumber) as 'current_price_per_seat' FROM flight JOIN schedule ON flight.schedule_id = schedule.id
                                     JOIN route ON schedule.route_unique_id = route.unique_id;



-- Question 8 --

-- a) There is lots of different way to protect credit card information from hackers. You can protect it by using encryption, tokenization another way to do it, is to use password protection for the database together with two factor authentication to log in--
-- b) Performance - Stored procedures are compiled once and stored in an executable form. This results in the procedure being quick and efficient
-- Maintainability - After the procedure is validated you can easily use it in any number of applications, if the definition changes only the procedure is affected and not the application that calls it.
-- Security - Stored procedures provide a layer of security preventing SQL injection attack by limiting some of the SQL to be executed

-- Question 9 --
-- B) Since we have added start transaction we cant see the changes in the second window this is because we lock each session and actually need to commit to be able to do changes in the database
-- C) We cant do something in the second window. This is because of the transaction, for instance I tried to delete the reservation in the second windows but nothing happeneed since session b waits for session a to commit the reservation
-- When that is done we can actually delete it but for right now without the commit we just wait in session B and eventually we get "ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction".


-- Question 10 --
-- a) Overbooking did not occur because one of the scripts got an error message “The reservation has no contact yet” the error message is from addPayment which checks that reservations_number is not already used.
-- b) Overbooking can theoretically occur if multiple users try to make reservations at the same time.
-- This can happen when it starts a reservation before another reservation is done, this can lead to overbooking because it cannot see that there is a reservation that is not finished which will book the last seats.
-- c) As right now we aren't able to exactly produce this behaviour because when we make the check to see if the seats are available we do it in the addpayment which produce an unsolveable race condition of which ever session gets to the add payment first will be able to book the seats.
-- We also get for one session that there is no reservation number yet but that is because when we add the payment the reservation number gets used by the other session. We dont get any overbooking so start transaction and commit is enough according to us to prevent overbooking.

-- Secondary index could be useful for finding passengers faster when they are trying to retrieve borderpass. The table passenger has a primary index on passport_number and if you want to run queries to find passengers by name you can add a secondary index on the passengers name so you shorten the time when going through the queries. It gets shorter because you add all the names to a column so you only need to check the people with the same name instead of everyone. --