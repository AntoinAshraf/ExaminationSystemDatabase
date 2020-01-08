--
use master
go
drop database iti_examination
--
--EXCUTE THE FIRST LINE SEPERATELY FIRST
create database ITI_Examination
go
--
--SELECT FROM HERE TO THE END OF THE FILE AND THEN EXCUTE
use ITI_Examination

--drop table Department
create table Department(
	dept_No smallint primary key IDENTITY(301,1) CHECK(dept_No <= 399),
	dept_Name varchar(50) unique not null,
	mngr_Id smallint unique,
	mngr_HireDate date
)
EXEC sp_addextendedproperty 'MS_Description', 'This table contains data of departments', 'schema', dbo, 'table', 'Department'
EXEC sp_addextendedproperty 'MS_Description', 'Department number (identifier)', 'schema', dbo, 'table', 'Department', 'column', dept_No
EXEC sp_addextendedproperty 'MS_Description', 'Department name', 'schema', dbo, 'table', 'Department', 'column', dept_Name
EXEC sp_addextendedproperty 'MS_Description', 'Manager ID (FK refers to instructor ID)', 'schema', dbo, 'table', 'Department', 'column', mngr_Id
EXEC sp_addextendedproperty 'MS_Description', 'Manager hiring date', 'schema', dbo, 'table', 'Department', 'column', mngr_HireDate

--drop table Instructor
create table Instructor(
	inst_Id smallint primary key IDENTITY(2001,1) CHECK(inst_Id between 2001 and 2999),
	inst_Fname varchar(20)  not null,
	inst_Lname varchar(20)  not null,
	inst_Salary int  not null,
	inst_Degree varchar(50),
	dept_No smallint not null FOREIGN KEY REFERENCES Department(dept_No),
)
ALTER TABLE Department
ADD FOREIGN KEY (mngr_Id) REFERENCES Instructor(inst_Id);
EXEC sp_addextendedproperty 'MS_Description', 'This table contains data of instructors', 'schema', dbo, 'table', 'Instructor'
EXEC sp_addextendedproperty 'MS_Description', 'Instructor ID (identifier)', 'schema', dbo, 'table', 'Instructor', 'column', inst_Id
EXEC sp_addextendedproperty 'MS_Description', 'Instructor first name', 'schema', dbo, 'table', 'Instructor', 'column', inst_Fname
EXEC sp_addextendedproperty 'MS_Description', 'Instructor last name', 'schema', dbo, 'table', 'Instructor', 'column', inst_Lname
EXEC sp_addextendedproperty 'MS_Description', 'Instructor salary', 'schema', dbo, 'table', 'Instructor', 'column', inst_Salary
EXEC sp_addextendedproperty 'MS_Description', 'Instructor degree', 'schema', dbo, 'table', 'Instructor', 'column', inst_Degree
EXEC sp_addextendedproperty 'MS_Description', 'Department number (FK refers to department number)', 'schema', dbo, 'table', 'Instructor', 'column', dept_No

--drop table Course
create table Course(
	crs_Code smallint primary key IDENTITY(4001,1) CHECK(crs_Code between 4001 and 4999),
	crs_Name varchar(50) unique not null,
	crs_Duration tinyint not null
)
EXEC sp_addextendedproperty 'MS_Description', 'This table contains data of courses', 'schema', dbo, 'table', 'Course'
EXEC sp_addextendedproperty 'MS_Description', 'Course code (identifier)', 'schema', dbo, 'table', 'Course', 'column', crs_Code
EXEC sp_addextendedproperty 'MS_Description', 'Course name', 'schema', dbo, 'table', 'Course', 'column', crs_Name
EXEC sp_addextendedproperty 'MS_Description', 'Course duration in hours', 'schema', dbo, 'table', 'Course', 'column', crs_Duration

--drop table Course_Topics
create table Course_Topics(
	crs_Code smallint not null foreign key references Course(crs_Code) on delete cascade,
	topic_name varchar(50) not null,
	primary key(crs_Code,topic_name)
)
EXEC sp_addextendedproperty 'MS_Description', 'This table contains the topics for each course', 'schema', dbo, 'table', 'Course_Topics'
EXEC sp_addextendedproperty 'MS_Description', 'Course code (FK refers to course code)', 'schema', dbo, 'table', 'Course_Topics', 'column', crs_Code
EXEC sp_addextendedproperty 'MS_Description', 'Topic name', 'schema', dbo, 'table', 'Course_Topics', 'column', topic_name

