select * from customer limit 30
--Q1 what is the total revenue generate by male vs female customer?
select gender ,sum(purchase_amount) as revenue
from customer 
group by gender 
--Q2 which customer used a discount but still spent more than the average purches amount?
select customer_id, purchase_amount
from customer
where discount_applied='yes' and purchase_amount >= (select AVG(purchase_amount) from customer)
--Q3which are the top 5 product with avrage rating 
select item_purchased,ROUND(avg (review_rating::numeric),2)as "Avrage Product Rating" 
from customer 
group by item_purchased
order by avg(review_rating)desc
limit 5;

--Q4 compare the average purchase amount between standard and express shipping 
select shipping_type,
avg(purchase_amount)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

--Q5 Do Subscribe customners spend money  more ? compare average apend and total revenue 
--between subscribers and non - subscribers
select subscription_status,
count(customer_id)as total_customers,
Round(avg(purchase_amount),2)as avg_spend,
Round(sum(purchase_amount),2)as total_revenue
from customer
group by subscription_status

--Q6 which 5 product have the highest percentage of purchases with descounts aplied
select item_purchased,
ROUND(100 *sum(case when discount_applied= 'yes' then 1 else 0 End)/count(*) *100,2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

--Q7 segment customers into new, returning and loyal based on there total numbers of previous purchased and show the count of each segment
with customer_type as (
select customer_id, previous_purchases,
case
	when previous_purchases= 1 then 'new'
	when previous_purchases between 2 and 10 then ' returning'
	else 'loyal'
	end as customer_segment
from customer
)
select customer_segment, count(*) as "number of Customer"
from customer_type
group by customer_segment

--Q8 what are the top 3 most purchases product within each category
with item_counts as (
select category, 
item_purchased,
count(customer_id)as total_orders,
row_number() over (partition by category order by count (customer_id)desc)as item_rank
from customer
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3;

--Q9 are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe
select subscription_status,
count(customer_id)as repeat_buyres
from customer
where previous_purchases>5
group by subscription_status

--Q10 what is the revenue contributions of each age grouped 
select age_group,
sum (purchase_amount)as total_revenue
from customer
group by age_group
order by total_revenue desc;
	





























