Use Hospital

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
RoNum int 
--foreign key references Room(Num)
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
Date datetime2 default getdate(),
Note varchar(100),
DId int,
--foreign key references Doctor(Id)
PId int foreign key references Patient(Id),
RId int
--foreign key references Receptionist(Id)
)

--------------------------------------------------------------------------------------------------