create table Questions(
	quest_No smallint primary key IDENTITY(1,1),
	quest_Body varchar(250) unique not null,
	quest_ModelAnswer varchar(1) not null check(quest_ModelAnswer in ('a','b','c','d','t','f')),
	quest_Mark tinyint not null check(quest_Mark between 1 and 10),
	quest_Type varchar(10) not null check (quest_Type in ('MCQ','TorF')),
	crs_Code smallint not null foreign key references Course(crs_Code)
)
--not null befor foreign key is a must or not
EXEC sp_addextendedproperty 'MS_Description', 'This table contains courses questions', 'schema', dbo, 'table', 'Questions'
EXEC sp_addextendedproperty 'MS_Description', 'Question number (identifier)', 'schema', dbo, 'table', 'Questions', 'column', quest_No
EXEC sp_addextendedproperty 'MS_Description', 'Question body', 'schema', dbo, 'table', 'Questions', 'column', quest_Body
EXEC sp_addextendedproperty 'MS_Description', 'Question model answer', 'schema', dbo, 'table', 'Questions', 'column', quest_ModelAnswer
EXEC sp_addextendedproperty 'MS_Description', 'Question mark', 'schema', dbo, 'table', 'Questions', 'column', quest_Mark
EXEC sp_addextendedproperty 'MS_Description', 'Question type. It can be either TorF or MCQ. Choices of MCQ can not exceed 4 choices', 'schema', dbo, 'table', 'Questions', 'column', quest_Type
EXEC sp_addextendedproperty 'MS_Description', 'Course that the question belongs to code (FK refers to course code)', 'schema', dbo, 'table', 'Questions', 'column', crs_Code

--drop table Question_Choices
create table Question_Choices(
	quest_No smallint foreign key references Questions(quest_No) on delete cascade,
	choice varchar(1) not null check(choice in ('a','b','c','d')),
	choice_Body varchar(150) not null,
	primary key(quest_No, choice)
)
EXEC sp_addextendedproperty 'MS_Description', 'This table contains choices of MCQ questions', 'schema', dbo, 'table', 'Question_Choices'
EXEC sp_addextendedproperty 'MS_Description', 'Question number that the choices belong to (FK refers to question number)', 'schema', dbo, 'table', 'Question_Choices', 'column', quest_No
EXEC sp_addextendedproperty 'MS_Description', 'Choice', 'schema', dbo, 'table', 'Question_Choices', 'column', choice
EXEC sp_addextendedproperty 'MS_Description', 'Choice body', 'schema', dbo, 'table', 'Question_Choices', 'column', choice_Body

create table Exam(
	exam_No smallint primary key identity(1,1),
	exam_Date datetime not null,
	total_Marks smallint,
	exam_Duration smallint  not null default 60,
	crs_Code smallint not null foreign key references Course(crs_Code)
)
EXEC sp_addextendedproperty 'MS_Description', 'This table contains all exams', 'schema', dbo, 'table', 'Exam'
EXEC sp_addextendedproperty 'MS_Description', 'Exam number (identifier)', 'schema', dbo, 'table', 'Exam', 'column', exam_No
EXEC sp_addextendedproperty 'MS_Description', 'Exam date', 'schema', dbo, 'table', 'Exam', 'column', exam_Date
EXEC sp_addextendedproperty 'MS_Description', 'Exam total mark (the sum of its questions marks)', 'schema', dbo, 'table', 'Exam', 'column', total_Marks
EXEC sp_addextendedproperty 'MS_Description', 'Exam duration (in minutess)', 'schema', dbo, 'table', 'Exam', 'column', exam_Duration
EXEC sp_addextendedproperty 'MS_Description', 'Course which is the exam for (FK refers to course code)', 'schema', dbo, 'table', 'Exam', 'column', crs_Code
--SELECT SMALLDATETIMEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE())+3, 9, 0);

create table Exam_Questions(
	exam_No smallint not null,
	quest_No smallint not null,
	primary key(exam_No, quest_No),
	foreign key (exam_No) references  Exam(exam_No),
	foreign key (quest_No) references Questions(quest_No)
)
EXEC sp_addextendedproperty 'MS_Description', 'This table linking the exam with its questions', 'schema', dbo, 'table', 'Exam_Questions'
EXEC sp_addextendedproperty 'MS_Description', 'Exam number (FK refers to exam number)', 'schema', dbo, 'table', 'Exam_Questions', 'column', exam_No
EXEC sp_addextendedproperty 'MS_Description', 'Question number (FK refers to question number)', 'schema', dbo, 'table', 'Exam_Questions', 'column', quest_No

