-- Link:
-- https://leetcode.com/problems/monthly-transactions-ii/


-- Requirement:
Table: Transactions
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].

Table: Chargebacks
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| trans_date     | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks
from some transactions placed in Transactions table.

trans_id is a foreign key to the id column of Transactions table.

Each chargeback corresponds to a transaction made previously even if they were not approved.

Write an SQL query to find for each month and country:
the number of approved transactions and their total amount,
the number of chargebacks, and their total amount.

!!!
Note: In your query, given the month and country, ignore rows with all zeros.

The query result format is in the following example:

Transactions table:
+-----+---------+----------+--------+------------+
| id  | country | state    | amount | trans_date |
+-----+---------+----------+--------+------------+
| 101 | US      | approved | 1000   | 2019-05-18 |
| 102 | US      | declined | 2000   | 2019-05-19 |
| 103 | US      | approved | 3000   | 2019-06-10 |
| 104 | US      | declined | 4000   | 2019-06-13 |
| 105 | US      | approved | 5000   | 2019-06-15 |
+-----+---------+----------+--------+------------+
Chargebacks table:
+----------+------------+
| trans_id | trans_date |
+----------+------------+
| 102      | 2019-05-29 |
| 101      | 2019-06-30 |
| 105      | 2019-09-18 |
+----------+------------+
Result table:
+---------+---------+----------------+-----------------+------------------+-------------------+
| month   | country | approved_count | approved_amount | chargeback_count | chargeback_amount |
+---------+---------+----------------+-----------------+------------------+-------------------+
| 2019-05 | US      | 1              | 1000            | 1                | 2000              |
| 2019-06 | US      | 2              | 8000            | 1                | 1000              |
| 2019-09 | US      | 0              | 0               | 1                | 5000              |
+---------+---------+----------------+-----------------+------------------+-------------------+


-- Solution: 19%
-- https://leetcode.com/problems/monthly-transactions-ii/discuss/390964/simple-MySQL-solution
SELECT month,
       country,
       SUM(CASE WHEN state = "approved" THEN 1 ELSE 0 END) AS approved_count,
       SUM(CASE WHEN state = "approved" THEN amount ELSE 0 END) AS approved_amount,
       SUM(CASE WHEN state = "back" THEN 1 ELSE 0 END) AS chargeback_count,
       SUM(CASE WHEN state = "back" THEN amount ELSE 0 END) AS chargeback_amount
FROM
(
    SELECT LEFT(chargebacks.trans_date, 7) AS month, country, "back" AS state, amount
    FROM chargebacks
    JOIN transactions ON chargebacks.trans_id = transactions.id
    UNION ALL
    SELECT LEFT(trans_date, 7) AS month, country, state, amount
    FROM transactions
    WHERE state = "approved"
) s
GROUP BY month, country;


-- Solution: 99.5%
-- https://leetcode.com/problems/monthly-transactions-ii/discuss/532075/MySQL-solution-with-explanation%3A-CASE-WHEN-%2B-UNION-ALL-98.23

-- #1.create a temporary table to identity state of 'chargebacks'
-- #2.combin ordinary table and temporary table to build a source table for filtering
-- #3.filtering records based on conditions
--
-- #note: assign records into a column: 'xxx' AS column_name
-- #note: compare the difference between '%m' and '%M'

SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month,
       country,
       SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
       SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_amount,
       SUM(CASE WHEN state = 'bc' THEN 1 ELSE 0 END) AS chargeback_count,
       SUM(CASE WHEN state = 'bc' THEN amount ELSE 0 END) AS chargeback_amount
FROM
(
    SELECT id, country, 'bc' AS state, amount, c.trans_date
    FROM Transactions t
    RIGHT JOIN Chargebacks c
    ON t.id = c.trans_id
UNION ALL
    SELECT id, country, state, amount, trans_date
    FROM Transactions
) tem
GROUP BY country, DATE_FORMAT(trans_date, '%Y-%m')
HAVING approved_count + approved_amount + chargeback_count + chargeback_amount <> 0
