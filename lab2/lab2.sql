/*
Lab 2 report <Mervan Palmér merpa433, Björn the mothafucking Edblom bjoed735>
*/

/* Question 1 */
SELECT * FROM jbemployee;
/*
------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+
*/
/* Question 2 */
SELECT * FROM jbdept ORDER BY name;
/*
+----+------------------+-------+-------+---------+
| id | name             | store | floor | manager |
+----+------------------+-------+-------+---------+
|  1 | Bargain          |     5 |     0 |      37 |
| 35 | Book             |     5 |     1 |      55 |
| 10 | Candy            |     5 |     1 |      13 |
| 73 | Children's       |     5 |     1 |      10 |
| 43 | Children's       |     8 |     2 |      32 |
| 19 | Furniture        |     7 |     4 |      26 |
| 99 | Giftwrap         |     5 |     1 |      98 |
| 14 | Jewelry          |     8 |     1 |      33 |
| 47 | Junior Miss      |     7 |     2 |     129 |
| 65 | Junior's         |     7 |     3 |      37 |
| 26 | Linens           |     7 |     3 |     157 |
| 20 | Major Appliances |     7 |     4 |      26 |
| 58 | Men's            |     7 |     2 |     129 |
| 60 | Sportswear       |     5 |     1 |      10 |
| 34 | Stationary       |     5 |     1 |      33 |
| 49 | Toys             |     8 |     2 |      35 |
| 63 | Women's          |     7 |     3 |      32 |
| 70 | Women's          |     5 |     1 |      10 |
| 28 | Women's          |     8 |     2 |      32 |
+----+------------------+-------+-------+---------+


*/
/* Question 3 */
SELECT * FROM jbparts WHERE qoh=0;
/* 
+----+-------------------+-------+--------+------+
| id | name              | color | weight | qoh  |
+----+-------------------+-------+--------+------+
| 11 | card reader       | gray  |    327 |    0 |
| 12 | card punch        | gray  |    427 |    0 |
| 13 | paper tape reader | black |    107 |    0 |
| 14 | paper tape punch  | black |    147 |    0 |
+----+-------------------+-------+--------+------+

*/
/* Question 4 */
SELECT * FROM jbemployee WHERE salary >= 9000 AND salary <= 10000;


/* +-----+----------------+--------+---------+-----------+-----------+
| id  | name           | salary | manager | birthyear | startyear |
+-----+----------------+--------+---------+-----------+-----------+
|  13 | Edwards, Peter |   9000 |     199 |      1928 |      1958 |
|  32 | Smythe, Carol  |   9050 |     199 |      1929 |      1967 |
|  98 | Williams, Judy |   9000 |     199 |      1935 |      1969 |
| 129 | Thomas, Tom    |  10000 |     199 |      1941 |      1962 |
+-----+----------------+--------+---------+-----------+-----------+
*/

/* Question 5 */
SELECT *, startyear - birthyear FROM jbemployee;
/* +------+--------------------+--------+---------+-----------+-----------+-----------------------+
| id   | name               | salary | manager | birthyear | startyear | startyear - birthyear |
+------+--------------------+--------+---------+-----------+-----------+-----------------------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |                    18 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |                     1 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |                    30 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |                    40 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |                    38 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |                    32 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |                    22 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |                    24 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |                    49 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |                    34 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |                    21 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |                    20 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |                     0 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |                    21 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |                    21 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |                    20 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |                    26 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |                    21 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |                    19 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |                    21 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |                    23 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |                    19 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |                    19 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |                    24 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |                    15 |
+------+--------------------+--------+---------+-----------+-----------+-----------------------+

*/
/* Question 6 */
SELECT * FROM jbemployee WHERE name LIKE '%son,%';
/*
+----+---------------+--------+---------+-----------+-----------+
| id | name          | salary | manager | birthyear | startyear |
+----+---------------+--------+---------+-----------+-----------+
| 26 | Thompson, Bob |  13000 |     199 |      1930 |      1970 |
+----+---------------+--------+---------+-----------+-----------+
*/

/* Question 7 */
SELECT * FROM jbitem WHERE supplier IN (SELECT id FROM jbsupplier WHERE name = 'Fisher-Price');
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
+-----+-----------------+------+-------+------+----------+
*/

/* Question 8 */
SELECT * FROM jbitem, jbsupplier WHERE jbsupplier.name = 'Fisher-Price' AND jbsupplier.id = jbitem.supplier;
/*
+-----+-----------------+------+-------+------+----------+----+--------------+------+
| id  | name            | dept | price | qoh  | supplier | id | name         | city |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
|  43 | Maze            |   49 |   325 |  200 |       89 | 89 | Fisher-Price |   21 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 | 89 | Fisher-Price |   21 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 | 89 | Fisher-Price |   21 |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
*/

/* Question 9 */
SELECT * FROM jbcity WHERE jbcity.id IN (SELECT jbsupplier.city FROM jbsupplier);
/*
+-----+----------------+-------+
| id  | name           | state |
+-----+----------------+-------+
|  10 | Amherst        | Mass  |
|  21 | Boston         | Mass  |
| 100 | New York       | NY    |
| 106 | White Plains   | Neb   |
| 118 | Hickville      | Okla  |
| 303 | Atlanta        | Ga    |
| 537 | Madison        | Wisc  |
| 609 | Paxton         | Ill   |
| 752 | Dallas         | Tex   |
| 802 | Denver         | Colo  |
| 841 | Salt Lake City | Utah  |
| 900 | Los Angeles    | Calif |
| 921 | San Diego      | Calif |
| 941 | San Francisco  | Calif |
| 981 | Seattle        | Wash  |
+-----+----------------+-------+
*/

