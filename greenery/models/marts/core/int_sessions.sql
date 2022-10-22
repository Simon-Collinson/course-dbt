with postgres_events as (
    select *
    from {{ ref('postgres_events') }}
)

select session_guid
    , user_guid
    , min(created_at) session_start
    , max(case when event_type != 'package_shipped' then created_at else NULL end) session_end --package shipping is recorded as an event, leading to unusually long sessions - we exclude it for that reason
    , timediff(second, min(created_at), max(case when event_type != 'package_shipped' then created_at else NULL end)) session_duration
    , listagg(distinct product_guid, ', ') products_viewed
    , count(*) as total_events
    , count(distinct product_guid) as total_products
    , {{ agg_event_type('page_view') }} as page_views
    , {{ agg_event_type('add_to_cart') }} as adds_to_cart
    , {{ agg_event_type('checkout') }} as checkouts
    , {{ agg_event_type('package_shipped') }} as packages_shipped


from postgres_events 
group by session_guid, user_guid