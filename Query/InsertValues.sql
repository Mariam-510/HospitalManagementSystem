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
	('N', 'Sara', 'Hassan', '1990-10-22', '01144456820', 'F', NULL, 'Giza', 'Egypt', 102),
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
	('R', 'Ahmed', 'Adel', '1990-10-22', '01150211405', 'M', NULL, default, default, 105),
    ('R', 'Osama', 'Ali', '1992-03-15', '0119876543', 'M', 'Street 13', 'Alexandria', 'Egypt', 105),
	('R', 'Hany', 'Hassan', '1991-12-19', '0159876543', 'M', 'Street 55', 'Giza', 'Egypt', 105)

INSERT INTO Receptionist(Id)
SELECT id
FROM @insertedRecIDt2;

--------------------------------------------------------------------------------------------------
--Insert records into Room table
insert into Room (MaxCapacity, CurrentCapacity ,NId)
values
  (2, 1, 6), (1, 1, 7), (3, 1, 8), (4, 1, 9), (1, 1, 10)

--------------------------------------------------------------------------------------------------
--Insert records into OutPatient table
declare @InsertedOutPatientIdTable1 table (Id int)

insert into Patient (PType, FName, LName, DOB, Phone, Gender, Street, City, State, AdmittedDate)
output inserted.Id into @InsertedOutPatientIdTable1
values 
	('O', 'Ali', 'Omar', '1995-11-05', '0121234567' ,'M', 'Park Lane', 'Giza', 'Egypt', '2024-12-29 5:30:00'),
	('O','Ahmed', 'Mohamed', '2000-05-20', '0151234567', 'M', 'Broadway', default, default,'2024-12-27 10:30:00'),
	('O','Mahmoud', null, '2005-07-07', '0101234567', 'M', null, default, default,'2024-12-30 4:00:00'),
	('O', 'Sara', null, '1990-07-08', '0122234567', 'F', null, default, default, default),
	('O', 'Mariam', null, '2004-05-09', '0125234567', 'F', 'Maadi', default, default,'2024-12-28 7:00:00')

insert into OutPatient (Id)
select id from @InsertedOutPatientIdTable1

--------------------------------------------------------------------------------------------------
--Insert records into InPatient table
--First patient
declare @InsertedInPatientIdTable1 table (Id int, AdmittedDate datetime2)

