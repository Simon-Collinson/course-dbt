# Answers to Week 4 Project Questions

## Part 1: dbt Snapshots

_Which orders changed from week 3 to week 4?_

`38c516e8-b23a-493a-8a5c-bf7b2b9ea995`, `aafb9fbd-56e1-4dcc-b6b2-a3fd91381bb6`, and `d1020671-7cdf-493c-b008-c48535415611` changed status from 'preparing' to 'shipped'.

```sql
with changed as (
    select 
    order_id
    , count(*) distinct_states
    , max(dbt_valid_from) max_dbt_valid_from
    
    from snapshot_orders

    group by order_id
)

select *

from changed c
left join snapshot_orders o
    on c.order_id = o.order_id

where c.distinct_states > 1
and c.max_dbt_valid_from > '2022-10-25'

order by c.order_id, dbt_valid_from desc;
```

## Part 2: Modeling challenge

_How are our users moving through the product funnel?_

_Which steps in the funnel have largest drop off points?_

_Please create any additional dbt models needed to help answer these questions from our product team, and put your answers in a README in your repo._

I created an additional model called `fct_daily_funnel` which contains a daily summary of funnel events. (I also created a `date_spine` utility model to provide a date spine for this and other tables).

Looking at `fct_daily_funnel`, I see the following:

|TOP_FUNNEL_PERC	| MID_FUNNEL_PERC |	BOTTOM_FUNNEL_PERC|
|-------------------|-----------------|-------------------|
| 1                	| 0.807958	      | 0.624567          |

```sql
select 
1 as top_funnel_perc
, sum(mid_funnel) / sum(top_funnel) as mid_funnel_perc
, sum(bottom_funnel) / sum(top_funnel) as bottom_funnel_perc

from fct_daily_funnel
```

This suggests that the drop-off from top-funnel (pageview) to mid-funnel (add to cart) is the largest, at around 20% drop-off. However, another way of looking at this is to look at the percentage not based on the original 100%, but instead based on the previous stage in the funnel. This yields the following result:

|TOP_FUNNEL_PERC	| MID_FUNNEL_PERC |	BOTTOM_FUNNEL_PERC|
|-------------------|-----------------|-------------------|
| 1                	| 0.807958	      | 0.773019          |

```sql
select 
1 as top_funnel_perc
, sum(mid_funnel) / sum(top_funnel) as mid_funnel_perc
, sum(bottom_funnel) / sum(mid_funnel) as bottom_funnel_perc --note different denominator here

from fct_daily_funnel
```
This shows that a larger percentage of people drop out between mid-funnel (add to cart) and bottom-funnel (purchase). 

_Use an exposure on your product analytics model to represent that this is being used in downstream BI tools. Please reference the course content if you have questions._

## Part 3: Reflection questions

### 3A. dbt next steps for you 

_If your organization is thinking about using dbt, how would you pitch the value of dbt/analytics engineering to a decision maker at your organization?_

_If your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?_

We're not using dbt yet.

_If you are thinking about moving to analytics engineering, what skills have you picked that give you the most confidence in pursuing this next step?_

This course has given me confidence that my existing SQL skills and a bit of data modelling are enough to build solid pipelines which previously were out of my reach. In particular, being able to easily visualise DAGs based exclusively on their code is a huge plus.

### 3B. Setting up for production / scheduled dbt run of your project

_And finally, before you fly free into the dbt night, we will take a step back and reflect: after learning about the various options for dbt deployment and seeing your final dbt project, how would you go about setting up a production/scheduled dbt run of your project in an ideal state? You don’t have to actually set anything up - just jot down what you would do and why and post in a README file._

_Hints: what steps would you have? Which orchestration tool(s) would you be interested in using? What schedule would you run your project on? Which metadata would you be interested in using? How/why would you use the specific metadata? , etc._

