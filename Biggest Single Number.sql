### Link:
# https://leetcode.com/problems/biggest-single-number/


### Requirement:
Table my_numbers contains many numbers in column num including duplicated ones.
Can you write a SQL query to find the biggest number, which only appears once.
+---+
|num|
+---+
| 8 |
| 8 |
| 3 |
| 3 |
| 1 |
| 4 |
| 5 |
| 6 |


For the sample data above, your query should return the following result:
+---+
|num|
+---+
| 6 |


Note:
If there is no such number, just output null.


### Solution1:
SELECT num
FROM
(SELECT num
FROM my_numbers
GROUP BY num
HAVING COUNT(num)=1) num_order
ORDER BY num DESC
LIMIT 1;
### This is wrong.
### When we expect NULL, this only returns [].


### Solution to this:
SELECT max(num)
FROM
(SELECT num
FROM my_numbers
GROUP BY num
HAVING COUNT(num)=1) num_order;

