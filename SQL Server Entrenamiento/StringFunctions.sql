--SELECT * FROM dbo.tb_usuarios2;

--SELECT COUNT(CODIGO) AS Total FROM dbo.tb_usuarios2;

--SELECT AVG(EDAD) AS MediaEdad FROM dbo.tb_usuarios2;

--SELECT SUM(EDAD) AS SumaEdad FROM dbo.tb_usuarios2 WHERE APELLIDOS = 'RAMOS';

--SELECT APELLIDOS, COUNT(APELLIDOS) as total FROM dbo.tb_usuarios2 GROUP BY apellidos ORDER BY APELLIDOS DESC;


-- STRING FUCNTIONS


--	Returns the ASCII value for the specific character
SELECT ASCII('B');
SELECT ASCII('@');

--Returns the character based on the ASCII code
SELECT CHAR('66');
SELECT CHAR('64');

--	Extracts a number of characters from a string (starting from left)
SELECT LEFT('VICTOR', 2);
SELECT LEFT('VICTOR', 4);

--Returns the length of a string
SELECT LEN('VICTOR');
SELECT LEN('JOSE LUIS');

--	Converts a string to lower-case
SELECT LOWER('SQL Tutorial');

--	Removes leading spaces from a string
SELECT LTRIM('    JOSE LUIS');

--
SELECT CHARINDEX('t', 'Customer') AS MatchPosition;

--CONCAT WITH +
SELECT 'SQL' + ' is' + ' fun!';

--Add strings together. Use '.' to separate the concatenated string values
SELECT CONCAT_WS('.', 'www', 'W3Schools', 'com');

--Return the length of an expression (in bytes):
SELECT DATALENGTH('W3Schools.com');

--Compares two SOUNDEX values, and return an integer:
SELECT DIFFERENCE('Juice', 'Jucy');

--Format a date:
DECLARE @d DATETIME = '12/01/2018';
SELECT FORMAT (@d, 'd', 'en-US') AS 'US English Result',
               FORMAT (@d, 'd', 'no') AS 'Norwegian Result',
               FORMAT (@d, 'd', 'zu') AS 'Zulu Result';

--Return the Unicode character based on the number code 65:
SELECT NCHAR(65) AS NumberCodeToUnicode;

--Return the position of a pattern in a string:
SELECT PATINDEX('%schools%', 'W3Schools.com');

--Return a Unicode string with bracket delimiters (default):
SELECT QUOTENAME('abcdef');

--	Replaces all occurrences of a substring within a string, with a new substring
SELECT REPLACE('SQL Tutorial', 'T', 'M');

--Repeats a string a specified number of times
SELECT REPLICATE('SQL Tutorial', 5);

--Reverses a string and returns the result
SELECT REVERSE('SQL Tutorial');

--Extracts a number of characters from a string (starting from right)
SELECT RIGHT('SQL Tutorial', 3) AS ExtractString;

--	Removes trailing spaces from a string
SELECT RTRIM('SQL Tutorial     ') AS RightTrimmedString;

--Returns a four-character code to evaluate the similarity of two strings
SELECT SOUNDEX('Juice'), SOUNDEX('Jucy');

--Returns a string of the specified number of space characters
SELECT SPACE(10);

--Returns a number as string
SELECT STR(185);

--	Deletes a part of a string and then inserts another part into the string, starting at a specified position
SELECT STUFF('SQL Tutorial', 1, 3, 'HTML');

--Extracts some characters from a string
SELECT SUBSTRING('SQL Tutorial', 1, 3) AS ExtractString;

--Returns the string from the first argument after the characters specified in the second argument are translated into the characters specified in the third argument.
SELECT TRANSLATE('Monday', 'Monday', 'Sunday'); -- Results in Sunday
SELECT TRANSLATE('3*[2+1]/{8-4}', '[]{}', '()()'); -- Results in 3*(2+1)/(8-4)

--	Removes leading and trailing spaces (or other specified characters) from a string
SELECT TRIM('     SQL Tutorial!     ') AS TrimmedString;

--Returns the Unicode value for the first character of the input expression
SELECT UNICODE('Atlanta');

--	Converts a string to upper-case
SELECT UPPER('SQL Tutorial is FUN!');