/* Question 10 */
select * from jbparts where weight > (select weight from jbparts where name = 'card reader');
/*
+----+--------------+--------+--------+------+
| id | name         | color  | weight | qoh  |
+----+--------------+--------+--------+------+
|  3 | disk drive   | black  |    685 |    2 |
|  4 | tape drive   | black  |    450 |    4 |
|  6 | line printer | yellow |    578 |    3 |
| 12 | card punch   | gray   |    427 |    0 |
+----+--------------+--------+--------+------+
*/

/* Question 11 */
select a.name from jbparts a, jbparts b where a.weight > b.weight and b.name = 'card reader';
/*
--------------+
| name         |
+--------------+
| disk drive   |
| tape drive   |
| line printer |
| card punch   |
+--------------+
*/

/* Question 12 */
select avg(weight) from jbparts where color = 'black';
/*
+-------------+
| avg(weight) |
+-------------+
|    347.2500 |
*/

/* Question 13 */
select jbsupplier.name, SUM(jbparts.weight * jbsupply.quan) as total_weight from jbsupplier Join jbsupply On jbsupplier.id = jbsupply.supplier join jbparts on jbsupply.part = jbparts.id Where jbsupplier.city in (select id From jbcity where state = 'Mass') GROUP BY jbsupplier.id;
/* 
+--------------+--------------+
| name         | total_weight |
+--------------+--------------+
| Fisher-Price |      1135000 |
| DEC          |         3120 |
+--------------+--------------+
*/

/* Question 14 */
create table relation_between_jbitems(ID int NOT NULL, name varchar(255), dept int, price int, qoh int, supplier int);
insert into relation_between_jbitems select * from jbitem where price < (select avg(price) from jbitem);
alter table relation_between_jbitems primary_key(ID);
alter table relation_between_jbitems add foreign key (supplier) references jbsupplier(id);
alter table relation_between_jbitems add foreign key (dept) references jbdept(id);

/* Question 15 */
create view less_than_average select * from jbitem where price < (select avg(price) from jbitem);

/* Question 16 */
/* A view is static and is like a snapshot of the current table meanwhile a table is dynamic and can change at all times as long as the server is up.*/

/* Question 17 */
create view total_cost as select jbsale.debit, sum(jbitem.price * jbsale.quantity) as total_cost from jbsale, jbitem where jbsale.item = jbitem.id group by jbsale.debit;
/*
+--------+------------+
| debit  | total_cost |
+--------+------------+
| 100581 |       2050 |
| 100582 |       1000 |
| 100586 |      13446 |
| 100592 |        650 |
| 100593 |        430 |
| 100594 |       3295 |
+--------+------------+

*/

/* Question 18 */
CREATE VIEW total_cost AS SELECT jbsale.debit, SUM(jbitem.price * jbsale.quantity) AS total_cost_join FROM jbsale INNER JOIN jbite
/* +--------+------------+
| debit  | total_cost |
+--------+------------+
| 100581 |       2050 |
| 100582 |       1000 |
| 100586 |      13446 |
| 100592 |        650 |
| 100593 |        430 |
| 100594 |       3295 |
+--------+------------+

Here is INNER JOIN appropriate because we are only interested in the rows where there is a correspondig debit value for both jbsale and jbitem. 
INNER JOIN ensures this since it is the equivalent of an intersection in set theory. If there is sales records without corresponding items or vice versa those rows will be excluded.

*/

/* Question 19 */
delete from jbsale where item in (select id from jbitem where supplier in (select id from jbsupplier where city in (select id from jbcity where name = 'Los Angeles')));

delete from jbitem where supplier in (select id from jbsupplier where city in (select id from jbcity where name = 'Los Angeles'));

delete from relation_between_jbitems where supplier in (select id from jbsupplier where city in (select id from jbcity where name = 'Los Angeles'));

delete from jbsupplier where city in (select id from jbcity where name = 'Los Angeles');
/*
we did subqueries deletes to remove all neccessary data because foreign keys prevents us from removing data that can break our table.
*/
/* Question 20 */

CREATE VIEW jbsale_supply(supplier, item, quantity, qoh) AS
SELECT jbsupplier.name, jbitem.name, jbsale.quantity, jbitem.qoh
FROM jbsupplier
INNER JOIN jbitem ON jbsupplier.id = jbitem.supplier AND jbitem.qoh > 0
LEFT JOIN jbsale ON jbsale.item = jbitem.id;

SELECT supplier, sum(quantity) as sum, qoh as delivered_items FROM jbsale_supply GROUP BY supplier;

/*
+--------------+------+-----------------+
| supplier     | sum  | delivered_items |
+--------------+------+-----------------+
| Cannon       |    6 |             575 |
| Fisher-Price | NULL |             200 |
| Levi-Strauss |    1 |             600 |
| Playskool    |    2 |             405 |
| White Stag   |    4 |             300 |
| Whitman's    |    2 |             100 |
+--------------+------+-----------------+
*/