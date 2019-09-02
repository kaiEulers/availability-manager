-- Database System & Information Modelling
-- Assignment 2

-- Question 1
-- What is the longest student name?
SELECT CONCAT(givenName, ' ', familyName) AS Name
FROM Student
WHERE CHAR_LENGTH(CONCAT(givenName, familyName)) = (
    SELECT MAX(CHAR_LENGTH(CONCAT(givenName, familyName)))
    FROM student
	)
;

-- Question 2
-- List the names any student who have not yet entered any free times.
SELECT * 
FROM Student LEFT OUTER JOIN Availability
ON Student.id = Availability.student
;

SELECT CONCAT(Student.givenName, ' ', Student.familyName) AS Name
FROM Student LEFT OUTER JOIN Availability
ON Student.id = Availability.student
WHERE Availability.hour IS NULL
;

-- Question 3
-- Which students are free on Wednesday at 10am?
SELECT *
FROM Student LEFT OUTER JOIN Availability
ON Student.id = Availability.student
;

SELECT student.id, student.givenName, student.familyName, availability.day, availability.hour
FROM student LEFT OUTER JOIN availability
ON student.id = availability.student
WHERE availability.day = 'Wed' AND availability.hour = 10
;

SELECT student.id, student.givenName, student.familyName
FROM student LEFT OUTER JOIN availability
ON student.id = availability.student
WHERE availability.day = 'Wed' AND availability.hour = 10
;

-- Question 4
-- List each student's name. For those who are in a group, list also the name of their group
SELECT CONCAT(Student.givenName, ' ', Student.familyName) AS Name, Groups.name AS GroupName
FROM Student LEFT OUTER JOIN StudentInGroup
	INNER JOIN Groups
    ON StudentInGroup.groupId = Groups.id
ON Student.id = StudentInGroup.studentId
;

-- Question 5
-- For any groups that have more than 3 students, list the group's id, name, and number of students.
SELECT Groups.id AS GroupID, Groups.name AS GroupName, COUNT(Groups.id) AS NumOfStudents
FROM Student INNER JOIN StudentInGroup INNER JOIN Groups
ON Student.id = StudentInGroup.studentId AND StudentInGroup.groupId = Groups.id
GROUP BY Groups.id
HAVING COUNT(Groups.id) > 3
;

-- Question 6
-- Is student "Alice Smith" free at lunch on Wednesday?
SELECT
CASE
	WHEN Availability.day = 'Wed' AND Calendar.description = 'lunch'
    THEN 'Yes'
	ELSE 'No'
END AS Answer
FROM Student INNER JOIN Availability NATURAL JOIN Calendar
ON Student.id = Availability.student
WHERE Student.givenName = "Alice" AND Student.familyName = "Smith"
;

-- Question 7
-- List all times when students 10001 and 10002 are both free.
SELECT * 
FROM Availability
;

SELECT A.hour, B.day
FROM Availability A, Availability B
WHERE A.hour = B.hour AND A.day = B.day AND A.student = 10001 AND B.student = 10002
;

-- Question 8
-- For each group, list the group id and name of the student whose family name is alphabetically first in the group.
SELECT StudentInGroup.groupID, CONCAT(Student.givenName, ' ', Student.familyName) AS Name
FROM Student INNER JOIN StudentInGroup
ON student.id = StudentInGroup.studentId
WHERE student.familyName IN
	(SELECT MIN(Student.familyName)
	FROM Student INNER JOIN StudentInGroup
	ON student.id = StudentInGroup.studentId
	GROUP BY StudentInGroup.groupID)
;

SELECT *
FROM student INNER JOIN StudentInGroup
ON student.id = StudentInGroup.studentId
ORDER BY groupID, familyName
;

-- Question 9
-- Which students are free on Wednesdays between 10am and 12 noon?
SELECT *
FROM Student INNER JOIN Availability
ON Student.id = Availability.student
WHERE Availability.day = 'Wed' AND Availability.hour BETWEEN 10 AND 12
;

SELECT CONCAT(Student.givenName, ' ', Student.familyName) AS Name
FROM Availability INNER JOIN Student
ON Student.id = Availability.student
WHERE Availability.day = 'Wed' AND Availability.hour = 10 AND student.id IN
	(SELECT student.id
	FROM Availability INNER JOIN Student
	ON Student.id = Availability.student
	WHERE Availability.day = 'Wed' AND Availability.hour = 11)
;

-- Question 10
-- Are the member of 'WeLoveDb' all free on Wednesday at 10am?
SELECT *
FROM Availability INNER JOIN Student INNER JOIN StudentInGroup INNER JOIN Groups
ON Availability.student = Student.id AND Student.id = StudentInGroup.studentId AND StudentInGroup.groupId = Groups.id
WHERE Groups.name = "WeLoveDb"
;

SELECT
CASE
	WHEN COUNT(*) = 3
    THEN 'Yes'
	ELSE 'No'
END AS Answer
FROM Availability INNER JOIN Student INNER JOIN StudentInGroup INNER JOIN Groups
ON Availability.student = Student.id AND Student.id = StudentInGroup.studentId AND StudentInGroup.groupId = Groups.id
WHERE Groups.name = "WeLoveDb" AND Availability.day = 'Wed' AND Availability.hour = 10
;