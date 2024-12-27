-- Task 
-- 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
Insert into books (isbn	,book_title	,category	,rental_price	,status	,author	,publisher)
values ('978-1-60129-456-2','To Kill a Mockingbird','Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

-- Task 2: Update an Existing Member's Address
update members
set member_address = "125 Oak St"
where member_id='C103';
select * from members;

-- Task 3: Delete a Record from the Issued Status Table
delete from issued_status
where issued_id='IS121';
SELECT * from issued_status;

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
select issued_book_name from issued_status
where issued_emp_id='E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_member_id, count(issued_id) as c 
from issued_status
group by issued_member_id
having c>1;

-- ctas
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_cnt
as 
select b.isbn,b.book_title,count(b.isbn)
from books as b
join issued_status as i
on b.isbn= i.issued_book_isbn
group by 1,2;

select * from book_cnt;


