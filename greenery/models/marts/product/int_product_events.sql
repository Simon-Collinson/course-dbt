with product_events as (
    select *
    from {{ ref('postgres_events') }}
    where product_guid is not null
)

select  product_guid
        , sum(case when event_type = 'page_view' then 1 else 0 end) as page_views
        , sum(case when event_type = 'add_to_cart' then 1 else 0 end) as adds_to_cart

from product_events
group by product_guid