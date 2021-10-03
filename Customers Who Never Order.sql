### 从不订购的客户
# https://leetcode-cn.com/problems/customers-who-never-order/
# https://leetcode.com/problems/customers-who-never-order/



### Requirement:
某网站包含两个表，Customers 表和 Orders 表。
编写一个 SQL 查询，找出所有从不订购任何东西的客户。

Customers 表：
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+

Orders 表：
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+

例如给定上述表格，你的查询应返回：
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+


### Method 1: NOT IN
# https://leetcode-cn.com/problems/customers-who-never-order/solution/cong-bu-ding-gou-de-ke-hu-by-leetcode/

select customers.name as customers_name
from customers
where customers.id not in
(
    select customerid from orders
);


### Method 2: LEFT JOIN + IS NULL
# https://leetcode-cn.com/problems/customers-who-never-order/solution/tu-jie-sqlmian-shi-ti-cha-zhao-bu-zai-biao-li-de-s/

select a.Name as Customers
from Customers as a
left join Orders as b
on a.Id=b.CustomerId
where b.CustomerId is null;
