{{ config(
    materialized = 'view'
) }}

with source_data as (

    select
        order_id,
        order_line_id,
        product_id,
        quantity,
        unit_price,
        quantity * unit_price as line_amount
    from {{ source('raw_erp', 'SALES_ORDER_LINES') }}

)

select *
from source_data
