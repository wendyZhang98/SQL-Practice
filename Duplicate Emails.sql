### 查找出重复的电子邮箱
# https://leetcode-cn.com/problems/duplicate-emails/
# https://leetcode.com/problems/duplicate-emails/

### Requirements:
编写一个 SQL 查询，查找 Person 表中所有重复的电子邮箱。

示例：

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+

根据以上输入，你的查询应返回以下结果：
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
说明：所有电子邮箱都是小写字母


### Solution:
# https://leetcode-cn.com/problems/duplicate-emails/solution/cha-zhao-zhong-fu-de-dian-zi-you-xiang-by-leetcode/


### Method1：GROUP BY + 临时表
select Email from
(
  select Email, count(Email) as num
  from Person
  group by Email
) as statistic
where num > 1;


### Method2：GROUP BY + HAVING
select Email
from Person
group by Email
having count(Email) > 1;