-- Link:
-- https://leetcode.com/problems/unpopular-books/


-- Requirement:
Table: Books
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| book_id        | int     |
| name           | varchar |
| available_from | date    |
+----------------+---------+
book_id is the primary key of this table.

Table: Orders
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| order_id       | int     |
| book_id        | int     |
| quantity       | int     |
| dispatch_date  | date    |
+----------------+---------+
order_id is the primary key of this table.
book_id is a foreign key to the Books table.


Write an SQL query that
reports the books that have sold less than 10 copies in the last year,
excluding books that have been available for less than 1 month from today.
Assume today is 2019-06-23.

The query result format is in the following example:

Books table:
+---------+--------------------+----------------+
| book_id | name               | available_from |
+---------+--------------------+----------------+
| 1       | "Kalila And Demna" | 2010-01-01     |
| 2       | "28 Letters"       | 2012-05-12     |
| 3       | "The Hobbit"       | 2019-06-10     |
| 4       | "13 Reasons Why"   | 2019-06-01     |
| 5       | "The Hunger Games" | 2008-09-21     |
+---------+--------------------+----------------+

Orders table:
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+
| 1        | 1       | 2        | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 3       | 8        | 2019-06-11    |
| 4        | 4       | 6        | 2019-06-05    |
| 5        | 4       | 5        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |
+----------+---------+----------+---------------+

Result table:
+-----------+--------------------+
| book_id   | name               |
+-----------+--------------------+
| 1         | "Kalila And Demna" |
| 2         | "28 Letters"       |
| 5         | "The Hunger Games" |
+-----------+--------------------+

-- My Solution: 51%
SELECT b.book_id, b.name
FROM
(SELECT book_id, name FROM Books WHERE available_from <= '2019-05-23') b
LEFT JOIN
(SELECT * FROM Orders WHERE dispatch_date >= '2018-06-23') o
ON b.book_id = o.book_id
GROUP BY book_id
HAVING SUM(quantity) IS NULL OR SUM(quantity) < 10;


-- Solution:
-- NOT IN:
-- https://leetcode.com/problems/unpopular-books/discuss/519607/NOT-IN
SELECT book_id,
       name
FROM Books
WHERE available_from < '2019-05-23'
AND book_id NOT IN
            (SELECT book_id
             FROM Orders
             WHERE dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'
             GROUP BY book_id
             HAVING sum(quantity) >= 10)