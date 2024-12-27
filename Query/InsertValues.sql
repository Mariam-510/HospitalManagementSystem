use Hospital

--------------------------------------------------------------------------------------------------
--Insert records into Department table
insert into Department (Name) 
values ('Cardiology'), ('Neurology'), ('Pediatrics'), ('General Surgery'), ('Orthopedics'), ('Secretarial');

--------------------------------------------------------------------------------------------------
--Insert records into Doctor table
declare @insertedDocIDt1 TABLE (id INT, Speciality NVARCHAR(100));
insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Street, City, State, DeptID)
output inserted.id, case 
                       when inserted.Fname = 'Ahmed' then 'Cardiologist'
                       when inserted.Fname = 'Khaled' then 'Neurologist'
                       when inserted.Fname = 'hala' then 'Pediatrician'
					   when inserted.Fname = 'Rana' then 'General Surgeon'
					   when inserted.Fname = 'Mostafa' then 'Orthopedic Surgeon	'
                   end into @insertedDocIDt1
values
    ('D', 'Ahmed', 'Ali', '1985-05-12', '0123456789', 'M', 'Street 1', 'Giza', 'Egypt', 100),
    ('D', 'Khaled', 'Mahmoud', '1980-11-05', '0103456789', 'M', 'Street 2', default, default, 102),
    ('D', 'hala', 'Adel', '1990-07-20', '0113756780', 'F', 'Street 33', 'Alexandria', 'Egypt', 103),
	('D', 'Rana', 'Samir', '1996-01-01', '0103950789', 'F', 'Street 51', default, default, 104),
    ('D', 'Mostafa', 'Abdallah', '1989-06-05', '0123556787', 'M', 'Street 9', default, default, 101)

insert into Doctor (Id, Speciality)
select id, Speciality
from @insertedDocIDt1;

--------------------------------------------------------------------------------------------------
--Insert records into Nurse table    
DECLARE @insertedNurIDt2 TABLE (id INT)
insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Street, City, State, DeptID)
output inserted.Id into @insertedNurIDt2
values
	('N', 'Sara', 'Hassan', '1990-10-22', NULL, 'F', NULL, 'Giza', 'Egypt', 102),
    ('N', 'Mona', 'Youssef', '1992-03-15', '0129876543', 'F', 'Street 3', default, default, 103),
	('N', 'Hala', 'Youssef', '1991-12-19', '0109876543', 'F', 'Street 5', 'Alexandria', 'Egypt', 104),
    ('N', 'Nour', 'Salem', '1989-05-11', '0111234567', 'F', 'Street 6', 'Giza', 'Egypt', 100),
    ('N', 'Maha', 'Ezzat', '1994-03-22', '0123454321', 'F', 'Street 7', default, default, 101);

INSERT INTO Nurse (Id)
SELECT id
FROM @insertedNurIDt2;

-----------------------------------------------------------------------------------------------
--Insert records into Receptionist table
DECLARE @insertedRecIDt2 TABLE (id INT)
insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Street, City, State, DeptID)
output inserted.Id into @insertedRecIDt2
values
	('R', 'Ahmed', 'Adel', '1990-10-22', NULL, 'M', NULL, default, default, 105),
    ('R', 'Osama', 'Ali', '1992-03-15', '0129876543', 'M', 'Street 13', 'Alexandria', 'Egypt', 105),
	('R', 'Hany', 'Hassan', '1991-12-19', '0109876543', 'M', 'Street 55', 'Giza', 'Egypt', 105)

INSERT INTO Receptionist(Id)
SELECT id
FROM @insertedRecIDt2;

--------------------------------------------------------------------------------------------------
--Insert records into Room table
insert into Room (Capacity, NId)
values
  (2, 6), (1, 7), (3, 8), (4, 9), (1, 10)

--------------------------------------------------------------------------------------------------
--Insert records into OutPatient table
declare @InsertedOutPatientIdTable1 table (Id int)

insert into Patient (PType, FName, LName, DOB, Gender, Street, City, State)
output inserted.Id into @InsertedOutPatientIdTable1
values 
	('O', 'Ali', 'Omar', '1995-11-05', 'M', 'Park Lane', 'Giza', 'Egypt'),
	('O','Ahmed', 'Mohamed', '2000-05-20', 'M', 'Broadway', default, default),
	('O','Mahmoud', null, '2005-07-07', 'M', null, default, default),
	('O', 'Sara', null, '1990-07-08', 'F', null, default, default),
	('O', 'Mariam', null, '2004-05-09', 'F', 'Maadi', default, default)

insert into OutPatient (Id)
select id from @InsertedOutPatientIdTable1

--------------------------------------------------------------------------------------------------
--Insert records into InPatient table
--First patient
declare @InsertedInPatientIdTable1 table (Id int)

insert into Patient (PType, FName, LName, DOB, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable1
values ('I', 'Fatma', 'Ahmed', '1997-12-03', 'F', null, 'Giza', 'Egypt')

declare @InsertedInPatientId1 int
select @InsertedInPatientId1 = Id from @InsertedInPatientIdTable1

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId1, 100)

--------------------------------------------------------------------------------------------------
--Second patient
declare @InsertedInPatientIdTable2 table (Id int)

insert into Patient (PType, FName, LName, DOB, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable2
values ('I', 'Hana', 'Khaled', '1998-06-15', 'F', 'Talaat Harb St', 'Cairo', 'Egypt');

declare @InsertedInPatientId2 int
select @InsertedInPatientId2 = Id from @InsertedInPatientIdTable2

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId2, 101)

