/*
Lab 2 report <Student_names and liu_id>
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS custom_table CASCADE;


/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;



/*
Question 1:
*/
select jbemployee.*
from jbemployee;
/*
+------+--------------------+--------+---------+-----------+-----------+
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
25 rows in set (0.01 sec)
*/ 


/*
Question 2:
*/
select jbdept.name
from jbdept order by jbdept.name;
/*
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
19 rows in set (0.00 sec)
*/


/*
Question 3:
*/
select jbparts.*
from jbparts
where jbparts.qoh=0;
/*
+----+-------------------+-------+--------+------+
| id | name              | color | weight | qoh  |
+----+-------------------+-------+--------+------+
| 11 | card reader       | gray  |    327 |    0 |
| 12 | card punch        | gray  |    427 |    0 |
| 13 | paper tape reader | black |    107 |    0 |
| 14 | paper tape punch  | black |    147 |    0 |
+----+-------------------+-------+--------+------+
4 rows in set (0.00 sec)
*/


/*
Question 4:
*/
select jbemployee.*
from jbemployee
where(jbemployee.salary >= 9000 and jbemployee.salary <= 10000);
/*
+-----+----------------+--------+---------+-----------+-----------+
| id  | name           | salary | manager | birthyear | startyear |
+-----+----------------+--------+---------+-----------+-----------+
|  13 | Edwards, Peter |   9000 |     199 |      1928 |      1958 |
|  32 | Smythe, Carol  |   9050 |     199 |      1929 |      1967 |
|  98 | Williams, Judy |   9000 |     199 |      1935 |      1969 |
| 129 | Thomas, Tom    |  10000 |     199 |      1941 |      1962 |
+-----+----------------+--------+---------+-----------+-----------+
4 rows in set (0.00 sec)
*/


/*
Question 5:
*/

select jbemployee.*, (jbemployee.startyear - jbemployee.birthyear) as startingYear
from jbemployee;
/*
+------+--------------------+--------+---------+-----------+-----------+--------------+
| id   | name               | salary | manager | birthyear | startyear | startingYear |
+------+--------------------+--------+---------+-----------+-----------+--------------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |           18 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |            1 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |           30 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |           40 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |           38 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |           32 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |           22 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |           24 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |           49 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |           34 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |           21 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |           20 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |            0 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |           21 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |           21 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |           20 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |           26 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |           21 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |           19 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |           21 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |           23 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |           19 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |           19 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |           24 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |           15 |
+------+--------------------+--------+---------+-----------+-----------+--------------+
25 rows in set (0.01 sec)
*/


/*
Question 6:
*/
select jbemployee.*
from jbemployee
where jbemployee.name like "%son,%";
/*
+----+---------------+--------+---------+-----------+-----------+
| id | name          | salary | manager | birthyear | startyear |
+----+---------------+--------+---------+-----------+-----------+
| 26 | Thompson, Bob |  13000 |     199 |      1930 |      1970 |
+----+---------------+--------+---------+-----------+-----------+
1 row in set (0.00 sec)
*/


/*
Question 7:
*/
select jbitem.*
from jbitem
where jbitem.supplier in 
(select jbsupplier.id from jbsupplier where jbsupplier.name = "Fisher-Price");
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
+-----+-----------------+------+-------+------+----------+
3 rows in set (0.00 sec)
*/


/*
Question 8:
*/
select jbitem.*
from jbitem left join jbsupplier on jbitem.supplier = jbsupplier.id
where jbsupplier.name = "Fisher-Price";
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
+-----+-----------------+------+-------+------+----------+
3 rows in set (0.01 sec)
*/


/*
Question 9:
*/
select jbcity.*
from jbcity
where jbcity.id in
(select jbsupplier.city from jbsupplier where jbsupplier.city = jbcity.id);
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
15 rows in set (0.00 sec)
*/


/*
Question 10:
*/
select jbparts.name, jbparts.color
from jbparts
where jbparts.weight >
(select jbparts.weight from jbparts where jbparts.name = "card reader");
/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)
*/



/*
Question 11:
*/
select x.name, x.color
from jbparts as x, jbparts as y
where x.weight > y.weight and y.name = "card reader";
/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)
*/


/*
Question 12:
*/
select avg(jbparts.weight)
from jbparts
where jbparts.color = "black";
/*
+---------------------+
| avg(jbparts.weight) |
+---------------------+
|            347.2500 |
+---------------------+
1 row in set (0.00 sec)
*/


/*
Question 13:
*/
select jbsupplier.name, sum(jbsupply.quan * jbparts.weight) as totalweight
from jbsupplier
join jbsupply on jbsupplier.id = jbsupply.supplier
join jbparts on jbsupply.part = jbparts.id 
join jbcity on jbsupplier.city = jbcity.id
where jbcity.state = "Mass"
group by jbsupplier.name;
/*
+--------------+-------------+
| name         | totalweight |
+--------------+-------------+
| DEC          |        3120 |
| Fisher-Price |     1135000 |
+--------------+-------------+
2 rows in set (0.00 sec)
*/


/*
Question 14:
*/
create table newjbitems
(id int primary key,
name varchar(100),
dept int,
price int,
qoh int,
supplier int,
foreign key(dept) references jbdept(id),
foreign key(supplier) references jbsupplier(id));
/*
Query OK, 0 rows affected (0.05 sec)
*/
insert into newjbitems select * from jbitem where jbitem.price < (select avg(jbitem.price) from jbitem);
/*
Query OK, 14 rows affected (0.00 sec)
Records: 14  Duplicates: 0  Warnings: 0
*/
select * from newjbitems;
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)
*/


