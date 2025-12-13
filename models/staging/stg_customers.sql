 {{ config(alias='STG_CUSTOMERS', materialized='view') }}

with source as (

    select * from {{ source('raw_erp', 'CUSTOMERS_ERP') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(["source_system", "customer_id"]) }} as customer_key,

        upper(trim(customer_id)) as customer_id,

        /* if customer_name doesn't exist either, change to NULL like below */
        initcap(trim(customer_name)) as customer_name,

        /* columns missing in RAW right now -> placeholders */
        cast(null as varchar) as customer_segment,
        cast(null as varchar) as email,
        cast(null as varchar) as phone,
        cast(null as varchar) as address,
        cast(null as varchar) as city,
        cast(null as varchar) as state,
        cast(null as varchar) as zip,

        source_system
    from source
    where customer_id is not null

)

select * from renamed
