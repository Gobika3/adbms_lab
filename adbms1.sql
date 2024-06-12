## TRIGGER

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


##CURSOR
 
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
except mysql.connector.Error as err:
    print(f"Error: {err}")

# Close the connection
if connection.is_connected():
    connection.close()
    print("Connection closed")
Connection successful
Connection closed
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'lab',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to show tables
    cursor.execute("SHOW TABLES")
    
    # Fetch all rows from the result set
    tables = cursor.fetchall()
    
    # Print the names of all tables
    print("Tables in the database:")
    for table in tables:
        print(table[0])
    
    # You can also execute other queries here
    # For example, to fetch data from a specific table:
    # cursor.execute("SELECT * FROM your_table_name")
    # results = cursor.fetchall()
    # for row in results:
    #     print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
Tables in the database:
dept_sal_total
faculty
instructor
teaches
teaches2
Connection closed
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to insert data into the instructor table
    insert_query = """
    INSERT INTO instructor (ID, name, dept_name, salary) VALUES 
    (10101, 'Srinivasan', 'Comp. Sci.', 65000),
    (12121, 'Wu', 'Finance', 90000),
    (15151, 'Mozart', 'Music', 40000),
    (22222, 'Einstein', 'Physics', 95000),
    (32343, 'El Said', 'History', 60000),
    (33456, 'Gold', 'Physics', 87000),
    (45565, 'Katz', 'Comp. Sci.', 75000),
    (58583, 'Califieri', 'History', 62000),
    (76543, 'Singh', 'Finance', 80000),
    (76766, 'Crick', 'Biology', 72000),
    (83821, 'Brandt', 'Comp. Sci.', 92000),
    (98345, 'Kim', 'Elec. Eng.', 80000)
    """
    cursor.execute(insert_query)
    
    # Commit the transaction to save the changes
    connection.commit()
    
    print("Data inserted successfully")
    
    # Execute the SQL query to fetch and verify the inserted data
    cursor.execute("SELECT * FROM instructor")
    
    # Fetch all rows from the result set
    rows = cursor.fetchall()
    
    # Print the names of all columns
    column_headers = [i[0] for i in cursor.description]
    print(column_headers)
    
    # Print all rows in the instructor table
    for row in rows:
        print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
Data inserted successfully
['ID', 'name', 'dept_name', 'salary']
('10101', 'Srinivasan', 'Comp. Sci.', 65000)
('12121', 'Wu', 'Finance', 90000)
('15151', 'Mozart', 'Music', 40000)
('22222', 'Einstein', 'Physics', 95000)
('32343', 'El Said', 'History', 60000)
('33456', 'Gold', 'Physics', 87000)
('45565', 'Katz', 'Comp. Sci.', 75000)
('58583', 'Califieri', 'History', 62000)
('76543', 'Singh', 'Finance', 80000)
('76766', 'Crick', 'Biology', 72000)
('83821', 'Brandt', 'Comp. Sci.', 92000)
('98345', 'Kim', 'Elec. Eng.', 80000)
Connection closed
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to fetch all rows from the instructor table
    cursor.execute("SELECT * FROM instructor")
    
    # Fetch all rows from the result set
    rows = cursor.fetchall()
    
    # Print the column headers
    column_headers = [i[0] for i in cursor.description]
    print(column_headers)
    
    # Print all rows in the instructor table
    for row in rows:
        print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
