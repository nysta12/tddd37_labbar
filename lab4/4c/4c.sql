set foreign_key_checks = 0;
/* ------ Drop tables ------*/
drop table if exists Reservation;
drop table if exists Booking;
drop table if exists Payment;
drop table if exists Passenger;
drop table if exists Has_ticket;
drop table if exists Contact;
drop table if exists Flight;
drop table if exists Weekly_schedule;
drop table if exists Route;
drop table if exists Airport;
drop table if exists Has_route;
drop table if exists Year;
drop table if exists Day;
drop table if exists Reserved_passengers;


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
set foreign_key_checks = 1;


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
flight_number int not null auto_increment,
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
DELIMITER //

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
    values (airport_code, name, country);
end;
//

create procedure addRoute (in departure_airport_code VARCHAR(3), in arrival_airport_code VARCHAR(3), in year int, in routeprice double)
begin
    insert into Route (departure, arrival, year_id, routeprice)
    values (departure_airport_code, arrival_airport_code, year, routeprice);
end;
//

create procedure addFlight (in departure_airport_code varchar(3), in arrival_airport_code varchar(3), in year int, in day varchar(30), in departuretime time)
begin
	declare week_nr int;
    set week_nr = 1;
    
    insert into Weekly_schedule(Weekly_schedule.departure_time, Weekly_schedule.route, Weekly_schedule.day)
    values (departuretime,
    (select route_id from Route where departure_airport_code = departure and arrival_airport_code = arrival and year = year_id)
    , day);
    
    repeat
		insert into Flight (Flight.week_number, Flight.week_id)
        values (week_nr, (select max(week_id) from Weekly_schedule));
        set week_nr = week_nr + 1;
	until week_nr = 52
	end repeat;
end;
//




/* ------ Create functions ------ */

create function calculateFreeSeats(flightnumber int)
returns int
begin
    declare booked_seats int;
    declare free_seats int;
    set booked_seats = (select count(*) from Booking where reservation_number in (select reservation_number from Reservation where flight = flightnumber));
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
    
    select week_id into w_id from Flight where Flight.flight_number = flightnumber;
    select route, day into r, d from Weekly_schedule where week_id = w_id;
    select route_price into rp from Route where route_id = r;
    select pricing_factor, year into wf, y from Day where day_id = d;
    select profit_factor into pf from Year where year_id = y;
    
	return round((r * wf * (((40 - calculateFreeSeats(flightnumber)) + 1) / 40) * pf), 2);

end;
//



/* ------ Create trigger ------ */

create trigger trig
before insert on Has_ticket for each row
begin
	declare t_nr int;
    
    repeat
		set t_nr = floor(100 * rand());
        until not exists (select 1 from Has_ticket where ticket_number = t_nr)
    end repeat;
    set new.ticket_number = t_nr;
end;
//



/* ------ Create procedures for creating and handling a reservation from the front end ------ */

create procedure addReservation (in departure_airport_code varchar(3), in arrival_airport_code varchar(3),
in input_year int, in input_week int, in input_day varchar(30), in dep_time time, in number_of_passengers int, out output_reservation_nr int)
begin
	
    declare flight_nr int default 0;
    declare free_seats int;

	/*
	select f.flight_number into flight_nr from Flight f
    where f.week_number = input_week and f.week_id =
    (select ws.week_id from Weekly_schedule ws where ws.departure_time = dep_time and ws.day = input_day and ws.route =
    (select r.route_id from Route r where r.year_id = input_year and r.arrival = arrival_airport_code and r.departure = departure_airport_code));
	*/

    select f.flight_number into flight_nr from Flight f
	join Weekly_schedule ws on f.week_id = ws.week_id
	join Route r on ws.route = r.route_id
	where f.week_number = input_week and ws.departure_time = dep_time and ws.day = input_day
	  and r.year_id = input_year and r.arrival = arrival_airport_code and r.departure = departure_airport_code;
    
    if flight_nr = 0 then
		select "There exist no flight for the given route, date and time" as "Message";
    else
        select calculateFreeSeats(flight_nr) into free_seats;
        if free_seats < number_of_passengers then
            select "There are not enough seats available on the chosen flight" as "Message";
            set output_reservation_nr = null;
        else
            insert into Reservation (Reservation.flight)
            values (flight_nr);
            select last_insert_id() into output_reservation_nr ;
            end if;
    end if;
end;
//


create procedure addPassenger (in reservation_nr int, in passport_nr int, in passenger_name varchar(30))
begin
	if exists (select 1 from Booking where reservation_number = reservation_nr) then
		select "The booking has already been payed and no futher passengers can be added" as "Message";
	else
		if not exists (select 1 from Passenger where passport_number = passport_nr) then
			insert into Passenger (Passenger.passport_number, Passenger.passenger_name)
			values(passport_nr, passenger_name);
		end if;
		if not exists (select 1 from Reservation where reservation_number = reservation_nr) then
			select "The given reservation number does not exist" as "Message";
		else
			insert into Reserved_passengers (Reserved_passengers.reservation_number, Reserved_passengers.passport_number) 
			values(reservation_nr, passport_nr);
		end if;
	end if;
