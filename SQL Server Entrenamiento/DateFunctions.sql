--	Returns the current date and time
SELECT CURRENT_TIMESTAMP;

--	Adds a time/date interval to a date and then returns the date
SELECT DATEADD(year, 1, '2017/08/25') AS DateAdd;

--Returns the difference between two dates
SELECT DATEDIFF(year, '2017/08/25', '2011/08/25') AS DateDiff;

--	Returns a date from the specified parts (year, month, and day values)
SELECT DATEFROMPARTS(2018, 10, 31) AS DateFromParts;

--Returns a specified part of a date (as string)
SELECT DATENAME(year, '2017/08/25') AS DatePartString;

--Returns a specified part of a date (as integer)
SELECT DATEPART(year, '2017/08/25') AS DatePartInt;

--	Returns the day of the month for a specified date
SELECT DAY('2017/08/25') AS DayOfMonth;

--Returns the current database system date and time
SELECT GETDATE();

--Returns the current database system UTC date and time
SELECT GETUTCDATE();

--	Checks an expression and returns 1 if it is a valid date, otherwise 0
SELECT ISDATE('2017-08-25');

--	Returns the month part for a specified date (a number from 1 to 12)
SELECT MONTH('2017/08/25') AS Month;

--Returns the date and time of the SQL Server
SELECT SYSDATETIME() AS SysDateTime;

--Returns the year part for a specified date
SELECT YEAR('2017/08/25') AS Year;