['ID', 'name', 'dept_name', 'salary']
('10101', 'Srinivasan', 'Comp. Sci.', 65000)
('12121', 'Wu', 'Finance', 90000)
('15151', 'Mozart', 'Music', 40000)
('22222', 'Einstein', 'Physics', 95000)
('32343', 'El Said', 'History', 60000)
('33456', 'Gold', 'Physics', 87000)
('45565', 'Katz', 'Comp. Sci.', 75000)
('58583', 'Califieri', 'History', 62000)
('76543', 'Singh', 'Finance', 80000)
('76766', 'Crick', 'Biology', 72000)
('83821', 'Brandt', 'Comp. Sci.', 92000)
('98345', 'Kim', 'Elec. Eng.', 80000)
Connection closed
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to show tables
    cursor.execute("""CREATE TABLE teaches (
    ID VARCHAR(10),
    Course_id VARCHAR(10),
    sec_id INT,
    semester VARCHAR(10),
    year INT)""")
    
    # Fetch all rows from the result set
    tables = cursor.fetchall()
    
    # Print the names of all tables
    print("Tables in the database:")
    for table in tables:
        print(table[0])

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
Error: No result set to fetch from.
Connection closed
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to show tables
    cursor.execute("""INSERT INTO teaches (ID, Course_id, sec_id, semester, year) VALUES
    ('10101', 'CS-101', 1, 'Fall', 2017),
    ('10101', 'CS-315', 1, 'Spring', 2018),
    ('10101', 'CS-347', 1, 'Fall', 2017),
    ('12121', 'FIN-201', 1, 'Spring', 2018),
    ('15151', 'MU-199', 1, 'Spring', 2018),
    ('22222', 'PHY-101', 1, 'Fall', 2017),
    ('32343', 'HIS-351', 1, 'Spring', 2018),
    ('45565', 'CS-101', 1, 'Spring', 2018),
    ('45565', 'CS-319', 1, 'Spring', 2018),
    ('76766', 'BIO-101', 1, 'Summer', 2017),
    ('76766', 'BIO-301', 1, 'Summer', 2018),
    ('83821', 'CS-190', 1, 'Spring', 2017),
    ('83821', 'CS-190', 2, 'Spring', 2017),
    ('83821', 'CS-319', 2, 'Spring', 2018),
    ('98345', 'EE-181', 1, 'Spring', 2017);
    )""")
    
    # Fetch all rows from the result set
    tables = cursor.fetchall()
    
    # Print the names of all tables
    print("Tables in the database:")
    for table in tables:
        print(table[0])

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
Error: Use multi=True when executing multiple statements
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to insert data into the instructor table
    insert_query = """
    INSERT INTO teaches (ID, Course_id, sec_id, semester, year) VALUES
('10101', 'CS-101', 1, 'Fall', 2017),
('10101', 'CS-315', 1, 'Spring', 2018),
('10101', 'CS-347', 1, 'Fall', 2017),
('12121', 'FIN-201', 1, 'Spring', 2018),
('15151', 'MU-199', 1, 'Spring', 2018),
('22222', 'PHY-101', 1, 'Fall', 2017),
('32343', 'HIS-351', 1, 'Spring', 2018),
('45565', 'CS-101', 1, 'Spring', 2018),
('45565', 'CS-319', 1, 'Spring', 2018),
('76766', 'BIO-101', 1, 'Summer', 2017),
('76766', 'BIO-301', 1, 'Summer', 2018),
('83821', 'CS-190', 1, 'Spring', 2017),
('83821', 'CS-190', 2, 'Spring', 2017),
('83821', 'CS-319', 2, 'Spring', 2018),
('98345', 'EE-181', 1, 'Spring', 2017);
    """
    cursor.execute(insert_query)
    
    # Commit the transaction to save the changes
    connection.commit()
    
    print("Data inserted successfully")
    
    # Execute the SQL query to fetch and verify the inserted data
    cursor.execute("SELECT * FROM instructor")
    
    # Fetch all rows from the result set
    rows = cursor.fetchall()
    
    # Print the names of all columns
    column_headers = [i[0] for i in cursor.description]
    print(column_headers)
    
    # Print all rows in the instructor table
    for row in rows:
        print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
Data inserted successfully
['ID', 'name', 'dept_name', 'salary']
('10101', 'Srinivasan', 'Comp. Sci.', 65000)
('12121', 'Wu', 'Finance', 90000)
('15151', 'Mozart', 'Music', 40000)
('22222', 'Einstein', 'Physics', 95000)
('32343', 'El Said', 'History', 60000)
('33456', 'Gold', 'Physics', 87000)
('45565', 'Katz', 'Comp. Sci.', 75000)
('58583', 'Califieri', 'History', 62000)
('76543', 'Singh', 'Finance', 80000)
('76766', 'Crick', 'Biology', 72000)
('83821', 'Brandt', 'Comp. Sci.', 92000)
('98345', 'Kim', 'Elec. Eng.', 80000)
Connection closed
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to insert data into the instructor table
    insert_query = """
    INSERT INTO instructor VALUES ('10211', 'Smith', 'Biology', 66000)"""
    cursor.execute(insert_query)
    
    # Commit the transaction to save the changes
    connection.commit()
    
    print("Data inserted successfully")
    
    # Execute the SQL query to fetch and verify the inserted data
    cursor.execute("SELECT * FROM instructor")
    
    # Fetch all rows from the result set
    rows = cursor.fetchall()
    
    # Print the names of all columns
    column_headers = [i[0] for i in cursor.description]
    print(column_headers)
    
    # Print all rows in the instructor table
    for row in rows:
        print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
Data inserted successfully
['ID', 'name', 'dept_name', 'salary']
('10101', 'Srinivasan', 'Comp. Sci.', 65000)
('10211', 'Smith', 'Biology', 66000)
('12121', 'Wu', 'Finance', 90000)
('15151', 'Mozart', 'Music', 40000)
('22222', 'Einstein', 'Physics', 95000)
('32343', 'El Said', 'History', 60000)
('33456', 'Gold', 'Physics', 87000)
('45565', 'Katz', 'Comp. Sci.', 75000)
('58583', 'Califieri', 'History', 62000)
('76543', 'Singh', 'Finance', 80000)
('76766', 'Crick', 'Biology', 72000)
('83821', 'Brandt', 'Comp. Sci.', 92000)
('98345', 'Kim', 'Elec. Eng.', 80000)
Connection closed
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to fetch all rows from the instructor table
    cursor.execute("""SELECT * FROM instructor""")
    
    # Fetch all rows from the result set
    rows = cursor.fetchall()
    
    # Print the column headers
    column_headers = [i[0] for i in cursor.description]
    print(column_headers)
    
    # Print all rows in the instructor table
    for row in rows:
        print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
