{{ config(
    alias='FCT_SALES_ORDER_LINE',
    materialized='incremental',
    unique_key='sales_order_line_key'
) }}

with base as (

    select
        l.sales_order_line_key,
        so.sales_order_key,
        c.customer_key,
        p.product_key,
        cal.date_key                          as order_date_key,

        -- measures
        l.quantity_ordered,
        l.unit_price,
        l.quantity_ordered * l.unit_price     as extended_amount,

        -- attributes
        so.sales_order_id,
        l.sales_order_line_id,
        so.order_status,
        so.order_type,
        so.order_date,
        so.requested_ship_date

    from {{ ref('stg_sales_order_lines') }} l
    join {{ ref('stg_sales_orders') }} so
      on l.sales_order_id = so.sales_order_id
    join {{ ref('dim_customer') }} c
      on so.customer_id = c.customer_id
    join {{ ref('dim_product') }} p
      on l.product_id = p.product_id
    join {{ ref('dim_calendar') }} cal
      on cal.date = cast(so.order_date as date)
)

{% if is_incremental() %}

, incremental_filtered as (
    select *
    from base
    where order_date > (select max(order_date) from {{ this }})
)

select * from incremental_filtered

{% else %}

select * from base

{% endif %}
