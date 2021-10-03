-- Link:
-- https://leetcode.com/problems/create-a-session-bar-chart/


-- Requirement:
Table: Sessions
+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| session_id          | int     |
| duration            | int     |
+---------------------+---------+
session_id is the primary key for this table.
duration is the time in seconds that a user has visited the application.


You want to know how long a user visits your application.
You decided to create bins of "[0-5>", "[5-10>", "[10-15>" and "15 minutes or more" and count the number of sessions on it.

Write an SQL query to report the (bin, total) in any order.

The query result format is in the following example.

Sessions table:
+-------------+---------------+
| session_id  | duration      |
+-------------+---------------+
| 1           | 30            |
| 2           | 199           |
| 3           | 299           |
| 4           | 580           |
| 5           | 1000          |
+-------------+---------------+

Result table:
+--------------+--------------+
| bin          | total        |
+--------------+--------------+
| [0-5>        | 3            |
| [5-10>       | 1            |
| [10-15>      | 0            |
| 15 or more   | 1            |
+--------------+--------------+
For session_id 1, 2 and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
There are no session with a duration greater or equial than 10 minutes and less than 15 minutes.
For session_id 5 has a duration greater or equal than 15 minutes.


-- Solution: 97%
-- https://leetcode.com/problems/create-a-session-bar-chart/discuss/887107/EXPLAINED%3A-Clear-and-Simple-Solution-(No-CASE-statement)
WITH cte AS (
    SELECT '[0-5>' AS bin,  0 AS min_duration, 5*60 AS max_duration
    UNION ALL
    SELECT '[5-10>' AS bin,  5*60 AS min_duration, 10*60 AS max_duration
    UNION ALL
    SELECT '[10-15>' AS bin, 10*60 AS min_duration, 15*60 AS max_duration
    UNION ALL
    SELECT '15 or more' AS bin,  15*60 as min_duration, 2147483647 AS max_duration
    )

SELECT cte.bin, COUNT(s.session_id) AS total
FROM Sessions s
RIGHT JOIN cte
	  ON s.duration >= min_duration
      AND s.duration < max_duration
GROUP BY cte.bin;



-- Solution: 53%
-- https://leetcode.com/problems/create-a-session-bar-chart/discuss/702518/MySQL-no-CASE-WHEN
SELECT '[0-5>' AS 'bin', SUM(duration/60 < 5) AS 'total'
FROM Sessions
UNION
SELECT '[5-10>' AS 'bin', SUM(duration/60 >= 5 AND duration/60 < 10) AS 'total'
FROM Sessions
UNION
SELECT '[10-15>' AS 'bin', SUM(duration/60 >= 10 AND duration/60 < 15) AS 'total'
FROM Sessions
UNION
SELECT '15 or more' AS 'bin', SUM(duration/60 >= 15) AS 'total'
FROM Sessions;


-- Solution: 10%
-- https://leetcode.com/problems/create-a-session-bar-chart/discuss/610956/two-solutions-both-beat-100
SELECT b.bin, IFNULL(COUNT(s.session_id),0) AS total
FROM
    (SELECT session_id,
           CASE WHEN duration/60<5 THEN '[0-5>'
                WHEN duration/60>=5 AND duration/60<10 THEN '[5-10>'
                WHEN duration/60>=10 AND duration/60<15 THEN '[10-15>'
                ELSE '15 or more' END AS bin
    FROM sessions) s
RIGHT JOIN
    (SELECT '[0-5>' AS bin
     UNION ALL
     SELECT '[5-10>' AS bin
     UNION ALL
     SELECT '[10-15>' AS bin
     UNION ALL
     SELECT '15 or more' AS bin) b
        ON b.bin=s.bin
GROUP BY bin;