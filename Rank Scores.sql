### Link:
# https://leetcode.com/problems/rank-scores/


Write a SQL query to rank scores.
If there is a tie between two scores,
both should have the same ranking.


Note that after a tie,
the next ranking number should be the next consecutive integer value.
In other words, there should be no "holes" between ranks.
+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+


For example, given the above Scores table,
your query should generate the following report (order by highest score):
+-------+---------+
| score | Rank    |
+-------+---------+
| 4.00  | 1       |
| 4.00  | 1       |
| 3.85  | 2       |
| 3.65  | 3       |
| 3.65  | 3       |
| 3.50  | 4       |
+-------+---------+


Important Note: For MySQL solutions,
to escape reserved words used as column names,
you can use an apostrophe(撇号) before and after the keyword.
For example `Rank`.


### Solution1:
### DENSE_RANK()
# https://leetcode.com/submissions/detail/529639128/
SELECT SCORE, DENSE_RANK() OVER (ORDER BY SCORE DESC) AS 'RANK'
FROM SCORES;


### Solution2:
### https://leetcode.com/problems/rank-scores/discuss/53094/Simple-Short-Fast
SELECT s.Score, count(distinct t.score) Rank
FROM Scores s JOIN Scores t ON s.Score <= t.score
GROUP BY s.Id
ORDER BY s.Score desc









