--Returns the absolute value of a number
SELECT Abs(-243.5) AS AbsNum;

--Returns the arc cosine of a number
SELECT ACOS(0.25);

--Returns the arc sine of a number
SELECT ASIN(0.25);

--Returns the arc tangent of a number
SELECT ATAN(2.5);

--Returns the arc tangent of two numbers
SELECT ATN2(0.50, 1);

--Returns the average value of an expression
SELECT AVG(ListPrice) AS AveragePrice FROM AdventureWorks2019.Production.Product;

--	Returns the smallest integer value that is >= a number
SELECT CEILING(25.75) AS CeilValue;

--	Returns the number of records returned by a select query
SELECT COUNT(ProductID) AS NumberOfProducts FROM AdventureWorks2019.Production.Product;

--	Returns the cosine of a number
SELECT COS(2);

--	Returns the cotangent of a number
SELECT COT(6);

--Converts a value in radians to degrees
SELECT DEGREES(1.5);

--	Returns e raised to the power of a specified number
SELECT EXP(1);

--	Returns the largest integer value that is <= to a number
SELECT FLOOR(25.75) AS FloorValue;

--	Returns the natural logarithm of a number, or the logarithm of a number to a specified base
SELECT LOG(2);

--	Returns the natural logarithm of a number to base 10
SELECT LOG10(2);

--Returns the maximum value in a set of values
SELECT MAX(ListPrice) AS LargestPrice FROM AdventureWorks2019.Production.Product;

--	Returns the minimum value in a set of values
SELECT MIN(ListPrice) AS SmallestPrice FROM AdventureWorks2019.Production.Product;

--Returns the value of PI
SELECT PI();

--	Returns the value of a number raised to the power of another number
SELECT POWER(4, 2);

--Converts a degree value into radians
SELECT RADIANS(180);

--Returns a random number
SELECT RAND();

--Rounds a number to a specified number of decimal places
SELECT ROUND(235.415, 2) AS RoundValue;

--	Returns the sign of a number
SELECT SIGN(255.5);


--Returns the sine of a number
SELECT SIN(2);


--	Returns the square root of a number
SELECT SQRT(64);


--Returns the square of a number
SELECT SQUARE(64);

--Calculates the sum of a set of values
SELECT SUM(ListPrice) AS TotalItemsOrdered FROM AdventureWorks2019.Production.Product;

--Returns the tangent of a number
SELECT TAN(1.75);
