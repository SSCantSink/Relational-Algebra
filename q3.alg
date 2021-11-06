% List the firstname and lastname of employee(s) with the lowest salary value

% project only the, ssn, firstname, lastname and salary of the individual.
emps :=
	project fname, lname, ssn, salary (employee);

% do another copy of that but labeled differently
emps2(fname2, lname2, ssn2, salary2) :=
	project fname, lname, ssn, salary (employee);

% pair up employees two at a time and see which have greater salary than the other
% note that the left half of this table has employees that don't have the lowest salary.
empPairs :=
	select salary>salary2 (emps product emps2);

% get only the first half of the table.
empButLow :=
	project fname, lname, ssn, salary (empPairs);

% find the difference, (so first half of table has employees of only the lowest value)
empDiff :=
	emps difference empButLow;

% only get the firstname and lastname from the previous table.
q3 :=
	project fname, lname (empDiff);
