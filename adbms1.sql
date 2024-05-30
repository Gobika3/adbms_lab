 create table employees(
emp_id int primary key,
first_name varchar(20),
hourly_pay int,
job varchar(20)
);

insert into employees values(1,"xxx",100,"manager");
insert into employees values(2,"yyy",90,"cashier");
insert into employees values(3,"zzz",80,"cook");
insert into employees values(4,"eee",750,"teacher");
select * from employees;

alter table employees
add column salary decimal(10,2) after hourly_pay;
select * from employees;

update employees
set salary = hourly_pay * 2080;
select * from employees;

create trigger before_hourly_pay_update
before update on employees
for each row
set new.salary = (new.hourly_pay * 2080);
select * from employees;

show trigger;

 update employees
    -> set hourly_pay = 50
    -> where emp_id = 1;

update employees
    -> set hourly_pay = hourly_pay +1;

delete from employees
    -> where emp_id = 4;

 create trigger before_hourly_pay_insert
    -> before insert on employees
    -> for each row
    -> set new.salary = (new.hourly_pay * 2080);

insert into employees
    -> values(4, "aaa",290,null,"teacher")


select * from employees;
+--------+------------+------------+-----------+---------+
| emp_id | first_name | hourly_pay | salary    | job     |
+--------+------------+------------+-----------+---------+
|      1 | xxx        |         51 | 106080.00 | manager |
|      2 | yyy        |         91 | 189280.00 | cashier |
|      3 | zzz        |         81 | 168480.00 | cook    |
|      4 | aaa        |        290 | 603200.00 | teacher |
+--------+------------+------------+-----------+---------+


mysql> create table expenses(
    -> expense_id int primary key,
    -> expense_name varchar(50),
    -> expense_total decimal(10,2));

 insert into expenses
    -> values (1,"salaries",0),
    -> values (2,"supplies",0),
    -> values (3,"taxes", 0);


 update expenses
    -> set expense_total = (select sum(salary) from employees)
    -> where expense_name = "salaries";

select * from expenses;
+------------+--------------+---------------+
| expense_id | expense_name | expense_total |
+------------+--------------+---------------+
|          1 | salaries     |    1067040.00 |
|          2 | supplies     |          0.00 |
|          3 | taxes        |          0.00 |
+------------+--------------+---------------+

 create trigger after_salary_delete
    -> after delete on employees
    -> for each row
    -> update expenses
    -> set expense_total = expense_total - old.salary
    -> where expense_name = "salaries";

 delete from employees where emp_id = 3;

 select * from expenses;
+------------+--------------+---------------+
| expense_id | expense_name | expense_total |
+------------+--------------+---------------+
|          1 | salaries     |     898560.00 |
|          2 | supplies     |          0.00 |
|          3 | taxes        |          0.00 |
+------------+--------------+---------------+

create trigger after_salary_insert
    -> after insert on employees
    -> for each row
    -> update expenses
    -> set expense_total = expense_total + new.salary
    -> where expense_name = "salaries";

insert into employees values( 3, "jjj",180,null,"doctor");

 select * from expenses;
+------------+--------------+---------------+
| expense_id | expense_name | expense_total |
+------------+--------------+---------------+
|          1 | salaries     |    1272960.00 |
|          2 | supplies     |          0.00 |
|          3 | taxes        |          0.00 |
+------------+--------------+---------------+
