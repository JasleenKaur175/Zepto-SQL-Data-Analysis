drop table if exists zepto;

create table zepto(
sku_id Serial PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL, 
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity Integer,
discountedSellingPrice NUMERIC(8,2),
weightInGms Integer,
outOfStock Boolean,
quantity INTEGER
);

--data exploration

--sample data
select * from zepto
limit 10;

--count of rows
SELECT COUNT(*) FROM zepto;

--null values
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountPercent is null
or
discountedSellingPrice is null
or
weightInGms is null
or 
availableQuantity is null
or
outOfStock is null
or
quantity is null;

--different product categories
select distinct category from zepto
order by category;

--products in stock vs out of stock
select outOfStock, count(sku_id)
from zepto
group by outOfStock;

--product names present multiple times
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) DESC;

--data cleaning

--proudcts with price 0
select * from zepto
where mrp = 0
or discountedSellingPrice=0;

delete from zepto 
where mrp=0;

--converting paise to rupees
update zepto 
set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto;

--Business Insights questions

--Q1)Find the top 10 best-value products based on discount percentage.

select distinct name, mrp, discountPercent
from zepto
order by discountPercent DESC
LIMIT 10;

--Q2) Products with high mrp but out of stock
select DISTINCT name,mrp
from zepto
where outOfStock= true and mrp > 300
order by mrp DESC;

--Q3) Calculate Estimated Revenue for each category
Select distinct category, sum(discountedSellingPrice*availableQuantity) AS estimated_revenue
from zepto
group by category
order by estimated_revenue;

--Q4) find all products where mrp is greater than 500 and discount is less than 10%
select distinct name,mrp , discountPercent
from zepto
where mrp >500 and discountPercent<10
order by mrp desc, discountPercent desc;

--Q5) Identfy top 5 categories offfering highest avg discount percentage.
select distinct category, Round(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount DESC
Limit 5;

--Q6) Find the price per gram for products above 100g and sort by best value
select distinct name, weightInGms, DiscountedSellingPrice, round(discountedSellingPrice/weightInGms,2) AS Price_per_gm
from zepto
where weightInGms >=100
order by Price_per_gm;

--Q7) group the products into categories like low,medium and bulk.
select distinct name,weightInGms,
case WHEN weightInGms < 1000 then 'low'
	when weightInGms < 5000 then 'medium'
	else 'bulk'
	end as weight_category
from zepto;

--Q8) Whats total inventory weight per category?
select distinct category, sum(weightInGms*availableQuantity) as Total_inventory_weight
from zepto
group by category
order by Total_inventory_weight;