end;
//


create procedure addContact (in reservation_nr int, in passport_nr int, in email varchar(30), in phone bigint)
begin
	if not exists (select 1 from Reservation where reservation_number = reservation_nr) then
		select "The given reservation number does not exist" as "Message";
    else
		if not exists (select 1 from Reserved_passengers where passport_number = passport_nr and reservation_number = reservation_nr) then
			select "The person is not a passenger of the reservation" as "Message";
		else
			if not exists (select 1 from Contact where passport_number = passport_nr) then
				insert into Contact (Contact.email, Contact.phone_number, Contact.passport_number)
				values(email, phone, passport_nr);
			end if;
		end if;
	end if;
end;
//


create procedure addPayment (in reservation_nr int, in cardholder_name varchar(30), in credit_card_number bigint)
begin
	declare nr_passengers_reservation int;
    declare free_seats int;
    declare flight_nr int;
    declare price_reservation int;
    
	if not exists (select 1 from Reservation where reservation_number = reservation_nr) then
		select "The given reservation number does not exist" as "Message";
	else
		if not exists (select contact from Reservation where reservation_number = reservation_nr) then
			select "The reservation has no contact yet" as "Message";
		else
			select count(*) into nr_passengers_reservation from Reserved_passengers where reservation_number = reservation_nr;
			select flight into flight_nr from Reservation where reservation_number = reservation_nr;
			set free_seats = calculateFreeSeats(flight_nr);
            
            if (free_seats >= nr_passengers_reservation) then
				set price_reservation = nr_passengers_reservation * calculatePrice(flight_nr);
                
				insert into Payment (Payment.card_holder, Payment.card_number)
				values (cardholder_name, credit_card_number);
                
				insert into Booking (Booking.person_paying, Booking.paid_price, Booking.reservation_number)
                values (max(Payment.payment_id), price_reservation, reservation_nr); 
        
				insert into Has_ticket (Has_ticket.booking, Has_ticket.passenger)
				select reservation_number, passport_number from Reserved_passengers where reservation_number = reservation_nr;
			else
				delete from Reservation where reservation_number = reservation_nr;
				select "There are not enough seats available on the flight anymore, deleting reservation" as "Message";
            end if;
		end if;
	end if;
end;
//

DELIMITER ;

/* ------ Create view ------ */
create view allFlights as
	select departure_airport.airport_name as "departure_city_name", arrival_airport.airport_name as "destination_city_name",
	departure_time as "departure_time", day as "departure_day", week_number as "departure_week", year as "departure_year",
	calculateFreeSeats(Flight.flight_number) as "nr_of_free_seats", calculatePrice(Flight.flight_number) as "current_price_per_seat"
    from Airport as departure_airport, Airport as arrival_airport, Weekly_schedule, Flight, Day
    where departure_airport.airport_code = (select departure from Route where route_id = Weekly_schedule.route)
    and arrival_airport.airport_code = (select arrival from Route where route_id = Weekly_schedule.route)
    and Weekly_schedule.week_id = Flight.week_id
    and Weekly_schedule.day = Day.day_id;



/* ------ Question 8 ------ */
/* a) How can you protect the credit card information in the database from hackers?

Answer: There are multiple ways you can protect that information, first of you could limit the access by assigning special access privileges.
You could also encrypt the information or use hashing on sensitive and vulnerable credit card data.
*/


/* b) Give three advantages of using stored procedures in the database (and thereby
execute them on the server) instead of writing the same functions in the
frontend of the system (in for example JavaScript on a Web page)?

Answer: 
1. The procedure calls are quick and efficient since they are only stored and compiled once.
The executable code is also automatically cached, therefore it will lower the memory requirements.

2. Updating a stored procedure in the database automatically will apply changes to all applications using it.
Which will lead to avoiding the need to redeploy front-end code.

3. One statement can trigger several statements inside the procedure which results in more efficient queries.
*/





/* ------ Question 9 ------ */
/*
a) In session A, add a new reservation.
b) Is this reservation visible in session B? Why? Why not?

Answer:
Since we started a transaction, changes are not visible in the second terminal window that is session B, because each session is locked.
We need to first commit the transaction to make the changes visible and update the database.
*/

/*
c) What happens if you try to modify the reservation from A in B? Explain what
happens and why this happens and how this relates to the concept of isolation
of transactions.

Answer:
We can't perform actions in window B due to the active transaction in window A,
since session B is waiting for session A to commit.
We tried to delete the reservation from session B, but nothing happened for a while and then
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction, occured.
We then performed commit from session A, and session B could thereafter modify the reservation by deleting the last one added.
*/


/* ------ Question 10 ------ */














