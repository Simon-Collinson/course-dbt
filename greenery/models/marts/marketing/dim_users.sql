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

, user_sessions as (
    select *
    from {{ ref('int_user_sessions') }}
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
        , zeroifnull(o.order_count) order_count
        , zeroifnull(o.spend_lifetime) spend_lifetime
        , zeroifnull(o.units_lifetime) units_lifetime
        , o.first_order_utc
        , o.latest_order_utc
        , us.first_session
        , us.last_session
        , us.sessions
        , us.total_session_duration 
        , us.page_views
        , us.adds_to_cart
        , us.checkouts
        , us.packages_shipped

from users u
left join addresses a
    on u.address_guid = a.address_guid
left join orders o
    on u.user_guid = o.user_guid
left join user_sessions us
    on u.user_guid = us.user_guid