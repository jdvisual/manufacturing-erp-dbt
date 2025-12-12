 {{ config(
    materialized = 'view'
) }}

with stg as (

    select *
    from {{ ref('stg_sales_order_lines') }}

),

validated as (

    select
        order_id,
        order_line_id,
        product_id,
        quantity,
        unit_price,
        line_amount,

        case
            when quantity <= 0 then 'INVALID_QUANTITY'
            when unit_price < 0 then 'INVALID_UNIT_PRICE'
            else 'VALID'
        end as quality_flag

    from stg
)

select *
from validated
where quality_flag = 'VALID'
