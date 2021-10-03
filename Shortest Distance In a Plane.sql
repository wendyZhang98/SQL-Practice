### Link:
# https://leetcode.com/problems/shortest-distance-in-a-plane/


### Requirement:
Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
Write a query to find the shortest distance between these points rounded to 2 decimals.

| x  | y  |
|----|----|
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |

The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:
| shortest |
|----------|
| 1.00     |


Note: The longest distance among all the points are less than 10000.

### Solution1:
### built-in functions: SQRT() + POW()

### Intuition
# Calculate the distances between each two points and then display the smallest one.

SELECT
    ROUND(SQRT(MIN((POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2)))), 2) AS shortest
FROM
    point_2d p1
        JOIN
    point_2d p2 ON p1.x != p2.x OR p1.y != p2.y
;
;

### Note:
1. The condition 'p1.x != p2.x OR p2.y != p2.y' is to avoid calculating the distance of a point with itself. Otherwise, the minimum distance will be always zero.
2. The columns p1.x, p1.y, p2.x and p2.y are for demonstrating. They are not necessary for the final solution.

To put the MIN() inside of SQRT() will slightly improve the performance.


### Solution2:
# https://leetcode.com/problems/shortest-distance-in-a-plane/solution/

### Optimize to avoid reduplicate caculations
### Intuition
It is unnecessary to calculate the distance between all points to all other points
since some of them may already be done. So how to avoid the reduplicate calculations?


### Algorithm
When join the table with itself,
we can claim to only calculate the distance between one point to another point in a certain rule such ponts with bigger x value.
By following this rule, we can avoid quite a lot of reduplicate calculations.


SELECT
    t1.x,
    t1.y,
    t2.x,
    t2.y,
    SQRT((POW(t1.x - t2.x, 2) + POW(t1.y - t2.y, 2))) AS distance
FROM
    point_2d t1
        JOIN
    point_2d t2 ON (t1.x <= t2.x AND t1.y < t2.y)
        OR (t1.x <= t2.x AND t1.y > t2.y)
        OR (t1.x < t2.x AND t1.y = t2.y)
;