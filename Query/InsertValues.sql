use Hospital

-- Insert OutPatient
declare @InsertedPatientIdTable1 table (Id int)

insert into Patient (PType, FName, DOB, Gender)
output inserted.Id into @InsertedPatientIdTable1
values ('O', 'Sara', '1990-07-08', 'F')

declare @InsertedPatientId1 int
select @InsertedPatientId1 = Id from @InsertedPatientIdTable1

insert into OutPatient (Id)
values (@InsertedPatientId1)

--------------------------------------------------------------------------------------------------
-- Insert OutPatient
declare @InsertedPatientIdTable2 table (Id int)

insert into Patient (FName, LName, DOB, Gender, Street)
output inserted.Id into @InsertedPatientIdTable2
values ('Ahmed', 'Mohamed', '2000-05-20', 'M', 'Broadway')

declare @InsertedPatientId2 int
select @InsertedPatientId2 = Id from @InsertedPatientIdTable2

insert into OutPatient (Id)
values (@InsertedPatientId2)

--------------------------------------------------------------------------------------------------
-- Insert InPatient
declare @InsertedPatientIdTable3 table (Id int)

insert into Patient (PType, FName, LName, DOB, Gender, Street, City, State)
output inserted.Id into @InsertedPatientIdTable3
values ('I', 'Ali', 'Omar', '1995-11-05', 'M', 'Park Lane', 'Giza', 'Egypt')

declare @InsertedPatientId3 int
select @InsertedPatientId3 = Id from @InsertedPatientIdTable3

insert into InPatient (Id, RoNum)
values (@InsertedPatientId3, 102)

--------------------------------------------------------------------------------------------------
-- Insert InPatient
declare @InsertedPatientIdTable4 table (Id int)

insert into Patient (PType, FName, Gender)
output inserted.Id into @InsertedPatientIdTable4
values ('I', 'Fatma', 'F')

declare @InsertedPatientId4 int
select @InsertedPatientId4 = Id from @InsertedPatientIdTable4

insert into InPatient (Id)
values (@InsertedPatientId4)

--------------------------------------------------------------------------------------------------
-- Insert OutPatient
declare @InsertedPatientIdTable5 table (Id int)

insert into Patient (FName, Gender, DOB)
output inserted.Id into @InsertedPatientIdTable5
values ('Mahmoud', 'M', '2005-07-07')

declare @InsertedPatientId5 int
select @InsertedPatientId5 = Id from @InsertedPatientIdTable5

insert into OutPatient (Id)
values (@InsertedPatientId5)

--------------------------------------------------------------------------------------------------
-- Insert Appointment
insert into Appointment (Date, Note, DId, PId, RId)
values ('2024-12-29 10:30:00', 'Follow-up check', 0, 1, 0)

insert into Appointment (Note, DId, PId, RId)
values ('Routine visit', 0, 2, 0);

insert into Appointment (Date, DId, PId, RId)
values ('2024-12-30 4:00:00', 0, 3, 0)

insert into Appointment (DId, PId, RId)
values (0, 4, 0);

insert into Appointment (Note, DId, PId, RId)
values ('Emergency Appointment',0, 5, 0)

