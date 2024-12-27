Use Hospital

--------------------------------------------------------------------------------------------------
--Department table
create table Department
(
    Id int identity(100,1) primary key,
    Name nvarchar(100) not null
)

--------------------------------------------------------------------------------------------------
--Employee table
create table Employee 
(
    Id int identity(1,1) primary key,
    EmpType char(1) not null check (EmpType in ('D', 'N', 'R')), -- restrict to D, N, or R
    Fname nvarchar(50) not null,
    Lname nvarchar(50) not null,
    DOB date not null,
    Phone nvarchar(15),
    Gender char(1) not null check (Gender in ('M', 'F')),    -- restrict to M, F
    Street nvarchar(100),
    City nvarchar(50) default 'Cairo',
    State nvarchar(50) default 'Egypt', --edit
    DeptID int foreign key references Department(id)
)

--------------------------------------------------------------------------------------------------
--Doctor table
create table Doctor (
    Id int primary key foreign key references Employee(id),
    Speciality nvarchar(100) not null
)

--------------------------------------------------------------------------------------------------
--Nurse table
create table Nurse (
    Id int primary key foreign key references Employee(id)
)

--Receptionist table
create table Receptionist (
    Id int primary key foreign key references Employee(id)
);

--------------------------------------------------------------------------------------------------
--Room Table
Create Table Room 
(
 Num int primary key identity (100,1),
 Availblitiy char(1) not null default 'Y', --num or char
 Capacity int,
 NId int foreign key references Nurse(Id)
)

--------------------------------------------------------------------------------------------------
--Patient Table
create table Patient
(
Id int primary key identity(1,1),
PType varchar(2) check (PType in ('I', 'O')) default 'O'not null,
FName varchar(50) not null,
LName varchar(50),
DOB date,
Gender varchar(1) check (Gender in ('M', 'F')),
Street varchar(50),
City varchar(50) default 'Cairo',
State varchar(50) default 'Egypt',
AdmittedDate datetime2 default getdate() 
)

--------------------------------------------------------------------------------------------------
--InPatient Table
create table InPatient
(
Id int primary key foreign key references Patient(Id),
DischargeDate datetime2 default getdate(),
RoNum int foreign key references Room(Num)
)

--------------------------------------------------------------------------------------------------
--OutPatient Table
create table OutPatient
(
Id int primary key foreign key references Patient(Id),
)

--------------------------------------------------------------------------------------------------
--Appointment Table
create table Appointment
(
Id int primary key identity(1000,1),
Date datetime2 not null default getdate(),
Note varchar(100),
DId int foreign key references Doctor(Id),
PId int foreign key references Patient(Id),
RId int foreign key references Receptionist(Id)
)

--------------------------------------------------------------------------------------------------
--Drug Table
create table Drug
(
  code int primary key,
  RecDosage varchar(50)
)

--------------------------------------------------------------------------------------------------
--DrugBrand Table
create Table DrugBrand
(
    DrugCode int foreign key references Drug(code),
    BrandName varchar(50),
	constraint Drug_Brand_pk primary Key(DrugCode, BrandName)
)

--------------------------------------------------------------------------------------------------
--Prescription Table
create table Prescription
(
  Id int primary key identity (10,1),
  Date datetime2 not null default getDate(), --edit
  DID int foreign key references Doctor(Id),
  PID int foreign key references Patient(Id) unique --edit
)

--------------------------------------------------------------------------------------------------
--PrescriptionDrug Table
create Table PrescriptionDrug 
(
    PreID int foreign key references Prescription(Id),
	DrugCode int foreign key references Drug(code),
	Dosage varchar(50),
	constraint prescription_Drug_pk primary Key(PreID, DrugCode)
)

--------------------------------------------------------------------------------------------------
--Report Table
Create Table Report
(
 Id int primary key identity (10,1),
 Disease varchar(100) not null,
 Symptom  varchar(100) not null,
 Diagnosis varchar(100),
 PId int foreign key references Patient(Id) unique, --edit
 DID int foreign key references Doctor(Id)
)

--------------------------------------------------------------------------------------------------
--Bill Table
Create Table Bill
(
 Id int primary key identity (10,1),
 Date datetime2 not null default getDate(),
 Amount decimal(10,2) not null, --make it money
 PId int foreign key references Patient(Id) unique, --edit
 RID int foreign key references Receptionist(Id)
)

--------------------------------------------------------------------------------------------------
--ExaminePatient Table
create Table ExaminePatient 
(
    DID int foreign key references Doctor(Id),
    PID int foreign key references Patient(Id),
	constraint E_Patient_pk primary Key(DID, PID)
)

--------------------------------------------------------------------------------------------------
--GivenDrug Table
create Table GivenDrug 
(
    Dosage varchar(50) not null,
	GivenDate datetime2 default getdate(),
    DrugCode int foreign key references Drug(code),
	Inpid int foreign key references InPatient(Id),
    NID int foreign key references Nurse(Id),
	constraint Give_Drug_pk primary Key(GivenDate, DrugCode, Inpid, NID)
)