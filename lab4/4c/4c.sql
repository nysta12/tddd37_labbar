/* ------ Drop tables ------*/
DROP TABLE IF EXISTS Reservation CASCADE;
DROP TABLE IF EXISTS Booking CASCADE;
DROP TABLE IF EXISTS Payment CASCADE;
DROP TABLE IF EXISTS Passenger CASCADE;
DROP TABLE IF EXISTS Has_ticket CASCADE;
DROP TABLE IF EXISTS Contact CASCADE;
DROP TABLE IF EXISTS Flight CASCADE;
DROP TABLE IF EXISTS Weekly_schedule CASCADE;
DROP TABLE IF EXISTS Route CASCADE;
DROP TABLE IF EXISTS Airport CASCADE;
DROP TABLE IF EXISTS Has_route CASCADE;
DROP TABLE IF EXISTS Year CASCADE;
DROP TABLE IF EXISTS Day CASCADE;
DROP TABLE IF EXISTS Reserved_passengers CASCADE;

/* ------ Drop procedures ------*/
DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPayment;

/* ------ Drop functions ------*/
DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;



/* ------ Create tables ------ */
create table Reservation(
reservation_number int,
flight int,
contact int,
constraint pk_reservation
primary key(reservation_number),
constraint fk_reservation_contact
foreign key (contact) references Contact (passport_number),
constraint fk_reservation_flight
foreign key (flight) references Fight (flight_number));
    
create table Booking(
reservation_number int,
paid_price double,
person_paying int,
constraint pk_booking
primary key(reservation_number),
constraint fk_booking_person_paying
foreign key (person_paying) references Payment (payment_id),
constraint fk_booking_reservation_number
foreign key (reservation_number) references Reservation (reservation_number));
    
create table Payment(
payment_id int not null auto_increment,
card_holder varchar(30),
card_number bigint,
constraint pk_payment
primary key(payment_id));
    
create table Passenger(
passport_number int,
passenger_name varchar(30),
constraint pk_passenger
primary key(passportnumber));

create table Has_ticket(
ticket_number int not null,
booking int,
passenger int,
constraint pk_has_ticket
primary key(booking, passenger),
constraint fk_has_ticket_booking
foreign key (booking) references Booking (reservation_number),
constraint fk_has_ticket_passenger
foreign key (passenger) references Passenger (passport_number));
    
create table Contact(
phone_number bigint,
passport_number int,
email varchar(30),
constraint pk_contact
primary key (passport_number),
constraint fk_contact_passport_number
foreign key (passport_number) references Passenger (passport_number));
    
create table Flight(
flight_number int auto_increment,
week int,
constraint pk_flight
primary key (flight_number),
constraint fk_flight_week
foreign key (week) references Weekly_schedule (week_id));

create table Weekly_schedule(
week_id int not null auto_increment,
departure_time time,
route int,
day varchar(10),
constraint pk_weekly_schedule
primary key (week_id),
constraint fk_weekly_schedule_route
foreign key (route) references Route (route_id),
constraint fk_weekly_schedule_day
foreign key (day) references Day (day_id));

create table Route(
route_id int not null auto_increment,
departure varchar(3),
arrival varchar(3),
year_id int,
routeprice double,
constraint pk_route
primary key (route_id),
constraint fk_route_departure
foreign key (departure) references Airport (airport_code),
constraint fk_route_arrival
foreign key (arrival) references Airport (airport_code));
    
create table Airport(
airport_code varchar(3),
airport_name varchar(30),
country varchar(30),
constraint pk_airport
primary key (airport_code));
    
create table Has_route(
route int not null auto_increment,
year int,
route_price double,
constraint pk_has_route
primary key (route, year),
constraint fk_has_route_route
foreign key (route) references Route (route_id),
constraint fk_has_route_year
foreign key (year) references Year (year_id));

create table Year(
year_id int,
profit_factor double,
constraint pk_year
primary key (year_id));

create table Day(
day_id varchar(10),
year int,
pricing_factor double,
constraint pk_day
primary key (day, year));
    
create table Reserved_passengers(
passport_number int,
reservation_number int,
constraint pk_reserved_passengers
primary key (passport_number, reservation_number),
constraint fk_reserved_passengers_reservation_number
foreign key (reservation_number) references Reservation (reservation_number),
constraint fk_reserved_passengers_passport_number
foreign key (passport_number) references Passenger (passport_number));



/* ------ Create procedures ------ */
delimiter //
create procedure addYear (in year int, in factor double)
begin
    insert into Year (year_id, profit_factor)
    values (year, factor);
end;
//
delimiter;

delimiter //
create procedure addDay (in year int, in day varchar(30), in factor double)
begin
    insert into Day (day_id, year, pricing_factor)
    values (day, year, factor);
end;
//
delimiter;

delimiter //
create procedure addDestination (in airport_code varchar(3), in name varchar(30), in country varchar(30))
begin
    insert into Airport (airport_code, airport_name, country)
    values (code, name, country);
end;
//
delimiter;

delimiter //
create procedure addRoute (in departure_airport_code VARCHAR(3), in arrival_airport_code VARCHAR(3), in year int, in routeprice double)
begin
    insert into Route (departure, arrival, year_id, route_price)
    values (departure_airport_code, arrival_airport_code, year, routeprice);
end;
//
delimiter;

delimiter //
create procedure addFlight (in departure_airport_code varchar(3), in arrival_airport_code varchar(3), in year int, in day varchar(30), in departuretime time)
begin
    
end;
//
delimiter;



/* ------ Create functions ------ */
delimiter //
create function calculateFreeSeats(flightnumber int)
returns int
begin
    
end;
//
delimiter ;


delimiter //
create function calculatePrice(flightnumber int)
returns double
begin
    
end;
//
delimiter ;



















