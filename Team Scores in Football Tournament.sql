-- Link:
-- https://leetcode.com/problems/team-scores-in-football-tournament/


-- Requirement:
Table: Teams
+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| team_id       | int      |
| team_name     | varchar  |
+---------------+----------+
team_id is the primary key of this table.
Each row of this table represents a single football team.

Table: Matches
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| host_team     | int     |
| guest_team    | int     |
| host_goals    | int     |
| guest_goals   | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a finished match between two different teams.
Teams host_team and guest_team are represented by their IDs in the teams table (team_id)
and they scored host_goals and guest_goals goals respectively.


You would like to compute the scores of all teams after all matches. Points are awarded as follows:
A team receives three points if they win a match (Score strictly more goals than the opponent team).
A team receives one point if they draw a match (Same number of goals as the opponent team).
A team receives no points if they lose a match (Score less goals than the opponent team).
Write an SQL query that selects the team_id, team_name and num_points of each team in the tournament after all described matches. Result table should be ordered by num_points (decreasing order). In case of a tie, order the records by team_id (increasing order).

The query result format is in the following example:

Teams table:
+-----------+--------------+
| team_id   | team_name    |
+-----------+--------------+
| 10        | Leetcode FC  |
| 20        | NewYork FC   |
| 30        | Atlanta FC   |
| 40        | Chicago FC   |
| 50        | Toronto FC   |
+-----------+--------------+
Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
+------------+--------------+---------------+-------------+--------------+
| 1          | 10           | 20            | 3           | 0            |
| 2          | 30           | 10            | 2           | 2            |
| 3          | 10           | 50            | 5           | 1            |
| 4          | 20           | 30            | 1           | 0            |
| 5          | 50           | 30            | 1           | 0            |
+------------+--------------+---------------+-------------+--------------+

Result table:
+------------+--------------+---------------+
| team_id    | team_name    | num_points    |
+------------+--------------+---------------+
| 10         | Leetcode FC  | 7             |
| 20         | NewYork FC   | 3             |
| 50         | Toronto FC   | 3             |
| 30         | Atlanta FC   | 1             |
| 40         | Chicago FC   | 0             |
+------------+--------------+---------------+


--  Write your MySQL query statement below
SELECT all_points.team_id, Teams.team_name, all_points.points AS num_points
FROM
((SELECT host_team as team_id,
       (CASE WHEN host_goals > guest_goals THEN 3
       WHEN host_goals = guest_goals THEN 1
       ELSE 0 END) AS points FROM Matches) a
UNION ALL
(SELECT guest_team AS team_id,
       (CASE WHEN host_goals < guest_goals THEN 3
       WHEN host_goals = guest_goals THEN 1
       ELSE 0 END) AS points FROM Matches) b) all_points
LEFT JOIN Teams ON all_points.team_id = Teams.team_id
GROUP BY team_id
ORDER BY team_id ASC;


-- Solution: 23%
-- https://leetcode.com/problems/team-scores-in-football-tournament/discuss/395895/simple-MYSQL-solution-beats-100-WITH-LEFT-JOIN
SELECT team_id,team_name,
SUM(CASE WHEN team_id=host_team AND host_goals>guest_goals THEN 3 ELSE 0 END)+
SUM(CASE WHEN team_id=guest_team AND guest_goals>host_goals THEN 3 ELSE 0 END)+
SUM(CASE WHEN team_id=host_team AND host_goals=guest_goals THEN 1 ELSE 0 END)+
SUM(CASE WHEN team_id=guest_team AND guest_goals=host_goals THEN 1 ELSE 0 END)
AS num_points
FROM Teams
LEFT JOIN Matches
ON team_id=host_team OR team_id=guest_team
GROUP BY team_id
ORDER BY num_points DESC, team_id ASC;


-- Solution: 10%
SELECT
  team_id,
  team_name,
  SUM(CASE WHEN team_id=host_team AND host_goals>guest_goals THEN 3
          WHEN team_id=guest_team AND guest_goals>host_goals THEN 3
          WHEN team_id=host_team AND host_goals=guest_goals THEN 1
          WHEN team_id=guest_team AND guest_goals=host_goals THEN 1
      ELSE 0 END)
    as num_points
FROM Teams
LEFT JOIN Matches
ON team_id IN (host_team, guest_team)
GROUP BY 1
ORDER BY 3 DESC, 1
--- a few changes to make it look more concise


-- Solution: 13%
-- https://leetcode.com/problems/team-scores-in-football-tournament/discuss/397079/MySQLSQL-SERVER-beats-100-with-no-union
SELECT team_id, team_name,
SUM(
    CASE WHEN team_id = host_team AND host_goals > guest_goals THEN 3
         WHEN team_id = guest_team AND guest_goals > host_goals THEN 3
         WHEN host_goals = guest_goals THEN 1
    ELSE 0 END
) AS "num_points"
FROM Teams t
LEFT JOIN Matches m ON t.team_id = m.host_team OR t.team_id = m.guest_team
GROUP BY team_id, team_name
ORDER BY num_points DESC, team_id;


