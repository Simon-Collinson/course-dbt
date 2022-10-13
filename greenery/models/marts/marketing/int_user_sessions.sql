with sessions as (
    select *
    from {{ ref('int_sessions') }}
)

select user_guid
        , min(session_start) first_session
        , max(session_start) last_session
        , count(*) sessions
        , listagg(products_viewed, ', ') products_viewed --note: products are deduped within session but not here!
        , sum(session_duration) total_session_duration
        , sum(page_views) page_views
        , sum(adds_to_cart) adds_to_cart
        , sum(checkouts) checkouts
        , sum(packages_shipped) packages_shipped

from sessions
group by user_guid