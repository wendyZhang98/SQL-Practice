-- Link:
-- https://leetcode.com/problems/apples-oranges/


-- Requirement:
Table: Sales
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    |
| sold_num      | int     |
+---------------+---------+
(sale_date, fruit) is the primary key for this table.
This table contains the sales of "apples" and "oranges" sold each day.

Write an SQL query to report the difference between number of apples and oranges sold each day.

Return the result table ordered by sale_date in format ('YYYY-MM-DD').

The query result format is in the following example:


Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+

Result table:
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+

Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).


-- My Solution: 81%
-- https://leetcode.com/problems/apples-oranges/discuss/675752/Clear-MySQL-solution-with-Case-When
select sale_date, sum(case when fruit='apples' then sold_num else -sold_num end) as diff
from sales
group by sale_date


-- My Solution: 52%
-- https://leetcode.com/problems/apples-oranges/discuss/670318/2-MySQL-Solutions%3A-Join-and-Case-When
select distinct a.sale_date, (a.sold_num - b.sold_num) as diff
from
(
  select sale_date, fruit, sold_num
  from Sales
  where fruit = 'apples'
) a
join
(
  select sale_date, fruit, sold_num
  from Sales
  where fruit = 'oranges'
) b
on a.sale_date = b.sale_date