/*
Question 15:
*/
create view jbitemview as
select * from jbitem where jbitem.price < 
(select avg(jbitem.price) from jbitem);
/*
Query OK, 0 rows affected (0.00 sec)
*/
select avg(jbitem.price) from jbitem;
/*
+-------------------+
| avg(jbitem.price) |
+-------------------+
|         1138.8000 |
+-------------------+
1 row in set (0.00 sec)
*/
select * from jbitemview;
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)
*/


/*
Question 16:
*/
/*
A table is static since it stores the data that will remain the same unless someone explicitly modifies it with some statement similar
to how we did in question 14 where we modified the table with insert.

A view is dynamic, you could say that it is a stored query, a select statement that has been saved in the database.
A view is dynamic since it will change and reflect the table its from.
It will essentially update itself to reflect the table it's from if the table is modified.


/*
Question 17:
*/
create view totaldebitcosts as
select jbsale.debit, SUM(jbitem.price * jbsale.quantity) as totalcost
from jbsale, jbitem
where jbsale.item = jbitem.id
group by jbsale.debit;
/*
Query OK, 0 rows affected (0.01 sec)
*/
select * from totaldebitcosts;
/*
+--------+-----------+
| debit  | totalcost |
+--------+-----------+
| 100581 |      2050 |
| 100582 |      1000 |
| 100586 |     13446 |
| 100592 |       650 |
| 100593 |       430 |
| 100594 |      3295 |
+--------+-----------+
6 rows in set (0.00 sec)
*/


/*
Question 18:
*/
create view totaldebitcosts2 as
select jbsale.debit, SUM(jbitem.price * jbsale.quantity) as totalcost
from jbsale
inner join jbitem on jbsale.item = jbitem.id
group by jbsale.debit;
/*
Query OK, 0 rows affected (0.00 sec)
*/
select * from totaldebitcosts2;
/*
+--------+-----------+
| debit  | totalcost |
+--------+-----------+
| 100581 |      2050 |
| 100582 |      1000 |
| 100586 |     13446 |
| 100592 |       650 |
| 100593 |       430 |
| 100594 |      3295 |
+--------+-----------+
6 rows in set (0.00 sec)
*/
/*
We used inner join since we think it's the best alternative for this case. 
Inner join is like taking the intersecting values between two sets.
And since we only want the rows where there is a corresponding debit value for both jbsale and jbitem, inner join is the correct
join statement to use for our case. 
*/


/*
Question 19:
*/
/*jbsale*/
delete jbsale from jbsale where jbsale.item in
(select jbitem.id from jbitem where jbitem.supplier in
(select jbsupplier.id from jbsupplier where jbsupplier.city in
(select jbcity.id from jbcity where jbcity.name = "Los Angeles")));
/*
Query OK, 1 row affected (0.01 sec)
*/
select * from jbsale;
/*
+--------+------+----------+
| debit  | item | quantity |
+--------+------+----------+
| 100581 |  118 |        5 |
| 100581 |  120 |        1 |
| 100586 |  106 |        2 |
| 100586 |  127 |        3 |
| 100592 |  258 |        1 |
| 100593 |   23 |        2 |
| 100594 |   52 |        1 |
+--------+------+----------+
7 rows in set (0.00 sec)
*/
/*jbitem*/
delete jbitem from jbitem where jbitem.supplier in
(select jbsupplier.id from jbsupplier where jbsupplier.city in
(select jbcity.id from jbcity where jbcity.name = "Los Angeles"));
/*
Query OK, 2 rows affected (0.00 sec)
*/
select * from jbitem;
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
|  52 | Jacket          |   60 |  3295 |  300 |       15 |
| 101 | Slacks          |   63 |  1600 |  325 |       15 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 121 | Queen Sheet     |   26 |  1375 |  600 |      213 |
| 127 | Ski Jumpsuit    |   65 |  4350 |  125 |       15 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
| 301 | Boy's Jean Suit |   43 |  1250 |  500 |       33 |
+-----+-----------------+------+-------+------+----------+
18 rows in set (0.00 sec)
*/
/*newjbitems*/
delete newjbitems from newjbitems where newjbitems.supplier in
(select jbsupplier.id from jbsupplier where jbsupplier.city in
(select jbcity.id from jbcity where jbcity.name = "Los Angeles"));
/*
Query OK, 1 row affected (0.01 sec)
*/
select * from newjbitems;
/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
13 rows in set (0.00 sec)
*/
/*jbsupplier*/
delete jbsupplier from jbsupplier where jbsupplier.city in
(select jbcity.id from jbcity where jbcity.name = "Los Angeles");
/*
Query OK, 1 row affected (0.00 sec)
*/
select * from jbsupplier;
/*
+-----+--------------+------+
| id  | name         | city |
+-----+--------------+------+
|   5 | Amdahl       |  921 |
|  15 | White Stag   |  106 |
|  20 | Wormley      |  118 |
|  33 | Levi-Strauss |  941 |
|  42 | Whitman's    |  802 |
|  62 | Data General |  303 |
|  67 | Edger        |  841 |
|  89 | Fisher-Price |   21 |
| 122 | White Paper  |  981 |
| 125 | Playskool    |  752 |
| 213 | Cannon       |  303 |
| 241 | IBM          |  100 |
| 440 | Spooley      |  609 |
| 475 | DEC          |   10 |
| 999 | A E Neumann  |  537 |
+-----+--------------+------+
15 rows in set (0.00 sec)
*/


/*
Question 20:
*/




