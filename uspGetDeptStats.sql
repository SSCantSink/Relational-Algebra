-- input: department_name (varchar(15))
-- output: the folowing statistics

-- firstname and lastname of the manager of the department
-- the total number of projects controlled by this department
-- the name of each projects controlled by this department
-- the total number of work assignments for all these projects.

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `uspGetDeptStats`(
	-- Add the parameters for the stored procedure here
	IN DepName varchar(15) -- DepartmentNumber as input parameter
	)
myModule: BEGIN

	-- local variables to be outputted.
	declare realDeptName varchar(15);
	declare firstName varchar(15);
	declare lastName varchar(15);
	declare projectName varchar(15);
	declare numWorkAssign int;
	declare num_proj int default 0;
	
	-- intermediate variables.
	declare mgSSN char(9);
	declare departmentNumber int;
	declare more_rows boolean default true;
	
	-- declare the cursor
	declare project_cur cursor for
		select pname
		from project
		where dnum in
		(	select dnumber
			from department
			where dname = DepName);
	
	-- declare handlers for exception
	declare continue handler for not found
		set more_rows = false;
	
	
	-- see if the department_name matches
	select dname into realDeptName
	from department
	where dname = DepName;
	
	if (realDeptName is null) then -- prints no such deptname if input doesn't exist
		select concat('No department exists with the name ',  DepName) as '';
	else -- otherwise...
	
		-- get manager's ssn
		select mgrssn into mgSSN
		from department
		where dname = realDeptName;
		
		-- get firstname and lastname
		select fname into firstName
		from employee
		where ssn = mgSSN;
		
		select lname into lastName
		from employee
		where ssn = mgSSN;
		
		-- get the number of work assignments
		select count(*) into numWorkAssign
		from works_on
		where pno IN
		(	select pnumber
			from project
			where dnum IN
			(	select dnumber
				from department
				where dname = realDeptName));
		
		-- Print out these stats
		select concat('Statistics of the department ', realDeptName) as '';
		select concat('Manager: ', firstName, ' ', lastName) as '';
		
		-- open the cursor
		open project_cur;
		select FOUND_ROWS() into num_proj;
		if (num_proj = 0) then
			select concat('Department', realDeptName, 'has no projects') as '';
			leave myModule;
		end if;
		if (num_proj = 1) then
			select concat('Number of Projects: ', num_proj) as '';
			select concat(realDeptName, ' department has the following 1 project:') as '';
		else
			select concat('Number of Projects: ', num_proj) as '';
			select concat(realDeptName, ' department has the following ', num_proj, ' projects:') as '';
		end if;
		
		-- now go get the project names one by one
		whileModule: begin 
		while (num_proj > 0) do
			-- retrieve one projectName
			fetch project_cur into projectName;
			
			-- if there were never any rows, leave the while loop.
			if more_rows = false then
				close project_cur;
				leave whileModule;
			end if;
			
			-- output the project names one by one
			select concat(projectName) as '';
			
			-- decrement the num_proj so while loop stops
			set num_proj = num_proj - 1;
		end while;
		end;
		
		select concat('Number of Work Assignments: ', numWorkAssign) as '';
		
	end if;
	
END$$
DELIMITER ;