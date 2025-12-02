create database Indrive;
use indrive;

select * from bookings;

alter table bookings drop column MyUnknownColumn;

DESC bookings;          -- MySQL
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bookings';


-- 1. Retrieve all successful bookings:
create view successful_booking as
select * from bookings
where booking_status = "Success";

select * from successful_booking;
--  2. Find the average ride distance for each vehicle type:
create view ride_distance_for_each_vehicle as
select 
Vehicle_Type,
avg(Ride_Distance) as avg_ride_distance
from bookings
GROUP BY Vehicle_Type;

select * from ride_distance_for_each_vehicle;
--  3. Get the total number of cancelled rides by customers:
create view cancelled_rides_by_customers as
SELECT 
count(*) as total_number_of_cancel_rides
FROM bookings
where Booking_Status = 'Canceled by Customer';

select * from cancelled_rides_by_customers;
--  4. List the top 5 customers who booked the highest number of rides:
create view Top_5_customer as
select  
customer_id,
count(booking_id) as total_booking
from bookings
group by customer_id 
order by total_booking desc
limit 5;

select * from Top_5_customer;
--  5. Get the number of rides cancelled by drivers due to personal and car-related issues:
create view cancelled_by_drivers_p_c_issues as
select  
count(Canceled_Rides_by_Driver) as num_cancellaction
from bookings
where Canceled_Rides_by_Driver = "personal & car related issue";

select * from cancelled_by_drivers_p_c_issues;
--  6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
create view max_min_customer_ratings as 
select  
max(Customer_Rating) as Max_customer_rating,
min(customer_rating) as Min_customer_rating
from bookings
where Vehicle_Type = "Prime Sedan";

select * from max_min_customer_ratings;
--  7. Retrieve all rides where payment was made using UPI:
CREATE view UPI_payment as
select *
from bookings
where payment_method = "upi";

select * from upi_payment;
--  8. Find the average customer rating per vehicle type:
CREATE view Avg_customer_rating_vehicle_type as
select
Vehicle_Type,
round(avg(customer_rating),2) as avg_customer_rating
from bookings
GROUP BY vehicle_type;

select * from Avg_customer_rating_vehicle_type;

--  9. Calculate the total booking value of rides completed successfully:
create view Total_booking_value as
select
sum(booking_value) as total_booking_values
from bookings
where Booking_Status = "success";

select * from Total_booking_value;
--  10. List all incomplete rides along with the reason:
create view Incomplete_Rides_Reason as 
select
booking_id,
Incomplete_Rides_Reason
from bookings
where Incomplete_Rides = "YES" ;

select * from Incomplete_Rides_Reason;

-- 11. Calculate average pickup time (V_TAT) for completed rides only.
create view avg_pickup_time as 
SELECT  
avg(V_TAT) as  avg_pickup_time
FROM bookings
where Booking_Status = "success" 
and V_TAT is not null;

select * from avg_pickup_time;
-- 12. Show revenue trend month-wise.
create VIEW month_wise_revenue_trend as
select 
date_format(date,"%Y-%m") as month,
sum(Booking_Value) as Total_revenue
from bookings
where Booking_Status = "Success"
GROUP BY date_format(date,"%Y-%m")
order by Total_revenue desc;

select * from month_wise_revenue_trend ;
-- 13. Find the impact of ride distance on booking value.
create view ride_distance_on_booking_value as
select 
     case
        when Ride_Distance between 0 and 5 then "0-5 km"
		when Ride_Distance between 6 and 15 then "6-15 km"
		when Ride_Distance between 16 and 30 then "16-30 km"
		when Ride_Distance between 31 and 49 then "31-49 km"
        else "50+ km"
	end as Distance_Band,
count(*) as Total_Ride,
avg(booking_value) as Avg_booking_value,
sum(Booking_Value) as Total_revenue
from bookings
where booking_status = "Success"
group by Distance_band
order by total_ride;

SELECT * from ride_distance_on_booking_value;
-- 14. Rank vehicle types by total revenue using RANK().
CREATE view Total_revenue_by_vehicle_types as 
SELECT 
Vehicle_Type,
rank() over(order by sum(Booking_Value)) as rank_vehicle_type,
sum(booking_value) as total_revenue
from bookings
where Booking_Status = "success"
group by  Vehicle_Type;

select * from Total_revenue_by_vehicle_types;
-- 15. Which vehicle type gives maximum profit?
CREATE VIEW vehicle_type_wise_max_profit as
select
Vehicle_Type,
sum(Booking_Value) as maximum_profit
from bookings
where booking_status = "Success"
GROUP BY Vehicle_Type
order by maximum_profit desc
limit 1 ;

select * from vehicle_type_wise_max_profit;






































