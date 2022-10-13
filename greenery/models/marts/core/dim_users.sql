with users as (
    select *
 from {{ ref('postgres_users') }}
)

, addresses as (
    select *
    from {{ ref('postgres_addresses') }}
)

, orders as (
    select
        user_guid
        , count(*) as order_count
        , sum(order_total) as spend_lifetime
        , sum(order_units) as units_lifetime
        , min(created_at) as first_order_utc
        , max(created_at) as latest_order_utc
    from {{ ref('fct_orders') }}
    group by user_guid
)

select    u.user_guid
        , u.first_name
        , u.last_name
        , u.email
        , u.phone_number
        , u.created_at as user_registration_utc
        , u.updated_at as user_updated_utc
        , a.address
        , a.country
        , a.state
        , a.zipcode
        , o.order_count
        , o.spend_lifetime
        , o.units_lifetime
        , o.first_order_utc
        , o.latest_order_utc

from users u
left join addresses a
    on u.address_guid = a.address_guid
left join orders o
    on u.user_guid = o.user_guid