insert into Patient (PType, FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id, inserted.AdmittedDate into @InsertedInPatientIdTable1
values ('I', 'Fatma', 'Ahmed', '1997-12-03', '0100876543','F', null, 'Giza', 'Egypt')

declare @InsertedInPatientId1 int, @InsertedInPatientAdmittedDate1 datetime2
select @InsertedInPatientId1 = Id, @InsertedInPatientAdmittedDate1 = AdmittedDate from @InsertedInPatientIdTable1

insert into InPatient (Id, RoNum, DischargeDate)
values (@InsertedInPatientId1, 100, DATEADD(day, 7, @InsertedInPatientAdmittedDate1))

--------------------------------------------------------------------------------------------------
--Second patient
declare @InsertedInPatientIdTable2 table (Id int, AdmittedDate datetime2)

insert into Patient (PType, FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id, inserted.AdmittedDate into @InsertedInPatientIdTable2
values ('I', 'Hana', 'Khaled', '1998-06-15', '0101876543', 'F', 'Talaat Harb St', 'Cairo', 'Egypt');

declare @InsertedInPatientId2 int, @InsertedInPatientAdmittedDate2 datetime2
select @InsertedInPatientId2 = Id, @InsertedInPatientAdmittedDate2 = AdmittedDate from @InsertedInPatientIdTable2

insert into InPatient (Id, RoNum, DischargeDate)
values (@InsertedInPatientId2, 101, DATEADD(day, 5, @InsertedInPatientAdmittedDate2))

--------------------------------------------------------------------------------------------------
--Third patient
declare @InsertedInPatientIdTable3 table (Id int, AdmittedDate datetime2)

insert into Patient (PType, FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id, inserted.AdmittedDate into @InsertedInPatientIdTable3
values ('I', 'Omar', 'Ibrahim', '1990-03-12', '0106876543', 'M', 'Corniche Rd', 'Alexandria', 'Egypt');

declare @InsertedInPatientId3 int, @InsertedInPatientAdmittedDate3 datetime2
select @InsertedInPatientId3 = Id, @InsertedInPatientAdmittedDate3 = AdmittedDate from @InsertedInPatientIdTable3

insert into InPatient (Id, RoNum, DischargeDate)
values (@InsertedInPatientId3, 102, DATEADD(day, 8, @InsertedInPatientAdmittedDate3))

--------------------------------------------------------------------------------------------------
--Forth patient
declare @InsertedInPatientIdTable4 table (Id int, AdmittedDate datetime2)

insert into Patient (PType, FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id, inserted.AdmittedDate into @InsertedInPatientIdTable4
values ('I', 'Youssef', 'Ali', '1992-04-22', '0109976543', 'M', 'Shubra Rd', 'Cairo', 'Egypt');

declare @InsertedInPatientId4 int, @InsertedInPatientAdmittedDate4 datetime2
select @InsertedInPatientId4 = Id, @InsertedInPatientAdmittedDate4 = AdmittedDate from @InsertedInPatientIdTable4

insert into InPatient (Id, RoNum, DischargeDate)
values (@InsertedInPatientId4, 103, DATEADD(day, 6, @InsertedInPatientAdmittedDate4))

--------------------------------------------------------------------------------------------------
--Fifth patient
declare @InsertedInPatientIdTable5 table (Id int, AdmittedDate datetime2)

insert into Patient (PType, FName, LName, DOB, Phone, Gender, Street, City, State, AdmittedDate)
output inserted.Id, inserted.AdmittedDate into @InsertedInPatientIdTable5
values ('I', 'Salma', 'Hussein', '2001-10-08', '0106800543', 'F', 'Nasr St', 'Mansoura', 'Egypt', '2024-12-30 8:00:00');

declare @InsertedInPatientId5 int, @InsertedInPatientAdmittedDate5 datetime2
select @InsertedInPatientId5 = Id, @InsertedInPatientAdmittedDate5 = AdmittedDate from @InsertedInPatientIdTable5

insert into InPatient (Id, RoNum, DischargeDate)
values (@InsertedInPatientId5, 104, DATEADD(day, 8, @InsertedInPatientAdmittedDate5))

--------------------------------------------------------------------------------------------------
--Insert records into Appointment table
insert into Appointment (Date, Note, DId, PId, RId)
values 
	('2024-12-29 5:30:00', 'Follow-up check', 3, 1, 12), ('2024-12-27 10:30:00', 'Routine visit', 1, 2, 12)

insert into Appointment (Date, DId, PId, RId)
values
	('2024-12-30 4:00:00', 2, 3, 11), ('2024-12-28 7:00:00', 5, 5, 11), ('2024-12-30 8:00:00', 1, 10, 12)

insert into Appointment (DId, PId, RId)
values	
	(3, 4, 13), (4, 6, 13), (2, 7, 11)

insert into Appointment (Note, DId, PId, RId)
values 
	('Emergency Appointment', 1, 8, 13), ('Emergency Appointment', 4, 9, 11)

--------------------------------------------------------------------------------------------------
--Insert records into ExaminePatient table
insert into ExaminePatient (DID, PID) 
values 
	(3, 1), (1, 2), (2, 3), (3, 4),(5, 5),
	(4, 6), (2, 7), (1, 8), (4, 9), (1, 10)

--------------------------------------------------------------------------------------------------
--Insert records into Drug table
insert into Drug (Code, Name, RecDosage) 
values 
	(120, 'Panadol', '500mg every 4-6 hours'),
	(121, 'Cataflam', '50mg 2-3 times a day'),
	(122, 'Insulin', '0.1 units/kg/hour IV infusion'),
	(123, 'Aliskiren', 'If Needed'),
	(124, 'Aspirin', '400mg every 4-6 hours'),
	(125, 'Digoxin', '500mg-1000mg every day'),
	(126, 'Voltaren', 'Not exceeding 100 mg per day')

--------------------------------------------------------------------------------------------------
--Insert records into Report table
insert into Report (Disease, Symptom, Diagnosis, DID, PId)
values
  ('Hypertension', 'Dizziness', 'High Blood Pressure', 3, 1),
  ('Diabetes', 'Thirst', 'Type 2 Diabetes', 1, 2),
  ('Cold', 'Sneezing', 'Common Cold', 2, 3),
  ('Flu', 'Fever', 'Influenza', 3, 4),
  ('Migraine', 'Headache', 'Severe Migraine', 5, 5),
  ('Stroke', 'Sudden numbness and difficulty speaking', 'Hemorrhagic Stroke', 4, 6),
  ('Heart Attack', 'Chest pain or pressure', 'NSTEMI', 2, 7),
  ('Stroke', 'Loss of balance', 'Brain Stem Stroke', 1, 8),
  ('Heart Attack', 'Shortness of breath', 'STEMI', 4, 9),
  ('Rheumatoid Arthritis (RA)', 'Persistent joint pain and swelling', 'Seropositive RA (with specific antibodies)', 1, 10)

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
(10, 123, '150mg If Needed'),
(11, 122, '0.1 units/kg/hour IV infusion'),
(12, 120, '350mg Tablet every 4-6 hours'),
(13, 120, '400mg Tablet every 4-6 hours'),
(14, 121, '50mg Tablet 2-3 times a day'),
(15, 124, '400mg Tablet every 4-6 hours'),
(16, 125, '500mg every day for 5 days'),
(17, 124, '300mg Tablet every 4-6 hours'),
(18, 125, '700mg every day for 7 days'),
(19, 126, '100 mg once daily')
 
--------------------------------------------------------------------------------------------------
--Insert records into Bill table
insert into Bill (Amount, PId, RID)
values
  (150, 1, 11),
  (200, 2, 12),
  (300, 3, 12),
  (400, 4, 11),
  (500, 5, 13),
  (10000, 6, 13),
  (20000, 7, 12),
  (15000, 8, 11),
  (25000, 9, 11),
  (500, 10, 12)

--------------------------------------------------------------------------------------------------
----Insert records into GivenDrug table
--insert into GivenDrug (Dosage, GivenDate, DrugCode, Inpid, NID) 
--values 
--('500mg tablet', '2024-12-01', 124, 6, 6)
--('50mg tablet', '2024-12-02', 125, 7, 7),
--('500mg tablet', '2024-12-04', 124, 8, 8),
--('350mg tablet', '2024-12-02', 125, 9, 9),
--('400mg tablet', '2024-12-03', 126, 10, 10)