create table Student(
	std_Id smallint primary key identity(10001,1),
	std_Fname varchar(20) not null,
	std_Lname varchar(20) not null,
	std_DOB date check(year(getdate())-year(std_DOB) >= 18),
	std_Address varchar(50) not null,
	std_Mobile varchar(20),
	dept_No smallint not null foreign key references Department(dept_No)
)
--if i have a check constraint, i will not need to write not null?
EXEC sp_addextendedproperty 'MS_Description', 'This table contains students data', 'schema', dbo, 'table', 'Student'
EXEC sp_addextendedproperty 'MS_Description', 'Student ID (identifier)', 'schema', dbo, 'table', 'Student', 'column', std_Id
EXEC sp_addextendedproperty 'MS_Description', 'Student first name', 'schema', dbo, 'table', 'Student', 'column', std_Fname
EXEC sp_addextendedproperty 'MS_Description', 'Student last name', 'schema', dbo, 'table', 'Student', 'column', std_Lname
EXEC sp_addextendedproperty 'MS_Description', 'Student date of birth', 'schema', dbo, 'table', 'Student', 'column', std_DOB
EXEC sp_addextendedproperty 'MS_Description', 'Student address', 'schema', dbo, 'table', 'Student', 'column', std_Address
EXEC sp_addextendedproperty 'MS_Description', 'Student mobile number', 'schema', dbo, 'table', 'Student', 'column', std_Mobile
EXEC sp_addextendedproperty 'MS_Description', 'Department that the Student belongs to (FK refers to department number)', 'schema', dbo, 'table', 'Student', 'column', dept_No

create table Instructor_Course(
	inst_Id smallint not null,
	crs_Code smallint not null,
	primary key(inst_Id,crs_Code),
	foreign key (inst_Id) references Instructor(inst_Id),
	foreign key (crs_Code) references Course(crs_Code)
)
EXEC sp_addextendedproperty 'MS_Description', 'This table linking the instructors with the courses they teach', 'schema', dbo, 'table', 'Instructor_Course'
EXEC sp_addextendedproperty 'MS_Description', 'Instructor ID (FK refers to instructor ID)', 'schema', dbo, 'table', 'Instructor_Course', 'column', inst_Id
EXEC sp_addextendedproperty 'MS_Description', 'Course code (FK refers to course code)', 'schema', dbo, 'table', 'Instructor_Course', 'column', crs_Code

create table Student_Course(
	std_Id smallint not null,
	crs_Code smallint not null,
	grade varchar(1),
	primary key(std_Id, crs_Code),
	foreign key (std_Id) references Student(std_Id),
	foreign key (crs_Code) references Course(crs_Code)
)
--calculate the grade of the student in student_course table
EXEC sp_addextendedproperty 'MS_Description', 'This table linking the student with the courses they take', 'schema', dbo, 'table', 'Student_Course'
EXEC sp_addextendedproperty 'MS_Description', 'Student ID (FK refers to student ID)', 'schema', dbo, 'table', 'Student_Course', 'column', std_Id
EXEC sp_addextendedproperty 'MS_Description', 'Course code (FK refers to course code)', 'schema', dbo, 'table', 'Student_Course', 'column', crs_Code
EXEC sp_addextendedproperty 'MS_Description', 'Grade is the student GPA in this course', 'schema', dbo, 'table', 'Student_Course', 'column', grade

create table Student_Answers(
	std_Id smallint not null,
	exam_No smallint not null,
	quest_No smallint not null,
	std_Answer varchar(1) check(std_Answer in('a','b','c','d','t','f')),
	score smallint,
	primary key(std_Id, exam_No, quest_No),
	foreign key(std_Id) references Student(std_Id),
	foreign key(exam_No) references Exam(exam_No),
	foreign key(quest_No) references Questions(quest_No)
)
-- score doesnt exceed the exam total marks
EXEC sp_addextendedproperty 'MS_Description', 'This table represents the ternary relation between student, exam, questions tables', 'schema', dbo, 'table', 'Student_Answers'
EXEC sp_addextendedproperty 'MS_Description', 'Student ID (FK refers to student ID)', 'schema', dbo, 'table', 'Student_Answers', 'column', std_Id
EXEC sp_addextendedproperty 'MS_Description', 'Exam Number (FK refers to exam number)', 'schema', dbo, 'table', 'Student_Answers', 'column', exam_No
EXEC sp_addextendedproperty 'MS_Description', 'Question Number(FK refers to question number)', 'schema', dbo, 'table', 'Student_Answers', 'column', quest_No
EXEC sp_addextendedproperty 'MS_Description', 'Student Answer is the actual answer of the student in the exam in this question', 'schema', dbo, 'table', 'Student_Answers', 'column', std_Answer
EXEC sp_addextendedproperty 'MS_Description', 'Score is the grade of the student answer in this question in the exam', 'schema', dbo, 'table', 'Student_Answers', 'column', score

