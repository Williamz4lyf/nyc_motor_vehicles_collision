select count(*)
from Vehicles v
join Crashes c
on v.COLLISION_ID = c.COLLISION_ID
join Person p
on p.COLLISION_ID = v.COLLISION_ID;

select distinct BOROUGH
from Crashes;

select count(*)
from Vehicles v
         join Crashes c
              on v.COLLISION_ID = c.COLLISION_ID
         join Person p
              on p.COLLISION_ID = v.COLLISION_ID
where c.BOROUGH = 'BROOKLYN'
and YEAR(str_to_date(v.CRASH_DATE, '%m/%d/%Y')) >= 2018;

select `CRASH DATE` from Crashes;

with df as
    (
    select v.UNIQUE_ID, v.COLLISION_ID, v.CRASH_DATE,
           v.CRASH_TIME, v.VEHICLE_TYPE, v.VEHICLE_MAKE,
           v.VEHICLE_YEAR, v.TRAVEL_DIRECTION, v.VEHICLE_OCCUPANTS,
           
    from Vehicles v
        join Crashes c
            on v.COLLISION_ID = c.COLLISION_ID
        join Person p
            on p.COLLISION_ID = v.COLLISION_ID
    where c.BOROUGH = 'BROOKLYN'
      and YEAR(str_to_date(v.CRASH_DATE, '%m/%d/%Y')) >= 2018
    )
select *
from df;

# 1. Which Borough has the most accidents.
select c.BOROUGH, COUNT(*) as total_accidents
from Vehicles v
         join Crashes c
              on v.COLLISION_ID = c.COLLISION_ID
         join Person p
              on p.COLLISION_ID = v.COLLISION_ID
GROUP BY c.BOROUGH
order by total_accidents desc;

select BOROUGH
from (
    select c.BOROUGH, COUNT(*) as acc_count
        from Vehicles v
            join Crashes c
                on v.COLLISION_ID = c.COLLISION_ID
            join Person p
                on p.COLLISION_ID = v.COLLISION_ID
        WHERE c.BOROUGH is not null
        GROUP BY c.BOROUGH
        ) as accident_counts
where acc_count = (select max(acc_count)
                   from (select c.BOROUGH, COUNT(*) as acc_count
                         from Vehicles v
                                  join Crashes c
                                       on v.COLLISION_ID = c.COLLISION_ID
                                  join Person p
                                       on p.COLLISION_ID = v.COLLISION_ID
                         WHERE c.BOROUGH is not null
                         GROUP BY c.BOROUGH) as Bac);

select BOROUGH
from (
         select c.BOROUGH, COUNT(*) as acc_count
         from Vehicles v
                  join Crashes c
                       on v.COLLISION_ID = c.COLLISION_ID
                  join Person p
                       on p.COLLISION_ID = v.COLLISION_ID
         WHERE c.BOROUGH is not null
           AND YEAR(str_to_date(v.CRASH_DATE, '%m/%d/%Y')) >= 2018
         GROUP BY c.BOROUGH
     ) as accident_counts
where acc_count = (select max(acc_count)
                   from (select c.BOROUGH, COUNT(*) as acc_count
                         from Vehicles v
                                  join Crashes c
                                       on v.COLLISION_ID = c.COLLISION_ID
                                  join Person p
                                       on p.COLLISION_ID = v.COLLISION_ID
                         WHERE c.BOROUGH is not null
                           AND YEAR(str_to_date(v.CRASH_DATE, '%m/%d/%Y')) >= 2018
                         GROUP BY c.BOROUGH) as Bac);

select c.BOROUGH, COUNT(*) as acc_count
from Vehicles v
         join Crashes c
              on v.COLLISION_ID = c.COLLISION_ID
         join Person p
              on p.COLLISION_ID = v.COLLISION_ID
WHERE c.BOROUGH is not null
  AND YEAR(str_to_date(v.CRASH_DATE, '%m/%d/%Y')) >= 2018
GROUP BY c.BOROUGH;

select v.COLLISION_ID, v.CRASH_DATE, v.CRASH_TIME,
       c.BOROUGH, c.`ZIP CODE`, c.LATITUDE, c.LONGITUDE,
       p.PERSON_TYPE, p.PERSON_SEX, p.PERSON_INJURY,
       p.PERSON_AGE, v.VEHICLE_ID, v.STATE_REGISTRATION,
       v.VEHICLE_TYPE, c.`VEHICLE TYPE CODE 2`, v.VEHICLE_MAKE, v.VEHICLE_MODEL,
       v.VEHICLE_YEAR, v.TRAVEL_DIRECTION,
       v.VEHICLE_OCCUPANTS, v.DRIVER_SEX,
       v.DRIVER_LICENSE_STATUS, v.DRIVER_LICENSE_JURISDICTION,
       v.PRE_CRASH, v.POINT_OF_IMPACT, v.VEHICLE_DAMAGE,
       v.VEHICLE_DAMAGE_1, v.VEHICLE_DAMAGE_2, v.VEHICLE_DAMAGE_3,
       v.PUBLIC_PROPERTY_DAMAGE, v.PUBLIC_PROPERTY_DAMAGE_TYPE,
       v.CONTRIBUTING_FACTOR_1, v.CONTRIBUTING_FACTOR_2,
       c.`CONTRIBUTING FACTOR VEHICLE 1`,
       c.`CONTRIBUTING FACTOR VEHICLE 2`,
       c.`ON STREET NAME`, c.`OFF STREET NAME`,
       c.`CROSS STREET NAME`,
       c.`NUMBER OF PERSONS INJURED`, c.`NUMBER OF PERSONS KILLED`,
       c.`NUMBER OF PEDESTRIANS INJURED`, c.`NUMBER OF PERSONS KILLED`,
       c.`NUMBER OF CYCLIST INJURED`, c.`NUMBER OF CYCLIST KILLED`,
       c.`NUMBER OF MOTORIST INJURED`, c.`NUMBER OF MOTORIST KILLED`,
       p.EJECTION, p.EMOTIONAL_STATUS, p.BODILY_INJURY,
       p.POSITION_IN_VEHICLE, p.SAFETY_EQUIPMENT,
       p.COMPLAINT, p.PED_ROLE

