use finance ;
select * from finance_data;

--- total sales ---
select sum(units_sold) 
from finance_data;

--- top_5_product ---
select product ,
sum(sales) as total_sales 
from finance_data 
group by product 
order by total_sales;

--- profit by country ---
select country, 
round(sum(profit),2) as total_profit 
from finance_data 
group by country
order by total_profit;

--- monthy trend ----
SELECT month_name, month_number,
       SUM(sales) AS monthly_sales
FROM finance_data
GROUP BY month_name,month_number
ORDER BY monthly_sales DESC;
--- profit and discount analysis ---
SELECT discount_band,
       ROUND(AVG(profit),2) AS avg_profit,
       ROUND(AVG(discounts),2) AS avg_discount
FROM finance_data
GROUP BY discount_band;

--- Product Profitability Analysis Goal Find ---
 
SELECT product,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin
FROM finance_data
GROUP BY product
ORDER BY total_profit DESC;

--- adding new column named profit margin ---
alter table finance_data add 
profit_margin double;

SET SQL_SAFE_UPDATES = 0;

UPDATE finance_data
SET profit_margin = (profit / sales) * 100;

SET SQL_SAFE_UPDATES = 1;

--- country wase market analyze ---
WITH segment_sales AS (
    SELECT country,
           segment,
           SUM(sales) AS total_sales,
           RANK() OVER(PARTITION BY country ORDER BY SUM(sales) DESC) AS rnk
    FROM finance_data
    GROUP BY country, segment
)

SELECT country,
       segment,
       ROUND(total_sales,2) AS total_sales
FROM segment_sales
WHERE rnk = 1;
--- Which Segment Performs Best in Each Country ---

SELECT country,
       segment,
       ROUND(SUM(sales),2) AS total_sales
FROM finance_data
GROUP BY country, segment
ORDER BY country, total_sales DESC;

--- Which Country Has Lowest Profit Margin? ---

SELECT country,
       ROUND((SUM(profit) / SUM(sales)) * 100,2) AS profit_margin
FROM finance_data
GROUP BY country
ORDER BY profit_margin ASC;

--- country base sale ,profit and margin analusis ---
select country,sum(sales)as totoal_sales ,
sum(profit) as total_profit ,sum(profit_margin) as total_margin from 
finance_data group by country;

--- product base sale ,profit and margin analusis ---
select product ,sum(sales)as totoal_sales ,
sum(profit) as total_profit ,sum(profit_margin) as total_margin from 
finance_data group by product;

--- discount analysis ---
select discount_band, sum(sales) ,sum(profit_margin) from 
finance_data 
group by discount_band;