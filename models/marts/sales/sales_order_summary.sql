{{ config(
    alias='SALES_ORDER_SUMMARY',
    materialized='view'
) }}

select
    f.sales_order_id,
    c.customer_name,
    c.customer_segment,
    cal.date                         as order_date,
    sum(f.quantity_ordered)          as total_quantity,
    sum(f.extended_amount)           as total_amount
from {{ ref('fct_sales_order_line') }} f
join {{ ref('dim_customer') }} c
  on f.customer_key = c.customer_key
join {{ ref('dim_calendar') }} cal
  on f.order_date_key = cal.date_key
group by
    f.sales_order_id,
    c.customer_name,
    c.customer_segment,
    cal.date
