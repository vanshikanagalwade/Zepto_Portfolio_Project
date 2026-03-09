DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	quantity INTEGER
);

SELECT * FROM zepto;


--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--null values
SELECT * FROM zepto 
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
availableQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto 
ORDER BY category;

--products in stock VS out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

SELECT * FROM zepto;

--products names present multiple times
SELECT name, COUNT(sku_id) AS numbers_of_SKU
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id)DESC;

--data cleaning
--products with price =0
SELECT * FROM zepto
WHERE mrp =0 OR discountedSellingPrice=0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupee
UPDATE zepto
SET mrp = mrp/100,
discountedSellingPrice = discountedSellingPrice/100;

SELECT mrp,discountedSellingPrice FROM zepto;

--find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT mrp, name , discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--what are the products with high MRP but out of stock
SELECT DISTINCT name, mrp
FROM zepto 
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;

--calculate estimated revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--find all products where MRP is greater than 500 and discount is less than 10%
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;


--Indentify the top 5 categories offerings the highest average discount percentage.
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2)  AS price_per_gram
FROM zepto
WHERE weightInGms > 100
ORDER BY price_per_gram;

--group the products into categories like low, medium, bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

--what is the total inventory weight per category.
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;