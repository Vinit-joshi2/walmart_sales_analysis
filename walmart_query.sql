select * from walmart_clean_data
drop table walmart_clean_data

--Q1 Find different payment method and number of transactions, number of qty sold

select payment_method , count(*)  as no_payments, sum(quantity) as no_qty_sold from walmart_clean_data
group by 1 

/* Q2 Identify the highest-rated category in each branch, displaying the branch, category
 AVG RATING
 */

select * from 
(
select branch , 
category , 
avg(rating)  ,
rank() over(partition by branch order by avg(rating) desc) as rn
from walmart_clean_data
group by 1 , 2
order by 1,3 DESC
)
where rn = 1


-- Q.3 Identify the busiest day for each branch based on the number of transactions

select * from (
select branch ,
TO_CHAR(TO_DATE(date , 'DD/MM/YY') , 'day') as date_for , 
count(*) as no_transaction,
rank() over(partition by branch order by count(*) desc) as rn
from walmart_clean_data
group by 1,2
order by 1,3 desc
)
where rn = 1


-- Q. 4 
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.


select payment_method , sum(quantity) as quantity_sold from walmart_clean_data
group by 1


-- Q.5
-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.


select city ,
category,
avg(rating) as avg_rating,
min(rating) as min_rating,
max(rating) as max_rating
from walmart_clean_data
group by 1 , 2


-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.


select category , sum(total * profit_margin) as total_profit
from walmart_clean_data
group by 1
order by 1 , 2 desc



-- Q.7
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

with cte as 
(
select branch ,
payment_method, 
count(*) as total_transaction , 
rank() over(partition by branch order by count(*) desc) as rn
from walmart_clean_data
group by 1,2
)
select * from cte
where rn = 1


-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

select  
	branch , 
case 
		when extract(hour from (time::time)) < 12 then 'Morning'
		when extract(hour from(time::time)) between 12 and 17 then 'Afternoon'
		else 'Evening'
		end as day_time , 
		count(*)
from walmart_clean_data
group by 1 , 2
order by 1,3 desc


-- #9 Identify 5 branch with highest decrese ratio in 
-- revevenue compare to last year(current year 2023 and last year 2022)

-- rdr == last_rev-cr_rev/ls_rev*100



SELECT *,
EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) as formated_date
FROM walmart

-- 2022 sales
with  revenue_2022
AS
(
	SELECT 
		branch,
		SUM(total) as revenue
	FROM walmart_clean_data
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022 -- psql
	-- WHERE YEAR(TO_DATE(date, 'DD/MM/YY')) = 2022 -- mysql
	GROUP BY 1
),

revenue_2023
AS
(

	SELECT 
		branch,
		SUM(total) as revenue
	FROM walmart_clean_data
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
	GROUP BY 1
)

SELECT 
	ls.branch,
	ls.revenue as last_year_revenue,
	cs.revenue as cr_year_revenue,
	ROUND(
		(ls.revenue - cs.revenue)::numeric/
		ls.revenue::numeric * 100, 
		2) as rev_dec_ratio
FROM revenue_2022 as ls
JOIN
revenue_2023 as cs
ON ls.branch = cs.branch
WHERE 
	ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5




