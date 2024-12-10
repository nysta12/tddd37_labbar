/* ------ Drop tables ------*/
drop table if exists Reservation cascade;
drop table if exists Booking cascade;
drop table if exists Payment cascade;
drop table if exists Passenger cascade;
drop table if exists Has_ticket cascade;
drop table if exists Contact cascade;
drop table if exists Flight cascade;
drop table if exists Weekly_schedule cascade;
drop table if exists Route cascade;
drop table if exists Airport cascade;
drop table if exists Has_route cascade;
drop table if exists Year cascade;
drop table if exists Day cascade;
drop table if exists Reserved_passengers cascade;


/* ------ Drop procedures ------ */
drop procedure if exists addYear;
drop procedure if exists addDay;
drop procedure if exists addDestination;
drop procedure if exists addRoute;
drop procedure if exists addFlight;
drop procedure if exists addReservation;
drop procedure if exists addPassenger;
drop procedure if exists addContact;
drop procedure if exists addPayment;

/* ------ Drop functions ------*/
drop function if exists calculateFreeSeats;
drop function if exists calculatePrice;



/* ------ Create tables ------ */
create table Reservation(
reservation_number int not null auto_increment,
flight int,
contact int,
constraint pk_reservation
primary key(reservation_number));
    
create table Booking(
reservation_number int,
paid_price double,
person_paying int,
constraint pk_booking
primary key(reservation_number));
    
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
primary key(passport_number));

create table Has_ticket(
ticket_number int not null,
booking int,
passenger int,
constraint pk_has_ticket
primary key(booking, passenger));
    
create table Contact(
phone_number bigint,
passport_number int,
email varchar(30),
constraint pk_contact
primary key (passport_number));
    
create table Flight(
flight_number int auto_increment,
week_id int,
week_number int,
constraint pk_flight
primary key (flight_number));

create table Weekly_schedule(
week_id int not null auto_increment,
departure_time time,
route int,
day varchar(10),
constraint pk_weekly_schedule
primary key (week_id));

create table Route(
route_id int not null auto_increment,
departure varchar(3),
arrival varchar(3),
year_id int,
routeprice double,
constraint pk_route
primary key (route_id));
    
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
primary key (route, year));

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
primary key (day_id, year));
    
create table Reserved_passengers(
passport_number int,
reservation_number int,
constraint pk_reserved_passengers
primary key (passport_number, reservation_number));


/* ------ Add the foreign keys ------ */
alter table Reservation add constraint fk_reservation_contact foreign key (contact) references Contact (passport_number);
alter table Reservation add constraint fk_reservation_flight foreign key (flight) references Flight (flight_number);

alter table Booking add constraint fk_booking_person_paying foreign key (person_paying) references Payment (payment_id);
alter table Booking add constraint fk_booking_reservation_number foreign key (reservation_number) references Reservation (reservation_number);

alter table Has_ticket add constraint fk_has_ticket_booking foreign key (booking) references Booking (reservation_number);
alter table Has_ticket add constraint fk_has_ticket_passenger foreign key (passenger) references Passenger (passport_number);

alter table Contact add constraint fk_contact_passport_number foreign key (passport_number) references Passenger (passport_number);

alter table Flight add constraint fk_flight_week foreign key (week_id) references Weekly_schedule (week_id);

alter table Weekly_schedule add constraint fk_weekly_schedule_route foreign key (route) references Route (route_id);
alter table Weekly_schedule add constraint fk_weekly_schedule_day foreign key (day) references Day (day_id);

alter table Route add constraint fk_route_departure foreign key (departure) references Airport (airport_code);
alter table Route add constraint fk_route_arrival foreign key (arrival) references Airport (airport_code);

alter table Has_route add constraint fk_has_route_route foreign key (route) references Route (route_id);
alter table Has_route add constraint fk_has_route_year foreign key (year) references Year (year_id);

alter table Reserved_passengers add constraint fk_reserved_passengers_reservation_number foreign key (reservation_number) references Reservation (reservation_number);
alter table Reserved_passengers add constraint fk_reserved_passengers_passport_number foreign key (passport_number) references Passenger (passport_number);


/* ------ Create procedures for populating the database with flights and more ------ */
delimiter //

create procedure addYear (in year int, in factor double)
begin
    insert into Year (year_id, profit_factor)
    values (year, factor);
end;
//

