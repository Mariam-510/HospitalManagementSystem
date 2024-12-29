Use Hospital

--------------------------------------------------------------------------------------------------
--Department table
create table Department
(
    Id int identity(100,1) primary key,
    Name varchar(100) not null unique
)

--------------------------------------------------------------------------------------------------
--Employee table
create table Employee 
(
    Id int identity(1,1) primary key,
    EmpType char(1) not null check (EmpType in ('D', 'N', 'R')), -- restrict to D, N, or R
    Fname varchar(50) not null,
    Lname varchar(50) not null,
    DOB date not null,
    Phone varchar(15) not null unique,
    Gender char(1) not null check (Gender in ('M', 'F')),    -- restrict to M, F
    Street varchar(100),
    City varchar(50) default 'Cairo',
    State varchar(50) default 'Egypt',
    DeptID int foreign key references Department(id)
)

--------------------------------------------------------------------------------------------------
--Doctor table
create table Doctor
(
    Id int primary key foreign key references Employee(id),
    Speciality nvarchar(100) not null
)

--------------------------------------------------------------------------------------------------
--Nurse table
create table Nurse 
(
    Id int primary key foreign key references Employee(id)
)

--------------------------------------------------------------------------------------------------
--Receptionist table
create table Receptionist 
(
    Id int primary key foreign key references Employee(id)
)

--------------------------------------------------------------------------------------------------
--Room Table
Create Table Room 
(
	Num int primary key identity (100,1),
	MaxCapacity int not null check(MaxCapacity > 0),
	CurrentCapacity int check(CurrentCapacity > 0),
	NId int foreign key references Nurse(Id)
)

--------------------------------------------------------------------------------------------------
--Patient Table
create table Patient
(
	Id int primary key identity(1,1),
	PType varchar(2) check (PType in ('I', 'O')),
	FName varchar(50) not null,
	LName varchar(50),
	DOB date,
	Phone varchar(15) not null,
	Gender varchar(1) check (Gender in ('M', 'F')),
	Street varchar(50),
	City varchar(50) default 'Cairo',
	State varchar(50) default 'Egypt',
	DId int foreign key references Doctor(Id),
)

--------------------------------------------------------------------------------------------------
--InPatient Table
create table InPatient
(
	Id int primary key foreign key references Patient(Id),
	RoNum int foreign key references Room(Num) not null
)

--------------------------------------------------------------------------------------------------
--OutPatient Table
create table OutPatient
(
	Id int primary key foreign key references Patient(Id)
)

--------------------------------------------------------------------------------------------------
--Appointment Table
create table Appointment
(
	Id int primary key identity(1000,1),
	Date datetime2 not null default getdate(),
	Note varchar(100),
	DId int foreign key references Doctor(Id),
	PId int foreign key references Patient(Id) unique,
	RId int foreign key references Receptionist(Id)
)

--------------------------------------------------------------------------------------------------
--Drug Table
create table Drug
(
	Code int primary key,
	Name varchar(50) not null,
	RecDosage varchar(50)
)

--------------------------------------------------------------------------------------------------
--Prescription Table
create table Prescription
(
	Id int primary key identity (10,1),
	Description varchar(max) not null,
	PID int foreign key references Patient(Id) unique,
)

--------------------------------------------------------------------------------------------------
--PrescriptionDoctor Table
create Table PrescriptionDoctor 
(
    PreID int foreign key references Prescription(Id),
	DId int foreign key references Doctor(Id),
	Date datetime2 default getdate(),
	constraint Prescription_Doctor_PK primary Key(PreID, DId, Date)
)

--------------------------------------------------------------------------------------------------
--Report Table
Create Table Report
(
	Id int primary key identity (10,1),
	Disease varchar(100) not null,
	Symptom  varchar(100) not null,
	Diagnosis varchar(100) not null,
	PId int foreign key references Patient(Id) unique
)

--------------------------------------------------------------------------------------------------
--ReportDoctor Table
create Table ReportDoctor 
(
    RepID int foreign key references Report(Id),
	DId int foreign key references Doctor(Id),
	Date datetime2 default getdate(),
	constraint Report_Doctor_PK primary Key(RepID, DId, Date)
)

--------------------------------------------------------------------------------------------------
--Bill Table
Create Table Bill
(
	Id int primary key identity (10,1),
	Date datetime2 not null default getDate(),
	Amount money not null check(Amount > 0),
	PId int foreign key references Patient(Id) unique,
	RID int foreign key references Receptionist(Id)
)

--------------------------------------------------------------------------------------------------
--ExaminePatient Table
create Table ExamineInPatient 
(
    DID int foreign key references Doctor(Id),
    InPID int foreign key references InPatient(Id),
	date datetime2 default getdate(),
	constraint E_Patient_PK primary Key(DID, InPID, date)
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
	constraint Give_Drug_PK primary Key(GivenDate, DrugCode, Inpid, NID)
)