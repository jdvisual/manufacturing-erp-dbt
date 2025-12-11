{{ config(
    alias='STG_SALES_ORDER_LINE',
    materialized='view'
) }}

with source as (
    select * from {{ source('erp_raw', 'sales_order_lines') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['source_system', 'sales_order_line_id']) }} as sales_order_line_key,
        sales_order_line_id,
        sales_order_id,
        product_id,
        quantity_ordered,
        unit_price,
        created_at,
        updated_at,
        source_system
    from source
    where sales_order_line_id is not null
)

select * from renamed
