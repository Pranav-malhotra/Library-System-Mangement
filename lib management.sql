-- Library Management System

-- create branch table
drop table if exists branch; 
Create table branch(
	branch_id Varchar(10) PRIMARY KEY,
    manager_id varchar(10),
    branch_address varchar(100),
    contact_no varchar(10)
);

alter table branch
modify column contact_no varchar(20);

-- create employees table
drop table if exists employees;
Create table employees (
	emp_id	Varchar(10) PRIMARY KEY,
    emp_name	Varchar(25),
    position	Varchar(115),
    salary	int,
    branch_id Varchar(25)
);

-- create books table
drop table if exists books;
create table books (
	isbn	Varchar(20) PRIMARY KEY ,
    book_title	Varchar(100),
    category	Varchar(10),
    rental_price	float,
    status	Varchar(15),
    author	Varchar(35),
    publisher Varchar(35)
);
alter table books
modify column category varchar(25);

-- create members table
drop table if exists members ;
create table members (
	member_id	Varchar(10) PRIMARY KEY,
    member_name	Varchar(25),
    member_address	Varchar(75),
    reg_date date
);

-- create issued_status table
drop table if exists issued_status;
create table issued_status (
	issued_id	Varchar(10) PRIMARY KEY,
    issued_member_id	Varchar(10),
    issued_book_name	Varchar(75),
    issued_date	 date,
    issued_book_isbn	Varchar(25),
    issued_emp_id Varchar(10)
);

-- create return_status table
drop table if exists return_status;
create table return_status (
	return_id	Varchar(10) PRIMARY KEY,
    issued_id	Varchar(10),
    return_book_name	Varchar(75),
    return_date	date,
    return_book_isbn Varchar(20)
);

-- to add foreign key to a certain key
alter table issued_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);

alter table issued_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_employees
foreign key (issued_emp_id)
references employees(emp_id);


alter table employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);

alter table return_status	
add constraint fk_issued_status
foreign key (issued_id)
references issued_status(issued_id);

