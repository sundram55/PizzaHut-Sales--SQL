select * from order_details;select * from orders;select * from pizza_types;select * from pizzas;
            # Basic: #
-- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) total_orders
FROM
    orders;

-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(quantity * price), 2) revenue
FROM
    order_details o
        JOIN
    pizzas p USING (pizza_id);

-- Identify the highest-priced pizza.

SELECT 
    name, price
FROM
    pizza_types pt
        JOIN
    pizzas p USING (pizza_type_id)
ORDER BY price DESC
LIMIT 1;



-- Identify the most common pizza size ordered.

SELECT 
    size, COUNT(quantity) quantity
FROM
    pizzas
        JOIN
    order_details USING (pizza_id)
GROUP BY size
ORDER BY COUNT(quantity) DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    name, SUM(quantity) quantities
FROM
    pizza_types
        JOIN
    pizzas USING (pizza_type_id)
        JOIN
    order_details USING (pizza_id)
GROUP BY name
ORDER BY quantities DESC
LIMIT 5;

                    # Intermediate #
                    
-- Join the necessary tables to find the total quantity of each pizza category ordered.                    
                    
SELECT 
    category, SUM(quantity) quantity
FROM
    order_details
        JOIN
    pizzas USING (pizza_id)
        JOIN
    pizza_types USING (pizza_type_id)
GROUP BY category;
                    
-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY COUNT(order_id) DESC;              
                    
-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) count
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.                  
 
with cte as(
select order_date,sum(quantity) quantity
from order_details
join orders using(order_id)
group by order_date)
select *, round(avg(quantity) over(),0) avg_quantity_order_per_day from cte;
                    
-- Determine the top 3 most ordered pizza types based on revenue.                 
 
SELECT 
    name, SUM(quantity * price) revenue
FROM
    order_details
        JOIN
    pizzas USING (pizza_id)
        JOIN
    pizza_types USING (pizza_type_id)
GROUP BY name
ORDER BY revenue DESC
LIMIT 3;
                    
                     # Advanced: #
			
-- Calculate the percentage contribution of each pizza type to total revenue.                  
  
with ct as(
select name, sum(quantity*price) revenue
from order_details
join pizzas using(pizza_id)
join pizza_types using(pizza_type_id)
group by name)
select *, concat(round((revenue/sum(revenue) over())*100,2),'%') 'revenue_%' from ct
order by concat(round((revenue/sum(revenue) over())*100,2),'%') desc;
 
-- Calculate the percentage contribution of each pizza category to total revenue.  
  
with ct as(
select category, sum(quantity*price) revenue
from order_details
join pizzas using(pizza_id)
join pizza_types using(pizza_type_id)
group by category)
select *, concat(round((revenue/sum(revenue) over())*100,2),'%') 'revenue_%' from ct
order by concat(round((revenue/sum(revenue) over())*100,2),'%') desc;
       
-- Analyze the cumulative revenue generated over time.    
       
with cte as(
select order_date,sum(quantity*price) as revenue
from order_details
join pizzas using(pizza_id)
join orders using(order_id)
group by order_date)
select *, sum(revenue) over(order by order_date) cum_revenue from cte; 

  
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.       
with ctt as(
with ct as(
select name,category, sum(quantity*price) revenue
from order_details
join pizzas using(pizza_id)
join pizza_types using(pizza_type_id)
group by name,category
order by category)
select *, rank() over(partition by category order by revenue desc) rk from ct)
select * from ctt where rk<=3;
  
       
       
       
       
       
       
       
       
       
       
       