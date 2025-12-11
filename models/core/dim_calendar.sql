{{ config(
    alias='DIM_CALENDAR',
    materialized='table'
) }}

with dates as (
    select
        dateadd(day, seq4(), '2020-01-01'::date) as date_day
    from table(generator(rowcount => 365 * 10))
),

final as (
    select
        to_char(date_day, 'YYYYMMDD')::number    as date_key,
        date_day                                 as date,
        extract(year  from date_day)             as year,
        extract(month from date_day)             as month,
        extract(day   from date_day)             as day,
        to_char(date_day, 'YYYY-MM')             as year_month,
        dayname(date_day)                        as day_name,
        weekofyear(date_day)                     as week_of_year,
        case
          when dayofweek(date_day) in (1,7) then 'WEEKEND'
          else 'WEEKDAY'
        end as weekday_weekend_flag
    from dates
)

select * from final
