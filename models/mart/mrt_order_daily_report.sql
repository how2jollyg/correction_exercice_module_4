{{
  config(
    alias = "order_daily_report"
  )
}}
---aliased the model in the configuration file for better readability in the schema

select
--removed 1 as column1 because it was a mistake
    oi.order_date,
    ac.account_manager,
    oi.customer_state as state,
    oi.average_feedback_score,
 --added coalesce to avoid null values for every calculated column. Just in case
    coalesce(round(avg(total_items),2),0) as average_items_per_order,
    coalesce(round(avg(total_order_amount),2),0) as average_amount_per_order,
    coalesce(count(distinct order_id),0) as total_orders
from {{ref('int_sales_database__order')}} oi
left join {{ref("stg_account_manager_region_mapping")}} ac
on oi.customer_state = ac.state
group by oi.order_date, ac.account_manager, oi.customer_state, oi.average_feedback_score
order by ac.account_manager, oi.order_date