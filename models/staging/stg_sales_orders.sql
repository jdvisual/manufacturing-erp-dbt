{{ config(
    alias='STG_SALES_ORDER',
    materialized='view'
) }}

with source as (
    select * from source('raw_erp', 'SALES_ORDERS')

),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['source_system', 'sales_order_id']) }} as sales_order_key,
        sales_order_id,
        customer_id,
        order_status,
        order_type,
        order_date ,
        requested_ship_date ,
        created_at,
        updated_at,
        source_system
    from source
    where sales_order_id is not null
)

select * from renamed
