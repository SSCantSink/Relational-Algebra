% List the firstname and lastname off each employee who has at least one work assignment with the
% project "ProductY"

% get the pnumber's for the "ProductY" project
productYpNum :=
	select pname = 'ProductY' (projects);

% product employee's works_on with the productY row and find essn's that match the pno's
essnWhoWorks :=
	select pno = pnumber (productYpNum product works_on);

% get employees from employees tables that have the matching essn's
employeesWhoWorks :=
	select essn = ssn (essnWhoWorks product employee);

% finally, only list the first and last name from this table
q1 :=
	project fname, lname (employeesWhoWorks);



