-- Advanced SQL problems
-- Task 13: Identify Members with Overdue Books
/*Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.*/

-- approach issue_status == members == return_status
select m.member_id,m.member_name, i.issued_book_name,i.issued_date, DATEDIFF(current_date(), i.issued_date) as over_dues_days
from issued_status as i
join members as m
on i.issued_member_id=m.member_id
left join return_status as r
on i.issued_id=r.issued_id
where (r.return_date is null and DATEDIFF(current_date(), i.issued_date)>30 ) 
order by 1;

/* Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).*/
call add_return_records('RS138', 'IS135', 'Good');
SELECT * FROM return_status
WHERE issued_id = 'IS135';

/* Task 15: Branch Performance Report
Create a query that generates a performance report for each branch,
showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.*/

-- branch== issued_status==return_status==books
select b.branch_id,count(i.issued_id) as numbooksssued,count(r.return_id) as numofbooksreturned,sum(bo.rental_price) as totalrevenue
from issued_status as i
JOIN 
employees as e
ON e.emp_id = i.issued_emp_id
join branch as b
on e.branch_id=b.branch_id
join books as bo
on i.issued_book_isbn=bo.isbn
left join return_status as r
on i.issued_id=r.issued_id
group by b.branch_id;

/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table
active_members containing members who have issued at least one book in the last 2 months.*/

-- approach 1
select m.*
from issued_status as i
join members as m
on i.issued_member_id=m.member_id
where datediff(current_date(),i.issued_date)<60;

-- approach 2
create table active_members 
as
select *
from members
where member_id in( select distinct issued_member_id
					from issued_status
					where datediff(current_date(),issued_date)<60
                    );
                    
/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed
the most book issues. Display the employee name, number of books processed, and their branch. */

select e.emp_id,e.emp_name,e.branch_id ,count(i.issued_book_isbn) as numbooks
from issued_status as i
join employees as e
on i.issued_emp_id=e.emp_id
group by 1,2
order by 4 desc limit 3;

/*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table.
Display the member name, book title, and the number of times they've issued damaged books.*/
SELECT 
    m.member_name,
    i.issued_book_name,
    COUNT(r.book_quality) AS damaged_count
FROM 
    issued_status AS i
JOIN 
    return_status AS r
ON 
    i.issued_id = r.issued_id
JOIN 
    members AS m
ON 
    i.issued_member_id = m.member_id
WHERE 
    r.book_quality = 'damaged'
GROUP BY 
    m.member_name, i.issued_book_name
HAVING 
    damaged_count > 1;

/*Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system.
 Description: Write a stored procedure that updates the status of a book in the library based on its issuance.
 The procedure should function as follows: The stored procedure should take the book_id as an input parameter.
 The procedure should first check if the book is available (status = 'yes').
 If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
 If the book is not available (status = 'no'),
 the procedure should return an error message indicating that the book is currently not available.*/

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-553-29698-2';

/*Task 20: Create Table As Select (CTAS) Objective:
 Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
Description: Write a CTAS query to create a new table that lists each member and
 the books they have issued but not returned within 30 days.
 The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50.
 The number of books issued by each member.
 The resulting table should show: Member ID, Number of overdue books, Total fines*/
CREATE TABLE overdue_books AS
SELECT 
    m.member_id,
    COUNT(CASE WHEN r.return_date IS NULL AND DATEDIFF(CURRENT_DATE(), i.issued_date) > 30 THEN 1 END) AS overdue_books_count,
    SUM(CASE WHEN r.return_date IS NULL AND DATEDIFF(CURRENT_DATE(), i.issued_date) > 30 
             THEN (DATEDIFF(CURRENT_DATE(), i.issued_date) - 30) * 0.50 ELSE 0 END) AS total_fines,
    COUNT(i.issued_id) AS total_books_issued
FROM 
    issued_status AS i
LEFT JOIN 
    return_status AS r
ON 
    i.issued_id = r.issued_id
JOIN 
    members AS m
ON 
    i.issued_member_id = m.member_id
GROUP BY 
    m.member_id
ORDER BY 
    m.member_id;

select * from overdue_books;
 
 




