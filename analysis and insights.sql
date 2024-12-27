-- Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category:
select b.category,sum(b.rental_price),count(*)
from books as b
join issued_status as i
on b.isbn=i.issued_book_isbn
group by category;

-- task 9: List Members Who Registered in the Last 180 Days:
select * from members
where reg_date >= current_date()-interval 180 day;

-- List Employees with Their Branch Manager's Name and their branch details:
	select e1.emp_id,e1.emp_name,e1.position,e1.salary, b.*,e2.emp_name as manager
	from employees as e1
	join branch as b
	on e1.branch_id=b.branch_id
	join 
	employees as e2
	on e2.emp_id=b.manager_id;
    
-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_books as 
select * from books 
where rental_price>=7.00;

-- Task 12: Retrieve the List of Books Not Yet Returned
	select *
	from issued_status as i
	left join return_status as r
	on i.issued_id=r.issued_id
	where r.return_id is null;