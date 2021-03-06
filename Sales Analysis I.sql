-- Link：
-- https://leetcode.com/problems/sales-analysis-i/


-- Requirement:
Table: Product
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key of this table.

Table: Sales
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+------ ------+---------+
This table has no primary key, it can have repeated rows.
product_id is a foreign key to Product table.


Write an SQL query that
reports the best seller by total sales price,
If there is a tie, report them all.
The query result format is in the following example:


Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+
Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+
Result table:
+-------------+
| seller_id   |
+-------------+
| 1           |
| 3           |
+-------------+
Both sellers with id 1 and 3 sold products with the most total price of 2800.


-- Solution---
-- ??????---
SELECT seller_id
FROM
(SELECT seller_id, SUM(price) as sum_price
FROM Sales
GROUP BY seller_id) AS seller_sum_price
WHERE sum_price = MAX(sum_price);
-- Link for this error
-- https://www.coder.work/article/6784376
-- https://stackoverflow.com/questions/18877320/sql-using-max-in-a-where-clause



-- Solution
-- https://leetcode.com/problems/sales-analysis-i/discuss/311519/MySQL-Solution
-- 16%
SELECT seller_id
FROM Sales
GROUP BY seller_id
HAVING SUM(PRICE) >= all (
    SELECT SUM(PRICE)
    FROM Sales
    GROUP BY seller_id
);


-- Solution:
-- https://leetcode.com/problems/sales-analysis-i/discuss/349042/MySQL-Solution
-- 90%
SELECT seller_id
FROM Sales
GROUP BY seller_id
HAVING SUM(price) = (SELECT SUM(price)
					 FROM Sales
                     GROUP BY seller_id
                     ORDER BY 1 DESC
                     LIMIT 1);


--- Solution:
-- https://leetcode.com/problems/sales-analysis-i/discuss/329794/SQL-Server-solution-%22WITH-..-AS%22-syntax
-- 67%
WITH TEMP AS (
    SELECT seller_id, SUM(price) AS price_sum
    FROM Sales
    GROUP BY seller_id)
SELECT
    seller_id
FROM
    TEMP
WHERE
    price_sum = (SELECT MAX(price_sum) FROM TEMP);