create procedure addDay (in year int, in day varchar(30), in factor double)
begin
    insert into Day (day_id, year, pricing_factor)
    values (day, year, factor);
end;
//

create procedure addDestination (in airport_code varchar(3), in name varchar(30), in country varchar(30))
begin
    insert into Airport (airport_code, airport_name, country)
    values (code, name, country);
end;
//

create procedure addRoute (in departure_airport_code VARCHAR(3), in arrival_airport_code VARCHAR(3), in year int, in routeprice double)
begin
    insert into Route (departure, arrival, year_id, route_price)
    values (departure_airport_code, arrival_airport_code, year, routeprice);
end;
//

create procedure addFlight (in departure_airport_code varchar(3), in arrival_airport_code varchar(3), in year int, in day varchar(30), in departuretime time)
begin
	declare week_nr int;
    set week_nr = 1;
    
    insert into Weekly_schedule(week_id, departure_time, route, day)
    values (null, departuretime,
    (select Route.route_id from Route where departure_airport_code = Route.departure and arrival_airport_code = Route.arrival and year = Route.year_id)
    , day);
    
    while week_nr <= 52 do
		insert into Flight values (NULL, week_nr, (select max(week_id) from Weekly_schedule));
        set week_nr = week_nr + 1;
	end while;
end;
//

delimiter ;



/* ------ Create functions ------ */
delimiter //
create function calculateFreeSeats(flightnumber int)
returns int
begin
    declare booked_seats int;
    declare free_seats int;
    set booked_seats = (Select Count(*) from Booking where Booking.reservation_number in (Select Reservation.reservation_number from Reservation where Reservation.flight = flightnumber));
    set free_seats = 40 - booked_seats;
    return free_seats;
end;
//


create function calculatePrice(flightnumber int)
returns double
begin
    declare w_id int;
    declare r int;
    declare d int;
    declare y int;
    declare rp double;
    declare wf double;
    declare pf double;
    declare total_price double;
    
    select Flight.week_id into w_id from Flight where Flight.flight_number = flightnumber;
    select Weekly_schedule.route, Weekly_schedule.day into r, d from Weekly_schedule where w_id = Weekly_schedule.week_id;
    select Route.route_price into rp from Route where Route.route_id = r;
    select Day.pricing_factor, Day.year into wf, y from Day where Day.day_id = d;
    select Year.profit_factor into pf where Year.year_id = y;
    
	return round((r * wf * (((40 - calculateFreeSeats(flightnumber)) + 1) / 40) * pf), 2);

end;
//

delimiter ;



/* ------ Create trigger ------ */





/* ------ Create procedures for creating and handling a reservation from the front end ------ */
delimiter //

create procedure addReservation (in departure_airport_code varchar(3), in arrival_airport_code varchar(3),
in input_year int, in input_week int, in input_day varchar(30), in dep_time time, in number_of_passengers int, out output_reservation_nr int)
begin
	
    declare flight_nr int default 0;
    declare free_seats int;

	select Flight.flight_number into flight_nr from Flight where Flight.week_number = input_week and Flight.week_id =
    (select Weekly_schedule.week_id where Weekly_schedule.departure_time = dep_time and Weekly_schedule.day = input_day and
    Weekly_schedule.route = (select Route.route_id from Route where Route.year_id = input_year and
    Route.arrival = arrival_airport_code and Route.departure = departure_airport_code));
    
    if flight_nr = 0 then
		select "There exist no flight for the given route, date and time" as "Message";
        
    else
        select calculateFreeSeats(flight_nr) into free_seats;
        if free_seats < number_of_passengers then
            select "There are not enough seats available on the chosen flight" as "Message";
            set reservation_number = null;
            
        else
            insert into Reservation (flight) values (flight_nr);
            set reservationnumber = last_insert_id(); /*Using auto increment on reservation_number in Reservation so just take last inserted*/
        end if;
        
    end if;
end;
//


create procedure addPassenger (in reservation_nr int, in passport_number int, in passenger_name varchar(30))
begin

end;
//


create procedure addContact (in reservation_nr int, in passport_number int, in email varchar(30), in phone bigint)
begin

end;
//


create procedure addPayment (in reservation_nr int, in cardholder_name varchar(30), in credit_card_number bigint)
begin

end;
//




/* ------ Question 8 ------ */



/* ------ Question 9 ------ */



/* ------ Question 10 ------ */














