-- Link:
-- https://leetcode.com/problems/active-businesses/

-- Requirement:
Table: Events
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| business_id   | int     |
| event_type    | varchar |
| occurences    | int     |
+---------------+---------+
(business_id, event_type) is the primary key of this table.
Each row in the table logs the info that
an event of some type occurred at some business for a number of times.

The average activity for a particular event_type is
the average occurences across all companies that have this event.

An active business is a business that
has more than one event_type such that their occurences is
strictly greater than the average activity for that event.

Write an SQL query to find all active businesses.

The query result format is in the following example:

Events table:
+-------------+------------+------------+
| business_id | event_type | occurences |
+-------------+------------+------------+
| 1           | reviews    | 7          |
| 3           | reviews    | 3          |
| 1           | ads        | 11         |
| 2           | ads        | 7          |
| 3           | ads        | 6          |
| 1           | page views | 3          |
| 2           | page views | 12         |
+-------------+------------+------------+
Result table:
+-------------+
| business_id |
+-------------+
| 1           |
+-------------+
The average activity for each event can be calculated as follows:
- 'reviews': (7+3)/2 = 5
- 'ads': (11+7+6)/3 = 8
- 'page views': (3+12)/2 = 7.5
The business with id=1 has 7 'reviews' events (more than 5)
and 11 'ads' events (more than 8), so it is an active business.


-- Solution: 93%
-- https://leetcode.com/problems/active-businesses/discuss/380221/MySQL-Solution-with-Explanation
SELECT business_id
FROM
(SELECT event_type, avg(occurences) AS ave_occurences
 FROM events AS e1
 GROUP BY event_type
) AS tmp1
JOIN events AS e2 ON tmp1.event_type = e2.event_type
WHERE e2.occurences > tmp1.ave_occurences
GROUP BY business_id
HAVING COUNT(DISTINCT tmp1.event_type) > 1;