--------------------------------------------------------------------------------------------------
--Third patient
declare @InsertedInPatientIdTable3 table (Id int)

insert into Patient (PType, FName, LName, DOB, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable3
values ('I', 'Omar', 'Ibrahim', '1990-03-12', 'M', 'Corniche Rd', 'Alexandria', 'Egypt');

declare @InsertedInPatientId3 int
select @InsertedInPatientId3 = Id from @InsertedInPatientIdTable3

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId3, 102)

--------------------------------------------------------------------------------------------------
--Forth patient
declare @InsertedInPatientIdTable4 table (Id int)

insert into Patient (PType, FName, LName, DOB, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable4
values ('I', 'Youssef', 'Ali', '1992-04-22', 'M', 'Shubra Rd', 'Cairo', 'Egypt');

declare @InsertedInPatientId4 int
select @InsertedInPatientId4 = Id from @InsertedInPatientIdTable4

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId4, 103)

--------------------------------------------------------------------------------------------------
--Fifth patient
declare @InsertedInPatientIdTable5 table (Id int)

insert into Patient (PType, FName, LName, DOB, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable5
values ('I', 'Salma', 'Hussein', '2001-10-08', 'F', 'Nasr St', 'Mansoura', 'Egypt');

declare @InsertedInPatientId5 int
select @InsertedInPatientId5 = Id from @InsertedInPatientIdTable5

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId5, 104)

--------------------------------------------------------------------------------------------------
--Insert records into Appointment table
insert into Appointment (Date, Note, DId, PId, RId)
values 
	('2024-12-29 5:30:00', 'Follow-up check', 3, 1, 12), ('2024-12-27 10:30:00', 'Follow-up', 1, 2, 12)

insert into Appointment (Date, DId, PId, RId)
values
	('2024-12-30 4:00:00', 2, 3, 11), ('2024-12-28 7:00:00', 5, 5, 11), ('2024-12-30 8:00:00', 1, 10, 12)

insert into Appointment (DId, PId, RId)
values	
	(3, 4, 13), (4, 6, 13), (2, 7, 11)

insert into Appointment (Note, DId, PId, RId)
values 
	('Routine visit', 1, 2, 12), ('Emergency Appointment', 1, 8, 13), ('Emergency Appointment', 4, 9, 11)

--------------------------------------------------------------------------------------------------
--Insert records into Drug table
insert into Drug (Code, RecDosage) 
values 
	(120, '500mg Tablet every 4-6 hours'),
	(121, '50mg Tablet 2-3 times a day'),
	(122, '350mg Tablet every 4-6 hours'),
	(123, '400mg Tablet every 4-6 hours'),
	(124, '50mg Tablet 2-3 times a day')

--------------------------------------------------------------------------------------------------
--Insert records into DrugBrand table
insert into DrugBrand (DrugCode, BrandName) 
values 
	(120, 'Panadol'), (121, 'Voltaren'), (122, 'Advil'),
	(123, 'Aspirin'), (124, 'Cataflam')

-- edit drugs

--------------------------------------------------------------------------------------------------
--Insert records into ExaminePatient table
insert into ExaminePatient (DID, PID) 
values 
	(3, 1), (1, 2), (2, 3), (3, 4),(5, 5),
	(4, 6), (2, 7), (1, 8), (4, 9), (1, 10)

--------------------------------------------------------------------------------------------------
--Insert records into Report table
insert into Report (Disease, Symptom, Diagnosis, DID, PId)
values
  ('Flu', 'Fever', 'Influenza', 3, 4),
  ('Cold', 'Sneezing', 'Common Cold', 2, 3),
  ('Diabetes', 'Thirst', 'Type 2 Diabetes', 1, 2),
  ('Hypertension', 'Dizziness', 'High Blood Pressure', 3, 1),
  ('Migraine', 'Headache', 'Severe Migraine', 2, 5)

-- insert for in - edit out

--------------------------------------------------------------------------------------------------
--Insert records into Prescription table
insert into Prescription (DID, PID)
values
	(3, 1), (1, 2), (2, 3), (3, 4),(5, 5),
	(4, 6), (2, 7), (1, 8), (4, 9), (1, 10)

--------------------------------------------------------------------------------------------------
--Insert records into PrescriptionDrug table
insert into PrescriptionDrug (PreID, DrugCode, Dosage) 
values 
(10, 120, '500mg Tablet every 4-6 hours'),
(11, 124, '50mg Tablet 2-3 times a day'),
(12, 120, '350mg Tablet every 4-6 hours'), 
(13, 123, '400mg Tablet every 4-6 hours'), 
(14, 123, '50mg Tablet 2-3 times a day')

-- insert for in - edit out 
 
--------------------------------------------------------------------------------------------------
--Insert records into Bill table
insert into Bill (Amount, PId, RID)
values
  (150, 1, 11),
  (200, 2, 12),
  (300, 5, 12),
  (400, 3, 11),
  (500, 4, 13)

-- insert for in

--------------------------------------------------------------------------------------------------
--Insert records into GivenDrug table
insert into GivenDrug (Dosage, GivenDate, DrugCode, Inpid, NID) 
values 
('500mg tablet', '2024-12-01', 1, 101, 201)
('50mg tablet', '2024-12-01', 2, 102, 202);
('500mg tablet', '2024-12-02', 1, 101, 201);
('350mg tablet', '2024-12-02', 3, 105, 205);
('400mg tablet', '2024-12-03', 4, 104, 204);
('50mg tablet ', '2024-12-04', 5, 105, 205);

