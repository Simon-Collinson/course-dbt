with events_unpacked as (
    select *
    from {{ ref('int_events_unpacked') }}
)

select  product_guid_coalesce as product_guid
        , count(distinct session_guid) as sessions
        , {{ agg_event_type('page_view') }} as page_views
        , {{ agg_event_type('add_to_cart')}} as adds_to_cart
        , {{ agg_event_type('checkout') }} as checkouts
        , {{ agg_event_type('package_shipped') }} as packages_shipped

from events_unpacked
group by product_guid_coalesce