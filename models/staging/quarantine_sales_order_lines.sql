{{ config(materialized='table', schema='ERRORS', alias='QUARANTINE_SALES_ORDER_LINES') }}

with src as (
    select * from {{ source('raw_erp', 'SALES_ORDER_LINES') }}
),

bad as (
    select
        *,
        case
            when order_line_id is null then 'order_line_id_null'
            when order_id is null then 'order_id_null'
            when product_id is null then 'product_id_null'
            when quantity is null then 'quantity_null'
            when quantity <= 0 then 'quantity_invalid'
            when unit_price is null then 'unit_price_null'
            when unit_price < 0 then 'unit_price_invalid'
            else null
        end as reject_reason
    from src
)

select *
from bad
where reject_reason is not null
