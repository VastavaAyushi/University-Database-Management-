
create database SCHEDULE;
use SCHEDULE;
create table Student_t
(NetId varchar(6) not null,
StudentName varchar(50) not null ,
Major varchar(4) not null,
GraduatingSem varchar(50),
constraint Student_PK primary key (NetId));

 create table Instructor_t
(InstructorName varchar(50) not null,
InstructorOffice varchar(10),
constraint Instructor_PK primary key (InstructorName));

create table CourseBooks_t
(
CourseBook varchar(100) not null,
CourseBookPublisher varchar(100),
constraint CourseBooks_PK primary key (CourseBook));


create table Course_t
(ClassNo integer not null,
CourseNo varchar(10) not null,
CourseName varchar(50) not null,
CreditHours integer,
InstructorName varchar(50),
CourseClassRoom varchar(10),
CourseBook varchar(100) not null,
constraint Course_PK primary key (ClassNo),
constraint Course_FK1 foreign key (InstructorName) references Instructor_t(InstructorName),
constraint Course_FK2 foreign key (CourseBook) references CourseBooks_t(CourseBook));


create table CourseHistory_t
(NetId Varchar(6) not null,
ClassNo  integer not null,
constraint CourseHistory_PK primary key (NetId, ClassNo ),
constraint CourseHistory_FK1 foreign key (NetId) references Student_t(NetId),
constraint CourseHistory_FK2 foreign key (ClassNo) references Course_t(ClassNo));

BULK
INSERT Student_t
FROM 'C:/Users/student/Desktop/student.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO


BULK
INSERT Instructor_t
FROM 'C:/Users/student/Desktop/instructor.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO

  

BULK
INSERT course_t
FROM 'C:/Users/student/Desktop/course.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT coursehistory_t
FROM 'C:/Users/student/Desktop/coursehistory.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO

BULK
INSERT CourseBooks_t
FROM 'C:/Users/student/Desktop/coursebook.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO
==================================================================================

select count(NetId) AS "NoOfStudents",GraduatingSem
 from student_t
 group by GraduatingSem;

==================================================================================

select Student_t.StudentName,Student_t.Major 
  from Student_t,
       CourseHistory_t,
	   Course_t
  where Student_t.NetId = CourseHistory_t.NetId
   and CourseHistory_t.ClassNo = Course_t.ClassNo  
     and Course_t.CourseNo = 'BAN 610';
==================================================================================

select Student_t.StudentName,Student_t.Major ,count(CourseHistory_t.NetId) "NoOfCourses"
  from Student_t,
       CourseHistory_t,
	   Course_t
  where Student_t.NetId = CourseHistory_t.NetId
   and CourseHistory_t.ClassNo = Course_t.ClassNo  
     group by Student_t.StudentName,Student_t.Major
	 having count(1) > 8
==================================================================================

select Student_t.NetId  , sum(CreditHours) "TotalCreditHours"
  from Student_t,
       CourseHistory_t,
	   Course_t
  where Student_t.NetId = CourseHistory_t.NetId
   and CourseHistory_t.ClassNo = Course_t.ClassNo  
     group by Student_t.NetId 

==================================================================================

select Course_t.InstructorName,count(CourseBooks_t.CourseBook) "NoOfBooks"
  from Course_t,
       CourseBooks_t
  where  Course_t.CourseBook = CourseBooks_t.CourseBook 
  group by Course_t.InstructorName 

==================================================================================