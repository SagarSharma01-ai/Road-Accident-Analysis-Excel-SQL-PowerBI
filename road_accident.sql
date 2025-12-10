use road_accident_db;
select count(*) from road_accidents;
SELECT * FROM road_accidents;
desc road_accidents;


# change accident_date  datatype from string to date 

SELECT accident_date FROM road_accidents LIMIT 30;


SET SQL_SAFE_UPDATES = 0; # remove safe mode

update road_accidents
set accident_date = str_to_date(accident_date,'%d-%m-%y'); 

alter table road_accidents
modify column accident_date date;

# Current Year Casualties
SELECT * FROM road_accidents;

Select sum(number_of_casualties) as CY_Casualties
from road_accidents
where year(accident_date) = 2022;

# CY Accidents
select distinct(count(accident_index)) as CY_Accidents 
from road_accidents
where year(accident_date) = 2022;

# CY Fatal Casualties
Select sum(number_of_casualties) as CY_Casualties
from road_accidents
where year(accident_date) = 2022 and accident_severity = 'Fatal';

# CY Serious Casualties

Select sum(number_of_casualties) as CY_Casualties
from road_accidents
where year(accident_date) = 2022 and accident_severity = 'Serious';

#CY Slight Casualties

Select sum(number_of_casualties) as CY_Casualties
from road_accidents
where year(accident_date) = 2022 and accident_severity = 'Slight';

# Percentage of Total
Select cast(sum(number_of_casualties)*100/ (select sum(number_of_casualties) from road_accidents) 
as decimal(10,2)) as PCT 
from road_accidents
where accident_severity = 'Slight';

# Percentage of Total of Serious Accients
Select cast(sum(number_of_casualties)*100/ (select sum(number_of_casualties) from road_accidents) 
as decimal(10,2)) as PCT 
from road_accidents
where accident_severity = 'Serious';

# Percentage of Total of Fatal Accidents

Select cast(sum(number_of_casualties)*100/ (select sum(number_of_casualties) from road_accidents) 
as decimal(10,2)) as PCT 
from road_accidents
where accident_severity = 'Fatal';

# Casualties by Vehicel Type
SELECT * FROM road_accidents;
select case
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
        WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
         WHEN vehicle_type IN ('Motorcycle over 500cc','Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc','Pedal cycle') THEN 'Bike'
        WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') then 'Bus'
        WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
	END AS vehicle_group,
    sum(number_of_casualties) as CY_Casualties
From road_accidents
-- where Year (accident_date)  = '2022'
Group By case
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
        WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
        WHEN vehicle_type IN ('Motorcycle over 500cc','Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc','Pedal cycle') THEN 'Bike'
        WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') then 'Bus'
        WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
End;


# CY Casualties by Month

select monthname(accident_date) as Month_Name, sum(number_of_casualties) as CY_Casualties
From road_accidents
where year(accident_date) = 2022
group by monthname(accident_date);

# Casualties by Road_type
select road_type,  sum(number_of_casualties) as CY_Casualties
from road_accidents
WHERE YEAR(Accident_date) = 2022
group by road_type;

# Percentage Casualties by urban_or_rural_area
select urban_or_rural_area, sum(number_of_casualties) as Total_Casualties, cast(sum(number_of_casualties)*100 /
(select sum(number_of_casualties) from road_accidents WHERE YEAR(Accident_date) = 2022) as decimal(10,2)) as PCT_CY_Casualties
from road_accidents
WHERE YEAR(Accident_date) = 2022
group by urban_or_rural_area;


# # Percentage Casualties by Light_Condition
select case
			when light_conditions in ('Daylight') then 'Day'
            when light_conditions in ('Darkness - lights lit','Darkness - lighting unknown'
            ,'Darkness - lights unlit','Darkness - no lighting') then 'Night'
		end as Light_Condition,sum(number_of_casualties) as Total_Casualties, cast(sum(number_of_casualties)*100 /
(select sum(number_of_casualties) from road_accidents WHERE YEAR(Accident_date) = 2022) as decimal(10,2)) as PCT_CY_Casualties
from road_accidents
WHERE YEAR(Accident_date) = 2022
group by case
			when light_conditions in ('Daylight') then 'Day'
            when light_conditions in ('Darkness - lights lit','Darkness - lighting unknown'
            ,'Darkness - lights unlit','Darkness - no lighting') then 'Night'
		end;

# Top 10 Casualties by No. of Locations

select local_authority, sum(number_of_casualties) as Total_Casualties from road_accidents
group by local_authority
order by Total_Casualties DESC
limit 10;