['ID', 'name', 'dept_name', 'salary']
('10101', 'Srinivasan', 'Comp. Sci.', 65000)
('10211', 'Smith', 'Biology', 66000)
('12121', 'Wu', 'Finance', 90000)
('15151', 'Mozart', 'Music', 40000)
('22222', 'Einstein', 'Physics', 95000)
('32343', 'El Said', 'History', 60000)
('33456', 'Gold', 'Physics', 87000)
('45565', 'Katz', 'Comp. Sci.', 75000)
('58583', 'Califieri', 'History', 62000)
('76543', 'Singh', 'Finance', 80000)
('76766', 'Crick', 'Biology', 72000)
('83821', 'Brandt', 'Comp. Sci.', 92000)
('98345', 'Kim', 'Elec. Eng.', 80000)
Connection closed
import mysql.connector

# Connection parameters
config = {
    'user': 'root',
    'password': 'Gobika',
    'host': 'localhost',
    'database': 'adbs',
    'ssl_disabled': True
}

# Establish a connection
try:
    connection = mysql.connector.connect(**config)
    print("Connection successful")
    
    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()
    
    # Execute the SQL query to insert data into the instructor table
    insert_query = """DELETE FROM instructor WHERE ID = 10211; """
    cursor.execute(insert_query)
    
    # Commit the transaction to save the changes
    connection.commit()
    
    # Execute the SQL query to fetch and verify the inserted data
    cursor.execute("SELECT * FROM instructor")
    
    # Fetch all rows from the result set
    rows = cursor.fetchall()
    
    # Print the names of all columns
    column_headers = [i[0] for i in cursor.description]
    print(column_headers)
    
    # Print all rows in the instructor table
    for row in rows:
        print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and the connection
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Connection closed")
Connection successful
['ID', 'name', 'dept_name', 'salary']
('10101', 'Srinivasan', 'Comp. Sci.', 65000)
('12121', 'Wu', 'Finance', 90000)
('15151', 'Mozart', 'Music', 40000)
('22222', 'Einstein', 'Physics', 95000)
('32343', 'El Said', 'History', 60000)
('33456', 'Gold', 'Physics', 87000)
('45565', 'Katz', 'Comp. Sci.', 75000)
('58583', 'Califieri', 'History', 62000)
('76543', 'Singh', 'Finance', 80000)
('76766', 'Crick', 'Biology', 72000)
('83821', 'Brandt', 'Comp. Sci.', 92000)
('98345', 'Kim', 'Elec. Eng.', 80000)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM instructor WHERE dept_name = 'History';"
execute_query(sql_query)
Connection successful
['ID', 'name', 'dept_name', 'salary']
('32343', 'El Said', 'History', 60000)
('58583', 'Califieri', 'History', 62000)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM instructor, teaches"
execute_query(sql_query)
Connection successful
['ID', 'name', 'dept_name', 'salary', 'ID', 'Course_id', 'sec_id', 'semester', 'year']
('98345', 'Kim', 'Elec. Eng.', 80000, '10101', 'CS-101', 1, 'Fall', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '10101', 'CS-101', 1, 'Fall', 2017)
('76766', 'Crick', 'Biology', 72000, '10101', 'CS-101', 1, 'Fall', 2017)
('76543', 'Singh', 'Finance', 80000, '10101', 'CS-101', 1, 'Fall', 2017)
('58583', 'Califieri', 'History', 62000, '10101', 'CS-101', 1, 'Fall', 2017)
('45565', 'Katz', 'Comp. Sci.', 75000, '10101', 'CS-101', 1, 'Fall', 2017)
('33456', 'Gold', 'Physics', 87000, '10101', 'CS-101', 1, 'Fall', 2017)
('32343', 'El Said', 'History', 60000, '10101', 'CS-101', 1, 'Fall', 2017)
('22222', 'Einstein', 'Physics', 95000, '10101', 'CS-101', 1, 'Fall', 2017)
('15151', 'Mozart', 'Music', 40000, '10101', 'CS-101', 1, 'Fall', 2017)
('12121', 'Wu', 'Finance', 90000, '10101', 'CS-101', 1, 'Fall', 2017)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '10101', 'CS-101', 1, 'Fall', 2017)
('98345', 'Kim', 'Elec. Eng.', 80000, '10101', 'CS-315', 1, 'Spring', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '10101', 'CS-315', 1, 'Spring', 2018)
('76766', 'Crick', 'Biology', 72000, '10101', 'CS-315', 1, 'Spring', 2018)
('76543', 'Singh', 'Finance', 80000, '10101', 'CS-315', 1, 'Spring', 2018)
('58583', 'Califieri', 'History', 62000, '10101', 'CS-315', 1, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '10101', 'CS-315', 1, 'Spring', 2018)
('33456', 'Gold', 'Physics', 87000, '10101', 'CS-315', 1, 'Spring', 2018)
('32343', 'El Said', 'History', 60000, '10101', 'CS-315', 1, 'Spring', 2018)
('22222', 'Einstein', 'Physics', 95000, '10101', 'CS-315', 1, 'Spring', 2018)
('15151', 'Mozart', 'Music', 40000, '10101', 'CS-315', 1, 'Spring', 2018)
('12121', 'Wu', 'Finance', 90000, '10101', 'CS-315', 1, 'Spring', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '10101', 'CS-315', 1, 'Spring', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '10101', 'CS-347', 1, 'Fall', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '10101', 'CS-347', 1, 'Fall', 2017)
('76766', 'Crick', 'Biology', 72000, '10101', 'CS-347', 1, 'Fall', 2017)
('76543', 'Singh', 'Finance', 80000, '10101', 'CS-347', 1, 'Fall', 2017)
('58583', 'Califieri', 'History', 62000, '10101', 'CS-347', 1, 'Fall', 2017)
('45565', 'Katz', 'Comp. Sci.', 75000, '10101', 'CS-347', 1, 'Fall', 2017)
('33456', 'Gold', 'Physics', 87000, '10101', 'CS-347', 1, 'Fall', 2017)
('32343', 'El Said', 'History', 60000, '10101', 'CS-347', 1, 'Fall', 2017)
('22222', 'Einstein', 'Physics', 95000, '10101', 'CS-347', 1, 'Fall', 2017)
('15151', 'Mozart', 'Music', 40000, '10101', 'CS-347', 1, 'Fall', 2017)
('12121', 'Wu', 'Finance', 90000, '10101', 'CS-347', 1, 'Fall', 2017)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '10101', 'CS-347', 1, 'Fall', 2017)
('98345', 'Kim', 'Elec. Eng.', 80000, '12121', 'FIN-201', 1, 'Spring', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '12121', 'FIN-201', 1, 'Spring', 2018)
('76766', 'Crick', 'Biology', 72000, '12121', 'FIN-201', 1, 'Spring', 2018)
('76543', 'Singh', 'Finance', 80000, '12121', 'FIN-201', 1, 'Spring', 2018)
('58583', 'Califieri', 'History', 62000, '12121', 'FIN-201', 1, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '12121', 'FIN-201', 1, 'Spring', 2018)
('33456', 'Gold', 'Physics', 87000, '12121', 'FIN-201', 1, 'Spring', 2018)
('32343', 'El Said', 'History', 60000, '12121', 'FIN-201', 1, 'Spring', 2018)
('22222', 'Einstein', 'Physics', 95000, '12121', 'FIN-201', 1, 'Spring', 2018)
('15151', 'Mozart', 'Music', 40000, '12121', 'FIN-201', 1, 'Spring', 2018)
('12121', 'Wu', 'Finance', 90000, '12121', 'FIN-201', 1, 'Spring', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '12121', 'FIN-201', 1, 'Spring', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '15151', 'MU-199', 1, 'Spring', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '15151', 'MU-199', 1, 'Spring', 2018)
('76766', 'Crick', 'Biology', 72000, '15151', 'MU-199', 1, 'Spring', 2018)
('76543', 'Singh', 'Finance', 80000, '15151', 'MU-199', 1, 'Spring', 2018)
('58583', 'Califieri', 'History', 62000, '15151', 'MU-199', 1, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '15151', 'MU-199', 1, 'Spring', 2018)
('33456', 'Gold', 'Physics', 87000, '15151', 'MU-199', 1, 'Spring', 2018)
('32343', 'El Said', 'History', 60000, '15151', 'MU-199', 1, 'Spring', 2018)
('22222', 'Einstein', 'Physics', 95000, '15151', 'MU-199', 1, 'Spring', 2018)
('15151', 'Mozart', 'Music', 40000, '15151', 'MU-199', 1, 'Spring', 2018)
('12121', 'Wu', 'Finance', 90000, '15151', 'MU-199', 1, 'Spring', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '15151', 'MU-199', 1, 'Spring', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '22222', 'PHY-101', 1, 'Fall', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '22222', 'PHY-101', 1, 'Fall', 2017)
('76766', 'Crick', 'Biology', 72000, '22222', 'PHY-101', 1, 'Fall', 2017)
('76543', 'Singh', 'Finance', 80000, '22222', 'PHY-101', 1, 'Fall', 2017)
('58583', 'Califieri', 'History', 62000, '22222', 'PHY-101', 1, 'Fall', 2017)
('45565', 'Katz', 'Comp. Sci.', 75000, '22222', 'PHY-101', 1, 'Fall', 2017)
('33456', 'Gold', 'Physics', 87000, '22222', 'PHY-101', 1, 'Fall', 2017)
('32343', 'El Said', 'History', 60000, '22222', 'PHY-101', 1, 'Fall', 2017)
('22222', 'Einstein', 'Physics', 95000, '22222', 'PHY-101', 1, 'Fall', 2017)
('15151', 'Mozart', 'Music', 40000, '22222', 'PHY-101', 1, 'Fall', 2017)
('12121', 'Wu', 'Finance', 90000, '22222', 'PHY-101', 1, 'Fall', 2017)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '22222', 'PHY-101', 1, 'Fall', 2017)
('98345', 'Kim', 'Elec. Eng.', 80000, '32343', 'HIS-351', 1, 'Spring', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '32343', 'HIS-351', 1, 'Spring', 2018)
('76766', 'Crick', 'Biology', 72000, '32343', 'HIS-351', 1, 'Spring', 2018)
('76543', 'Singh', 'Finance', 80000, '32343', 'HIS-351', 1, 'Spring', 2018)
('58583', 'Califieri', 'History', 62000, '32343', 'HIS-351', 1, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '32343', 'HIS-351', 1, 'Spring', 2018)
('33456', 'Gold', 'Physics', 87000, '32343', 'HIS-351', 1, 'Spring', 2018)
('32343', 'El Said', 'History', 60000, '32343', 'HIS-351', 1, 'Spring', 2018)
('22222', 'Einstein', 'Physics', 95000, '32343', 'HIS-351', 1, 'Spring', 2018)
('15151', 'Mozart', 'Music', 40000, '32343', 'HIS-351', 1, 'Spring', 2018)
('12121', 'Wu', 'Finance', 90000, '32343', 'HIS-351', 1, 'Spring', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '32343', 'HIS-351', 1, 'Spring', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '45565', 'CS-101', 1, 'Spring', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '45565', 'CS-101', 1, 'Spring', 2018)
('76766', 'Crick', 'Biology', 72000, '45565', 'CS-101', 1, 'Spring', 2018)
('76543', 'Singh', 'Finance', 80000, '45565', 'CS-101', 1, 'Spring', 2018)
('58583', 'Califieri', 'History', 62000, '45565', 'CS-101', 1, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '45565', 'CS-101', 1, 'Spring', 2018)
('33456', 'Gold', 'Physics', 87000, '45565', 'CS-101', 1, 'Spring', 2018)
('32343', 'El Said', 'History', 60000, '45565', 'CS-101', 1, 'Spring', 2018)
('22222', 'Einstein', 'Physics', 95000, '45565', 'CS-101', 1, 'Spring', 2018)
('15151', 'Mozart', 'Music', 40000, '45565', 'CS-101', 1, 'Spring', 2018)
('12121', 'Wu', 'Finance', 90000, '45565', 'CS-101', 1, 'Spring', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '45565', 'CS-101', 1, 'Spring', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '45565', 'CS-319', 1, 'Spring', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '45565', 'CS-319', 1, 'Spring', 2018)
('76766', 'Crick', 'Biology', 72000, '45565', 'CS-319', 1, 'Spring', 2018)
('76543', 'Singh', 'Finance', 80000, '45565', 'CS-319', 1, 'Spring', 2018)
('58583', 'Califieri', 'History', 62000, '45565', 'CS-319', 1, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '45565', 'CS-319', 1, 'Spring', 2018)
('33456', 'Gold', 'Physics', 87000, '45565', 'CS-319', 1, 'Spring', 2018)
('32343', 'El Said', 'History', 60000, '45565', 'CS-319', 1, 'Spring', 2018)
('22222', 'Einstein', 'Physics', 95000, '45565', 'CS-319', 1, 'Spring', 2018)
('15151', 'Mozart', 'Music', 40000, '45565', 'CS-319', 1, 'Spring', 2018)
('12121', 'Wu', 'Finance', 90000, '45565', 'CS-319', 1, 'Spring', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '45565', 'CS-319', 1, 'Spring', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '76766', 'BIO-101', 1, 'Summer', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '76766', 'BIO-101', 1, 'Summer', 2017)
('76766', 'Crick', 'Biology', 72000, '76766', 'BIO-101', 1, 'Summer', 2017)
('76543', 'Singh', 'Finance', 80000, '76766', 'BIO-101', 1, 'Summer', 2017)
('58583', 'Califieri', 'History', 62000, '76766', 'BIO-101', 1, 'Summer', 2017)
('45565', 'Katz', 'Comp. Sci.', 75000, '76766', 'BIO-101', 1, 'Summer', 2017)
('33456', 'Gold', 'Physics', 87000, '76766', 'BIO-101', 1, 'Summer', 2017)
('32343', 'El Said', 'History', 60000, '76766', 'BIO-101', 1, 'Summer', 2017)
('22222', 'Einstein', 'Physics', 95000, '76766', 'BIO-101', 1, 'Summer', 2017)
('15151', 'Mozart', 'Music', 40000, '76766', 'BIO-101', 1, 'Summer', 2017)
('12121', 'Wu', 'Finance', 90000, '76766', 'BIO-101', 1, 'Summer', 2017)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '76766', 'BIO-101', 1, 'Summer', 2017)
('98345', 'Kim', 'Elec. Eng.', 80000, '76766', 'BIO-301', 1, 'Summer', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '76766', 'BIO-301', 1, 'Summer', 2018)
('76766', 'Crick', 'Biology', 72000, '76766', 'BIO-301', 1, 'Summer', 2018)
('76543', 'Singh', 'Finance', 80000, '76766', 'BIO-301', 1, 'Summer', 2018)
('58583', 'Califieri', 'History', 62000, '76766', 'BIO-301', 1, 'Summer', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '76766', 'BIO-301', 1, 'Summer', 2018)
('33456', 'Gold', 'Physics', 87000, '76766', 'BIO-301', 1, 'Summer', 2018)
('32343', 'El Said', 'History', 60000, '76766', 'BIO-301', 1, 'Summer', 2018)
('22222', 'Einstein', 'Physics', 95000, '76766', 'BIO-301', 1, 'Summer', 2018)
('15151', 'Mozart', 'Music', 40000, '76766', 'BIO-301', 1, 'Summer', 2018)
('12121', 'Wu', 'Finance', 90000, '76766', 'BIO-301', 1, 'Summer', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '76766', 'BIO-301', 1, 'Summer', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '83821', 'CS-190', 1, 'Spring', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '83821', 'CS-190', 1, 'Spring', 2017)
('76766', 'Crick', 'Biology', 72000, '83821', 'CS-190', 1, 'Spring', 2017)
('76543', 'Singh', 'Finance', 80000, '83821', 'CS-190', 1, 'Spring', 2017)
('58583', 'Califieri', 'History', 62000, '83821', 'CS-190', 1, 'Spring', 2017)
('45565', 'Katz', 'Comp. Sci.', 75000, '83821', 'CS-190', 1, 'Spring', 2017)
('33456', 'Gold', 'Physics', 87000, '83821', 'CS-190', 1, 'Spring', 2017)
('32343', 'El Said', 'History', 60000, '83821', 'CS-190', 1, 'Spring', 2017)
('22222', 'Einstein', 'Physics', 95000, '83821', 'CS-190', 1, 'Spring', 2017)
('15151', 'Mozart', 'Music', 40000, '83821', 'CS-190', 1, 'Spring', 2017)
('12121', 'Wu', 'Finance', 90000, '83821', 'CS-190', 1, 'Spring', 2017)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '83821', 'CS-190', 1, 'Spring', 2017)
('98345', 'Kim', 'Elec. Eng.', 80000, '83821', 'CS-190', 2, 'Spring', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '83821', 'CS-190', 2, 'Spring', 2017)
('76766', 'Crick', 'Biology', 72000, '83821', 'CS-190', 2, 'Spring', 2017)
('76543', 'Singh', 'Finance', 80000, '83821', 'CS-190', 2, 'Spring', 2017)
('58583', 'Califieri', 'History', 62000, '83821', 'CS-190', 2, 'Spring', 2017)
('45565', 'Katz', 'Comp. Sci.', 75000, '83821', 'CS-190', 2, 'Spring', 2017)
('33456', 'Gold', 'Physics', 87000, '83821', 'CS-190', 2, 'Spring', 2017)
('32343', 'El Said', 'History', 60000, '83821', 'CS-190', 2, 'Spring', 2017)
('22222', 'Einstein', 'Physics', 95000, '83821', 'CS-190', 2, 'Spring', 2017)
('15151', 'Mozart', 'Music', 40000, '83821', 'CS-190', 2, 'Spring', 2017)
('12121', 'Wu', 'Finance', 90000, '83821', 'CS-190', 2, 'Spring', 2017)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '83821', 'CS-190', 2, 'Spring', 2017)
('98345', 'Kim', 'Elec. Eng.', 80000, '83821', 'CS-319', 2, 'Spring', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '83821', 'CS-319', 2, 'Spring', 2018)
('76766', 'Crick', 'Biology', 72000, '83821', 'CS-319', 2, 'Spring', 2018)
('76543', 'Singh', 'Finance', 80000, '83821', 'CS-319', 2, 'Spring', 2018)
('58583', 'Califieri', 'History', 62000, '83821', 'CS-319', 2, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '83821', 'CS-319', 2, 'Spring', 2018)
('33456', 'Gold', 'Physics', 87000, '83821', 'CS-319', 2, 'Spring', 2018)
('32343', 'El Said', 'History', 60000, '83821', 'CS-319', 2, 'Spring', 2018)
('22222', 'Einstein', 'Physics', 95000, '83821', 'CS-319', 2, 'Spring', 2018)
('15151', 'Mozart', 'Music', 40000, '83821', 'CS-319', 2, 'Spring', 2018)
('12121', 'Wu', 'Finance', 90000, '83821', 'CS-319', 2, 'Spring', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '83821', 'CS-319', 2, 'Spring', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '98345', 'EE-181', 1, 'Spring', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '98345', 'EE-181', 1, 'Spring', 2017)
('76766', 'Crick', 'Biology', 72000, '98345', 'EE-181', 1, 'Spring', 2017)
('76543', 'Singh', 'Finance', 80000, '98345', 'EE-181', 1, 'Spring', 2017)
('58583', 'Califieri', 'History', 62000, '98345', 'EE-181', 1, 'Spring', 2017)
('45565', 'Katz', 'Comp. Sci.', 75000, '98345', 'EE-181', 1, 'Spring', 2017)
('33456', 'Gold', 'Physics', 87000, '98345', 'EE-181', 1, 'Spring', 2017)
('32343', 'El Said', 'History', 60000, '98345', 'EE-181', 1, 'Spring', 2017)
('22222', 'Einstein', 'Physics', 95000, '98345', 'EE-181', 1, 'Spring', 2017)
('15151', 'Mozart', 'Music', 40000, '98345', 'EE-181', 1, 'Spring', 2017)
('12121', 'Wu', 'Finance', 90000, '98345', 'EE-181', 1, 'Spring', 2017)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '98345', 'EE-181', 1, 'Spring', 2017)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM instructor, teaches WHERE instructor.ID = teaches.ID"
execute_query(sql_query)
Connection successful
['ID', 'name', 'dept_name', 'salary', 'ID', 'Course_id', 'sec_id', 'semester', 'year']
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '10101', 'CS-101', 1, 'Fall', 2017)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '10101', 'CS-315', 1, 'Spring', 2018)
('10101', 'Srinivasan', 'Comp. Sci.', 65000, '10101', 'CS-347', 1, 'Fall', 2017)
('12121', 'Wu', 'Finance', 90000, '12121', 'FIN-201', 1, 'Spring', 2018)
('15151', 'Mozart', 'Music', 40000, '15151', 'MU-199', 1, 'Spring', 2018)
('22222', 'Einstein', 'Physics', 95000, '22222', 'PHY-101', 1, 'Fall', 2017)
('32343', 'El Said', 'History', 60000, '32343', 'HIS-351', 1, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '45565', 'CS-101', 1, 'Spring', 2018)
('45565', 'Katz', 'Comp. Sci.', 75000, '45565', 'CS-319', 1, 'Spring', 2018)
('76766', 'Crick', 'Biology', 72000, '76766', 'BIO-101', 1, 'Summer', 2017)
('76766', 'Crick', 'Biology', 72000, '76766', 'BIO-301', 1, 'Summer', 2018)
('83821', 'Brandt', 'Comp. Sci.', 92000, '83821', 'CS-190', 1, 'Spring', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '83821', 'CS-190', 2, 'Spring', 2017)
('83821', 'Brandt', 'Comp. Sci.', 92000, '83821', 'CS-319', 2, 'Spring', 2018)
('98345', 'Kim', 'Elec. Eng.', 80000, '98345', 'EE-181', 1, 'Spring', 2017)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM instructor WHERE name LIKE '%dar%'"
execute_query(sql_query)
Connection successful
['ID', 'name', 'dept_name', 'salary']
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT name FROM instructor WHERE salary>= 90000 AND salary <=100000"
execute_query(sql_query)
Connection successful
['name']
('Wu',)
('Einstein',)
('Brandt',)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM instructor ORDER BY salary"
execute_query(sql_query)
Connection successful
['ID', 'name', 'dept_name', 'salary']
('15151', 'Mozart', 'Music', 40000)
('32343', 'El Said', 'History', 60000)
('58583', 'Califieri', 'History', 62000)
('10101', 'Srinivasan', 'Comp. Sci.', 65000)
('76766', 'Crick', 'Biology', 72000)
('45565', 'Katz', 'Comp. Sci.', 75000)
('76543', 'Singh', 'Finance', 80000)
('98345', 'Kim', 'Elec. Eng.', 80000)
('33456', 'Gold', 'Physics', 87000)
('12121', 'Wu', 'Finance', 90000)
('83821', 'Brandt', 'Comp. Sci.', 92000)
('22222', 'Einstein', 'Physics', 95000)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM teaches WHERE (semester = 'Fall' AND year = 2017) OR (semester = 'Spring' AND year = 2018)"
execute_query(sql_query)
Connection successful
['ID', 'Course_id', 'sec_id', 'semester', 'year']
('10101', 'CS-101', 1, 'Fall', 2017)
('10101', 'CS-315', 1, 'Spring', 2018)
('10101', 'CS-347', 1, 'Fall', 2017)
('12121', 'FIN-201', 1, 'Spring', 2018)
('15151', 'MU-199', 1, 'Spring', 2018)
('22222', 'PHY-101', 1, 'Fall', 2017)
('32343', 'HIS-351', 1, 'Spring', 2018)
('45565', 'CS-101', 1, 'Spring', 2018)
('45565', 'CS-319', 1, 'Spring', 2018)
('83821', 'CS-319', 2, 'Spring', 2018)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM teaches WHERE (semester = 'Fall' AND year = 2017) OR (semester = 'Spring' AND year = 2018)"
execute_query(sql_query)
Connection successful
['ID', 'Course_id', 'sec_id', 'semester', 'year']
('10101', 'CS-101', 1, 'Fall', 2017)
('10101', 'CS-315', 1, 'Spring', 2018)
('10101', 'CS-347', 1, 'Fall', 2017)
('12121', 'FIN-201', 1, 'Spring', 2018)
('15151', 'MU-199', 1, 'Spring', 2018)
('22222', 'PHY-101', 1, 'Fall', 2017)
('32343', 'HIS-351', 1, 'Spring', 2018)
('45565', 'CS-101', 1, 'Spring', 2018)
('45565', 'CS-319', 1, 'Spring', 2018)
('83821', 'CS-319', 2, 'Spring', 2018)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM teaches WHERE (semester = 'Fall' AND year = 2017) AND NOT (semester = 'Spring' AND year = 2018)"
execute_query(sql_query)
Connection successful
['ID', 'Course_id', 'sec_id', 'semester', 'year']
('10101', 'CS-101', 1, 'Fall', 2017)
('10101', 'CS-347', 1, 'Fall', 2017)
('22222', 'PHY-101', 1, 'Fall', 2017)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = """	INSERT INTO instructor VALUES (10212, 'Tom', 'Biology', NULL)"""
execute_query(sql_query)
Connection successful
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT DISTINCT avg(salary) FROM instructor WHERE dept_name = 'Comp Sci.'"
execute_query(sql_query)
Connection successful
['avg(salary)']
(None,)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT count(ID) as total_teachers FROM teaches WHERE semester = 'Spring' AND year = 2018"
execute_query(sql_query)
Connection successful
['total_teachers']
(7,)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT count(ID) FROM teaches"
execute_query(sql_query)
Connection successful
['count(ID)']
(15,)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT dept_name, avg(salary) as avg_salary FROM instructor GROUP BY dept_name"
execute_query(sql_query)
Connection successful
['dept_name', 'avg_salary']
('Comp. Sci.', Decimal('77333.3333'))
('Finance', Decimal('85000.0000'))
('Music', Decimal('40000.0000'))
('Physics', Decimal('91000.0000'))
('History', Decimal('61000.0000'))
('Biology', Decimal('72000.0000'))
('Elec. Eng.', Decimal('80000.0000'))
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT dept_name, avg(salary) as avg_salary FROM instructor GROUP BY dept_name HAVING avg_salary > 42000"
execute_query(sql_query)
Connection successful
['dept_name', 'avg_salary']
('Comp. Sci.', Decimal('77333.3333'))
('Finance', Decimal('85000.0000'))
('Physics', Decimal('91000.0000'))
('History', Decimal('61000.0000'))
('Biology', Decimal('72000.0000'))
('Elec. Eng.', Decimal('80000.0000'))
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT * FROM instructor WHERE name = 'Mozart' OR name = 'Einstein'"
execute_query(sql_query)
Connection successful
['ID', 'name', 'dept_name', 'salary']
('15151', 'Mozart', 'Music', 40000)
('22222', 'Einstein', 'Physics', 95000)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT name FROM instructor WHERE salary > (SELECT MIN(salary) FROM instructor WHERE dept_name = 'Biology'); "
execute_query(sql_query)
Connection successful
['name']
('Wu',)
('Einstein',)
('Gold',)
('Katz',)
('Singh',)
('Brandt',)
('Kim',)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT name FROM instructor WHERE salary > (SELECT MAX(salary) FROM instructor WHERE dept_name = 'Biology');  "
execute_query(sql_query)
Connection successful
['name']
('Wu',)
('Einstein',)
('Gold',)
('Katz',)
('Singh',)
('Brandt',)
('Kim',)
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT avg(salary) as avg_salary, dept_name FROM instructor GROUP BY dept_name HAVING avg_salary > 42000; "
execute_query(sql_query)
Connection successful
['avg_salary', 'dept_name']
(Decimal('77333.3333'), 'Comp. Sci.')
(Decimal('85000.0000'), 'Finance')
(Decimal('91000.0000'), 'Physics')
(Decimal('61000.0000'), 'History')
(Decimal('72000.0000'), 'Biology')
(Decimal('80000.0000'), 'Elec. Eng.')
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT dept_name FROM instructor GROUP BY dept_name HAVING SUM(salary) > (SELECT AVG(total_salary) FROM (SELECT SUM(salary) as total_salary FROM instructor) as avg_salary); "
execute_query(sql_query)
Connection successful
['dept_name']
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT name, course_id FROM instructor, teaches WHERE instructor.ID = teaches.ID"
execute_query(sql_query)
Connection successful
['name', 'course_id']
('Srinivasan', 'CS-101')
('Srinivasan', 'CS-315')
('Srinivasan', 'CS-347')
('Wu', 'FIN-201')
('Mozart', 'MU-199')
('Einstein', 'PHY-101')
('El Said', 'HIS-351')
('Katz', 'CS-101')
('Katz', 'CS-319')
('Crick', 'BIO-101')
('Crick', 'BIO-301')
('Brandt', 'CS-190')
('Brandt', 'CS-190')
('Brandt', 'CS-319')
('Kim', 'EE-181')
Connection closed
import mysql.connector

