with events_unpacked as (
    select *
    from {{ ref('int_events_unpacked') }}
)

select  product_guid_coalesce as product_guid
        , count(distinct session_guid) as sessions
        , sum(case when event_type = 'page_view' then 1 else 0 end) as page_views
        , sum(case when event_type = 'add_to_cart' then 1 else 0 end) as adds_to_cart
        , sum(case when event_type = 'checkout' then 1 else 0 end) as checkouts
        , sum(case when event_type = 'package_shipped' then 1 else 0 end) as packages_shipped

from events_unpacked
group by product_guid_coalesce