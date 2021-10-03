-- Link:
-- https://leetcode.com/problems/activity-participants/


Table: Friends
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| activity      | varchar |
+---------------+---------+
id is the id of the friend and primary key for this table.
name is the name of the friend.
activity is the name of the activity which the friend takes part in.

Table: Activities
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
name is the name of the activity.

Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.

Return the result table in any order.
Each activity in table Activities is performed by any person in the table Friends.

The query result format is in the following example:

Friends table:
+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan D.  | Eating        |
| 2    | Jade W.      | Singing       |
| 3    | Victor J.    | Singing       |
| 4    | Elvis Q.     | Eating        |
| 5    | Daniel A.    | Eating        |
| 6    | Bob B.       | Horse Riding  |
+------+--------------+---------------+

Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
+------+--------------+

Result table:
+--------------+
| activity     |
+--------------+
| Singing      |
+--------------+

Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
Singing is performed by 2 friends (Victor J. and Jade W.)


-- Solution: 36%
-- https://leetcode.com/problems/activity-participants/discuss/571577/MySQL-Solution
select activity
from friends
group by activity
having count(*) > (select count(*) from friends group by activity order by 1 limit 1)
and count(*) < (select count(*) from friends group by activity order by 1 desc limit 1);


-- Solution: 94%
-- https://leetcode.com/problems/activity-participants/discuss/516451/Oracle-with-Window-Function
SELECT activity
FROM
(SELECT activity,
        count(*) as ac,
        max(count(*)) OVER () as max_num,
        min(count(*)) OVER () as min_num
FROM Friends
GROUP BY activity) tablea
WHERE ac not in (max_num, min_num);

