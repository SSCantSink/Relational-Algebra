% list the lastnames for each pair of employees who have the same supervisor.
% There should not be any duplicate reversed pair and no employee be paired with the same employee.

% The idea is to 

% reduce the employee table to only have lastname, snn, and superssn
% Create two copies of this
employeeR1(lname1, ssn1, superssn1) :=
	project lname, ssn, superssn (employee);
employeeR2(lname2, ssn2, superssn2) :=
	project lname, ssn, superssn (employee);

% product the two tables together
pairsOfEmployees :=
	(employeeR1 product employeeR2);

% only get the pairs with matching superssn's
matchEmployees :=
	select superssn1=superssn2 (pairsOfEmployees);

% only get pairs where lname1 < lname2, (prevents duplicate pairs and self pairs)
pairs :=
	select lname1<lname2 (matchEmployees);

% finally, just get the two lastname pairs
q2 :=
	project lname1, lname2 (pairs);