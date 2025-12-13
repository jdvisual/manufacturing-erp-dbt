 {{ config(alias='STG_SALES_ORDERS', materialized='view') }}

with source as (

    select * from {{ source('raw_erp', 'SALES_ORDERS') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(["source_system", "order_id"]) }} as sales_order_key,

        upper(trim(order_id)) as sales_order_id,
        upper(trim(customer_id)) as customer_id,

        order_date,
        order_status,

        /* RAW does not have CREATED_AT / UPDATED_AT right now */
        cast(null as timestamp_ntz) as created_at,
        cast(null as timestamp_ntz) as updated_at,

        source_system
    from source
    where order_id is not null

)

select * from renamed
