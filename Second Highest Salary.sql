### 第二高的薪水
# https://leetcode-cn.com/problems/second-highest-salary/
# https://leetcode.com/problems/second-highest-salary/


### Requirements:
编写一个 SQL 查询，获取 Employee 表中第二高的薪水 Salary

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

例如上述 Employee 表，SQL查询应该返回 200 作为第二高的薪水。
如果不存在第二高的薪水，那么查询应返回 null

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+

### Solution:
# https://leetcode-cn.com/problems/second-highest-salary/solution/di-er-gao-de-xin-shui-by-leetcode/

### Method1:
### LIMIT + OFFSET
# https://dataschool.com/learn-sql/limit/

SELECT DISTINCT Salary AS SecondHighestSalary
FROM Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1;

# 然而，如果没有这样的第二最高工资，这个解决方案将被判断为 “错误答案”，
# 因为本表可能只有一项记录。为了克服这个问题，我们可以将其作为临时表。

SELECT
    (SELECT DISTINCT Salary
        FROM Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1) AS SecondHighestSalary;


### Method2:
### LIMIT + IFNULL
### 解决NULL问题：使用IFNULL

SELECT
    IFNULL(
      (SELECT DISTINCT Salary
       FROM Employee
       ORDER BY Salary DESC
        LIMIT 1 OFFSET 1),
    NULL) AS SecondHighestSalary
