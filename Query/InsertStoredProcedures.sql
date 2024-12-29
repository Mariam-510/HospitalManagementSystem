 Use Hospital

--------------------------------------------------------------------------------------------------
--InsertDepartment Proc
 go
 create or alter procedure InsertDepartment
    @Name varchar(100)
as
begin
    begin try
        if @Name is null
        begin
            print 'Error: Department name cannot be NULL.';
            return;
        end
        if exists (select 1 from Department where Name = @Name)
        begin
            print 'Department already exists';
            return;
        end
        insert into Department (Name)
        values (@Name);
        print 'Department inserted successfully.';
    end try
    begin catch
        print 'Error occurred while inserting Department.' + error_message();
    end catch
end;

--------------------------------------------------------------------------------------------------
--InsertDoctor Proc
go
create or alter procedure InsertDoctor @EmpType char(1), @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Street varchar(100), @City varchar(50) = 'Cairo',
    @State varchar(50) = 'Egypt', @DeptID int, @Speciality nvarchar(100)  
as
begin
    begin try
        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Doctor already exists';
            return;
        end
        if @EmpType != 'D'
        begin
            print 'The employee type must be D (Doctor). No records were inserted.';
            return;
        end
        declare @NewEmpID int;
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Street, City, State, DeptID)
        values (@EmpType, @Fname, @Lname, @DOB, @Phone, @Gender, @Street, @City, @State, @DeptID);
        set @NewEmpID = scope_identity();
        insert into Doctor (Id, Speciality)
        values (@NewEmpID, @Speciality);
        print 'Doctor inserted successfully.';
    end try
    begin catch
        print 'Error occurred while inserting the doctor.' + error_message();
    end catch
end;

--------------------------------------------------------------------------------------------------
--InsertNurse Proc
go
create or alter procedure InsertNurse @EmpType char(1), @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Street varchar(100), @City varchar(50) = 'Cairo',
    @State varchar(50) = 'Egypt', @DeptID int
as
begin
    begin try
        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Nurse already exists';
            return;
        end
        if @EmpType != 'N'
        begin
            print 'The employee type must be N (Nurse). No records were inserted.';
            return;
        end
        declare @NewEmpID int;
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Street, City, State, DeptID)
        values (@EmpType, @Fname, @Lname, @DOB, @Phone, @Gender, @Street, @City, @State, @DeptID);
        set @NewEmpID = scope_identity();
        insert into Nurse(Id)
        values (@NewEmpID);
        print 'Nurse inserted successfully.';
    end try
    begin catch
        print 'Error occurred while inserting the nurse.' + error_message();
    end catch
end;

--------------------------------------------------------------------------------------------------
--InsertReceptionist Proc
go
create or alter procedure InsertReceptionist @EmpType char(1), @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Street varchar(100), @City varchar(50) = 'Cairo',
    @State varchar(50) = 'Egypt', @DeptID int
as
begin
    begin try
        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Receptionist already exists';
            return;
        end
        if @EmpType != 'R'
        begin
            print 'The employee type must be R (Receptionist). No records were inserted.';
            return;
        end
        declare @NewEmpID int;
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Street, City, State, DeptID)
        values (@EmpType, @Fname, @Lname, @DOB, @Phone, @Gender, @Street, @City, @State, @DeptID);
        set @NewEmpID = scope_identity();
        insert into Receptionist(Id)
        values (@NewEmpID);
        print 'Receptionist inserted successfully.';
    end try
    begin catch
        print 'Error occurred while inserting the receptionist.' + error_message();
    end catch
end;

--------------------------------------------------------------------------------------------------
--InsertAppointment Proc
go
create or alter procedure InsertAppointment @AppointmentDate datetime2, @Note varchar(100), @DoctorID int, @PatientID int, @ReceptionistID int           
as
begin
    begin try
        if not exists (select 1 from Doctor where Id = @DoctorID)
        begin
            print 'Doctor ID does not exist.';
            return;
        end
        if not exists (select 1 from Patient where Id = @PatientID)
        begin
            print 'Patient ID does not exist.';
            return;
        end
        if not exists (select 1 from Receptionist where Id = @ReceptionistID)
        begin
            print 'Receptionist ID does not exist.';
            return;
        end
        insert into Appointment (Date, Note, DId, PId, RId)
        values (@AppointmentDate, @Note, @DoctorID, @PatientID, @ReceptionistID);
        update Patient set DId = @DoctorID where Id = @PatientID;
        print 'Appointment inserted successfully and patient assigned to the doctor.';
    end try
    begin catch
        print 'An error occurred while inserting the appointment.' + error_message();
    end catch
end;

 --------------------------------------------------------------------------------------------------
--InsertRoom Proc
go
create proc InsertRoom @MaxCapacity int, @CurrentCapacity int, @NId int
as 
 begin 
	begin try
	 insert into Room (MaxCapacity, CurrentCapacity ,NId)
	 values (@MaxCapacity, @CurrentCapacity, @NId)
	 print  'Room record inserted successfully'

	end try
	begin catch
	print 'Error inserting Room record: ' + ERROR_MESSAGE()
	end catch
 end 

 --------------------------------------------------------------------------------------------------
