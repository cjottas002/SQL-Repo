--Converts a value (of any type) into a specified datatype
SELECT CAST(25.65 AS int);

--Returns the first non-null value in a list
SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com');

--	Converts a value (of any type) into a specified datatype
SELECT CONVERT(int, 25.65);

--	Returns the name of the current user in the SQL Server database
SELECT CURRENT_USER;

--	Returns a value if a condition is TRUE, or another value if a condition is FALSE
SELECT IIF(500<1000, 'YES', 'NO');

--Return a specified value if the expression is NULL, otherwise return the expression
SELECT ISNULL(NULL, 'W3Schools.com');

--Tests whether an expression is numeric
SELECT ISNUMERIC(4567);

--	Returns NULL if two expressions are equal
SELECT NULLIF(25, 25);

--	Returns the name of the current user in the SQL Server database
SELECT SESSION_USER;

--Returns the session settings for a specified option
SELECT SESSIONPROPERTY('ANSI_NULLS');

--	Returns the login name for the current user
SELECT SYSTEM_USER;

--Returns the database user name based on the specified id
SELECT USER_NAME();