from Vehicles v
         join Crashes c
              on v.COLLISION_ID = c.COLLISION_ID
         join Person p
              on p.COLLISION_ID = v.COLLISION_ID
where c.BOROUGH = (
    select BOROUGH
    from (
             select c.BOROUGH, COUNT(*) as acc_count
             from Vehicles v
                      join Crashes c
                           on v.COLLISION_ID = c.COLLISION_ID
                      join Person p
                           on p.COLLISION_ID = v.COLLISION_ID
             WHERE c.BOROUGH is not null
               AND YEAR(str_to_date(v.CRASH_DATE, '%m/%d/%Y')) >= 2018
             GROUP BY c.BOROUGH
         ) as accident_counts
    where acc_count = (select max(acc_count)
                       from (select c.BOROUGH, COUNT(*) as acc_count
                             from Vehicles v
                                      join Crashes c
                                           on v.COLLISION_ID = c.COLLISION_ID
                                      join Person p
                                           on p.COLLISION_ID = v.COLLISION_ID
                             WHERE c.BOROUGH is not null
                               AND YEAR(str_to_date(v.CRASH_DATE, '%m/%d/%Y')) >= 2018
                             GROUP BY c.BOROUGH) as Bac)
)
  and YEAR(str_to_date(v.CRASH_DATE, '%m/%d/%Y')) >= 2018

;

use nyc_motor_vehicle_collisions;

with nyc_collisions as
    (
    select v.COLLISION_ID, c.BOROUGH,
           concat(str_to_date(v.CRASH_DATE, '%m/%d/%Y'), ' ', v.CRASH_TIME) as CRASH_DATETIME,
            c.`ZIP CODE`, c.LATITUDE, c.LONGITUDE,
            p.PERSON_TYPE, p.PERSON_SEX, p.PERSON_INJURY,
            p.PERSON_AGE, v.STATE_REGISTRATION,
            CASE
                WHEN v.VEHICLE_TYPE IS NULL AND c.`VEHICLE TYPE CODE 2` IS NOT NULL
                    THEN c.`VEHICLE TYPE CODE 2`
                ELSE v.VEHICLE_TYPE
                END AS VEHICLE_TYPE,
            v.VEHICLE_YEAR, v.TRAVEL_DIRECTION,
            v.VEHICLE_OCCUPANTS, v.DRIVER_SEX,
            v.DRIVER_LICENSE_STATUS, v.DRIVER_LICENSE_JURISDICTION,
            v.PRE_CRASH, v.POINT_OF_IMPACT, v.VEHICLE_DAMAGE,
            v.VEHICLE_DAMAGE_1, v.VEHICLE_DAMAGE_2,
            v.VEHICLE_DAMAGE_3, v.PUBLIC_PROPERTY_DAMAGE,
            v.CONTRIBUTING_FACTOR_1, v.CONTRIBUTING_FACTOR_2,
            c.`ON STREET NAME`, c.`CROSS STREET NAME`,
            CASE
                WHEN c.`NUMBER OF PERSONS INJURED` IS NULL
                    THEN 0
                ELSE c.`NUMBER OF PERSONS INJURED`
                END AS NUMBER_OF_PERSONS_INJURED,
            CASE
                WHEN c.`NUMBER OF PERSONS KILLED` IS NULL
                    THEN 0
                ELSE c.`NUMBER OF PERSONS KILLED`
                END AS NUMBER_OF_PERSONS_KILLED,
            c.`NUMBER OF PEDESTRIANS INJURED`,
            c.`NUMBER OF PEDESTRIANS KILLED`,
            c.`NUMBER OF CYCLIST INJURED`,
            c.`NUMBER OF CYCLIST KILLED`,
            c.`NUMBER OF MOTORIST INJURED`,
            c.`NUMBER OF MOTORIST KILLED`,
            p.EJECTION, p.EMOTIONAL_STATUS,
            p.BODILY_INJURY, p.POSITION_IN_VEHICLE
    from Vehicles v
        join Crashes c
            on v.COLLISION_ID = c.COLLISION_ID
        join Person p
            on p.COLLISION_ID = v.COLLISION_ID
    )
# select count(*) from nyc_collisions
#                 where BOROUGH is not null
#                   and LONGITUDE is not null
#                   and `ON STREET NAME` is not null
#                   and PERSON_AGE is not null
#                   and PERSON_AGE between 13 and 100
#                   and CRASH_DATETIME is not null
#                   and `ZIP CODE` is not null
#                   and VEHICLE_TYPE is not null

select * from nyc_collisions
         where BOROUGH is not null
           and LONGITUDE is not null
           and `ON STREET NAME` is not null
           and PERSON_AGE is not null
           and PERSON_AGE between 13 and 100
           and CRASH_DATETIME is not null
           and `ZIP CODE` is not null
           and VEHICLE_TYPE is not null
;







# 2. Which time has the most accidents

select count(*)
from Vehicles v
         join Crashes c
              on v.COLLISION_ID = c.COLLISION_ID
         join Person p
              on p.COLLISION_ID = v.COLLISION_ID
where c.BOROUGH is not null
    and c.`ON STREET NAME` is not null
    and c.LONGITUDE is not null
    and p.PERSON_AGE is not null or p.PERSON_AGE != 0
;

