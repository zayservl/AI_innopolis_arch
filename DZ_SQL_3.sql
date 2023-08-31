--1
select * from tickets t 
inner join bookings b on t.book_ref = b.book_ref 
limit 100

select f.arrival_airport, f.departure_airport  from flights f
union select r.arrival_airport, r.departure_airport from routes r  
limit 100

--2
select * from flights f 
where f.actual_departure  = f.scheduled_departure 
order by f.scheduled_departure  desc  
limit 100

--3
select s.fare_conditions, count(*) from flights f 
inner join aircrafts a on f.aircraft_code = a.aircraft_code 
inner join seats s on a.aircraft_code = s.aircraft_code 
where f.actual_departure is not null
group by s.fare_conditions 
order by 2
limit 100

select bp.seat_no , count(*) as "Количество" from boarding_passes bp 
group by bp.seat_no 
order by "Количество"
limit 100

select f.flight_no, count(*) from ticket_flights tf 
inner join flights f on tf.flight_id = f.flight_id 
where tf.fare_conditions = 'Business'
group by f.flight_no
order by 2 desc 
limit 100

--4
select tf.amount, b.total_amount, t.passenger_name from bookings b 
inner join tickets t on b.book_ref = t.book_ref 
inner join ticket_flights tf on t.ticket_no = tf.ticket_no 
where tf.amount = b.total_amount
order by 1
limit 100

--5
create or replace VIEW temp_table AS
select * from flights f 
where f.actual_departure  = f.scheduled_departure 
order by f.scheduled_departure  desc  
limit 100 
