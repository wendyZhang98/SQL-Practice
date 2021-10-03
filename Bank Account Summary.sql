-- Link:
-- https://leetcode.com/problems/bank-account-summary/


-- Requirement:
Table: Users
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| user_id      | int     |
| user_name    | varchar |
| credit       | int     |
+--------------+---------+
user_id is the primary key for this table.
Each row of this table contains the current credit information for each user.


Table: Transactions
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| trans_id      | int     |
| paid_by       | int     |
| paid_to       | int     |
| amount        | int     |
| transacted_on | date    |
+---------------+---------+
trans_id is the primary key for this table.
Each row of this table contains the information about the transaction in the bank.
User with id (paid_by) transfer money to user with id (paid_to).


Leetcode Bank (LCB) helps its coders in making virtual payments.
Our bank records all transactions in the table Transaction,
we want to find out the current balance of all users and check
wheter they have breached their credit limit (If their current credit is less than 0).


Write an SQL query to report.


user_id
user_name
credit, current balance after performing transactions.
credit_limit_breached, check credit_limit ("Yes" or "No")
Return the result table in any order.

The query result format is in the following example.



Users table:
+------------+--------------+-------------+
| user_id    | user_name    | credit      |
+------------+--------------+-------------+
| 1          | Moustafa     | 100         |
| 2          | Jonathan     | 200         |
| 3          | Winston      | 10000       |
| 4          | Luis         | 800         |
+------------+--------------+-------------+

Transactions table:
+------------+------------+------------+----------+---------------+
| trans_id   | paid_by    | paid_to    | amount   | transacted_on |
+------------+------------+------------+----------+---------------+
| 1          | 1          | 3          | 400      | 2020-08-01    |
| 2          | 3          | 2          | 500      | 2020-08-02    |
| 3          | 2          | 1          | 200      | 2020-08-03    |
+------------+------------+------------+----------+---------------+

Result table:
+------------+------------+------------+-----------------------+
| user_id    | user_name  | credit     | credit_limit_breached |
+------------+------------+------------+-----------------------+
| 1          | Moustafa   | -100       | Yes                   |
| 2          | Jonathan   | 500        | No                    |
| 3          | Winston    | 9900       | No                    |
| 4          | Luis       | 800        | No                    |
+------------+------------+------------+-----------------------+
Moustafa paid $400 on "2020-08-01" and received $200 on "2020-08-03", credit (100 -400 +200) = -$100
Jonathan received $500 on "2020-08-02" and paid $200 on "2020-08-08", credit (200 +500 -200) = $500
Winston received $400 on "2020-08-01" and paid $500 on "2020-08-03", credit (10000 +400 -500) = $9990
Luis didnt received any transfer, credit = $800



-- Solution：47%
-- https://leetcode.com/problems/bank-account-summary/discuss/804295/MySQL-solution-using-SUM-and-CASE-WHEN-without-subquery
SELECT user_id, user_name,
IFNULL(SUM(CASE WHEN a.user_id=b.paid_by THEN -amount ELSE amount END), 0) + a.credit as credit,
CASE WHEN IFNULL(SUM(CASE WHEN a.user_id=b.paid_by THEN -amount ELSE amount END), 0) >= -a.credit THEN "No" ELSE "Yes" END as credit_limit_breached
FROM Users as a
LEFT JOIN Transactions as b
ON a.user_id=b.paid_by OR a.user_id=b.paid_to
GROUP BY a.user_id;



-- Solution: Error don't know why
-- https://leetcode.com/problems/bank-account-summary/discuss/804180/MySQL-easy-to-follow-and-faster-than-100-neat-solution
SELECT user_id,
       user_name,
       (credit - IFNULL(out_cash, 0) + IFNULL(in_cash, 0)) AS credit,
       IF((credit - IFNULL(out_cash, 0) + IFNULL(in_cash, 0)) < 0, 'Yes', 'No') AS credit_limit_breached
FROM Users U
LEFT JOIN
    (SELECT paid_by,
            SUM(amount) AS out_cash
     FROM Transaction
     GROUP BY paid_by) out_tmp
ON U.user_id = out_tmp.paid_by
LEFT JOIN
    (SELECT paid_to,
            SUM(amount) AS in_cash
     FROM Transaction
     GROUP BY paid_to) in_tmp
ON U.user_id = in_tmp.paid_to;