def execute_query(query):
    # Connection parameters
    config = {
        'user': 'root',
        'password': 'Gobika',
        'host': 'localhost',
        'database': 'adbs',
        'ssl_disabled': True
    }
    
    try:
        # Establish a connection
        connection = mysql.connector.connect(**config)
        print("Connection successful")
        
        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        
        # Execute the SQL query
        cursor.execute(query)
        
        # Fetch and print results if it is a SELECT query
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            column_headers = [i[0] for i in cursor.description]
            print(column_headers)
            for row in rows:
                print(row)
        
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        # Close the cursor and the connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("Connection closed")

# SQL query to select all records from the instructor table where dept_name is 'History'
sql_query = "SELECT DISTINCT name, course_id FROM instructor LEFT JOIN teaches ON instructor.ID = teaches.ID"
execute_query(sql_query)
Connection successful
['name', 'course_id']
('Srinivasan', 'CS-347')
('Srinivasan', 'CS-315')
('Srinivasan', 'CS-101')
('Wu', 'FIN-201')
('Mozart', 'MU-199')
('Einstein', 'PHY-101')
('El Said', 'HIS-351')
('Gold', None)
('Katz', 'CS-319')
('Katz', 'CS-101')
('Califieri', None)
('Singh', None)
('Crick', 'BIO-301')
('Crick', 'BIO-101')
('Brandt', 'CS-319')
('Brandt', 'CS-190')
('Kim', 'EE-181')
Connection closed
 
