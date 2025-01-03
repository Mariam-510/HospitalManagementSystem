use Hospital

--------------------------------------------------------------------------------------------------
--UpdatePatient Proc
go
create or alter procedure SP_UpdatePatient @PatientID int, @FName varchar(50) = null, @LName varchar(50) = null, @DOB date = null, 
	@Phone varchar(15) = null, @Gender varchar(1) = null, @Street varchar(50) = null, @City varchar(50) = null, @State varchar(50) = null
as
begin
    begin try
        -- Check if the patient exists
        if not exists (select 1 from Patient where Id = @PatientID)
        begin
            print 'Error: The specified patient does not exist.';
            return;
        end

        -- Update the patient record
        update Patient
        set
            FName = coalesce(@FName, FName),
            LName = coalesce(@LName, LName),
            DOB = case when @DOB is null or @DOB <= getdate() then coalesce(@DOB, DOB) else DOB end,
            Phone = coalesce(@Phone, Phone),
            Gender = case when @Gender is null or @Gender in ('M', 'F') then coalesce(@Gender, Gender) else Gender end,
            Street = coalesce(@Street, Street),
            City = coalesce(@City, City),
            State = coalesce(@State, State)
        where Id = @PatientID;

        print 'Patient record updated successfully.';
    end try
    begin catch
        print 'An error occurred while updating the patient record: ' + error_message();
    end catch
end;

go
exec SP_UpdatePatient @PatientID = 1, @Phone = '0121234568',  @Street = 'Haram';

--------------------------------------------------------------------------------------------------
--UpdateInPatientRoom Proc
go
create or alter procedure SP_UpdateInPatientRoom @InPatientID int, @NewRoNum int
as
begin
    begin try
        -- Check if the InPatient record exists
        if not exists (select 1 from InPatient where Id = @InPatientID)
        begin
            print 'Error: The specified inpatient does not exist.';
            return;
        end;

        -- Check if the new room number exists in the Room table
        if not exists (select 1 from Room where Num = @NewRoNum)
        begin
            print 'Error: The specified room number does not exist.';
            return;
        end;

        -- Update the room number for the inpatient
        update InPatient
        set RoNum = @NewRoNum
        where Id = @InPatientID;

        print 'InPatient room number updated successfully.';
    end try
    begin catch
        print 'An error occurred while updating the inpatient record: ' + error_message();
    end catch
end;

go
exec SP_UpdateInPatientRoom @InPatientID = 7, @NewRoNum = 100
go
exec SP_UpdateInPatientRoom @InPatientID = 8, @NewRoNum = 104
go
exec SP_UpdateInPatientRoom @InPatientID = 8, @NewRoNum = 100
--------------------------------------------------------------------------------------------------
--UpdateAppointment Proc
go
create or alter procedure SP_UpdateAppointment @AppointmentID int, @NewNote varchar(100) = null,
    @NewStatus varchar(20) = null, @NewDId int = null, @NewRId int = null
as
begin
    begin try
        -- Validate that the appointment exists
        if not exists (select 1 from Appointment where Id = @AppointmentID)
        begin
            print 'Error: The specified appointment does not exist.';
            return;
        end;

        -- Validate the new status if provided
        if @NewStatus is not null and @NewStatus not in ('Assigned', 'Done', 'Cancelled')
        begin
            print 'Error: Invalid status value provided.';
            return;
        end;

        -- Validate the new doctor ID if provided
        if @NewDId is not null and not exists (select 1 from Doctor where Id = @NewDId)
        begin
            print 'Error: The specified doctor ID does not exist.';
            return;
        end;

        -- Validate the new receptionist ID if provided
        if @NewRId is not null and not exists (select 1 from Receptionist where Id = @NewRId)
        begin
            print 'Error: The specified receptionist ID does not exist.';
            return;
        end;

        -- Update the appointment record
        update Appointment
        set
            Note = coalesce(@NewNote, Note),
            Status = coalesce(@NewStatus, Status),
            DId = coalesce(@NewDId, DId),
            RId = coalesce(@NewRId, RId)
        where Id = @AppointmentID;

        print 'Appointment updated successfully.';
    end try
    begin catch
        print 'An error occurred while updating the appointment: ' + error_message();
    end catch
end;


insert into InPatient
Values (15,100)

go
exec SP_UpdateAppointment @AppointmentID = 1014,  @NewNote = 'Follow-up required', @NewDId = 3, @NewRId = 11
go
exec SP_UpdateAppointment @AppointmentID = 1011,  @NewNote = 'Follow-up required', @NewDId = 5

--------------------------------------------------------------------------------------------------
--UpdateReport Proc
go
create or alter procedure SP_UpdateReport @ReportId int, @Disease varchar(100) = null, @Symptom varchar(100) = null, 
    @Diagnosis varchar(100) = null, @LatestDIdUpdated int, @LatestDateUpdated datetime2 = NULL
as
begin    
    begin try
        -- Check if the report exists
        if not exists (select 1 from Report where Id = @ReportId)
        begin
            print 'Error: Report with the given Id does not exist.';
            return;
        end

        -- Update the report
        update Report
        set 
            Disease = coalesce(@Disease, Disease),
            Symptom = coalesce(@Symptom, Symptom),
            Diagnosis = coalesce(@Diagnosis, Diagnosis),
            LatestDIdUpdated = @LatestDIdUpdated,
            LatestDateUpdated = coalesce(@LatestDateUpdated, getdate())
        where Id = @ReportId;

        print 'Report updated successfully.';
    end try
    begin catch
        print 'An error occurred while updating the report: ' + error_message();
    end catch
end;

go
exec SP_UpdateReport @ReportId = 17, @Symptom = 'Loss of balance and Sudden trouble seeing in one eyes', 
    @LatestDIdUpdated = 5, @LatestDateUpdated = '2025-01-02 11:30:00';

go
exec SP_UpdateReport @ReportId = 21, @Symptom = 'Shortness of breath, Cough, and Persistent ear pain ', 
    @LatestDIdUpdated = 14, @LatestDateUpdated = '2024-12-27 20:00:00' 

go
exec SP_UpdateReport @ReportId = 19, @LatestDIdUpdated = 3, @LatestDateUpdated = '2024-12-30 09:00:00.00' 

select * from V_AllPatients
select * from Report
select * from ReportDoctor

--------------------------------------------------------------------------------------------------
--UpdateEmployee Proc
go
create or alter procedure SP_UpdateEmployee @EmployeeID int, @FName varchar(50) = NULL, @LName varchar(50) = NULL,
	@DOB date = NULL, @Phone varchar(15) = NULL, @Salary money = NULL, @Gender char(1) = NULL, 
	@Street varchar(100) = NULL, @City varchar(50) = NULL, @State varchar(50) = NULL, @DeptID int = NULL
as
begin
    begin try
        -- check if the employee exists
        if not exists (select 1 from Employee where Id = @EmployeeID)
        begin
            print 'Error: The specified employee does not exist.';
            return;
        end

        -- update the employee record
        update Employee
        set
            FName = coalesce(@FName, FName),
            LName = coalesce(@LName, LName),
            DOB = case when @DOB is null or @DOB <= getdate() and year(getdate()) - year(@DOB) >= 18 then coalesce(@DOB, DOB) else DOB end,
            Phone = coalesce(@Phone, Phone),
            Salary = case when @Salary > 0 then coalesce(@Salary, Salary) else Salary end,
            Gender = case when @Gender is null or @Gender in ('M', 'F') then coalesce(@Gender, Gender) else Gender end,
            Street = coalesce(@Street, Street),
            City = coalesce(@City, City),
            State = coalesce(@State, State),
            DeptID = coalesce(@DeptID, DeptID)
        where Id = @EmployeeID;

        print 'Employee record updated successfully.';
    end try
    begin catch
        print 'An error occurred while updating the employee record: ' + error_message();
    end catch
end;

go
exec SP_UpdateEmployee @EmployeeID= 1, @Salary=16700;

--------------------------------------------------------------------------------------------------
--UpdateDoctor Proc
go
create or alter procedure SP_UpdateDoctor @DoctorID int, @Speciality varchar(100)
as
begin
    begin try
        -- check if the doctor exists
        if not exists (select 1 from Doctor where Id = @DoctorID)
        begin
            print 'Error: The specified doctor does not exist.';
            return;
        end

        -- update the doctor record
        update Doctor
        set
            Speciality = coalesce(@Speciality, Speciality)
        where Id = @DoctorID;

        print 'Doctor record updated successfully.';
    end try
    begin catch
        print 'An error occurred while updating the doctor record: ' + error_message();
    end catch
end;
go
exec SP_UpdateDoctor @DoctorID=14 , @Speciality='Dermatology and Cosmetology';

------------------------------------------------------------------------------------------------
go
create or alter procedure SP_UpdateDepartment @DepartmentID int, @Name varchar(100)
as
begin
    begin try
        -- check if the department exists
        if not exists (select 1 from Department where Id = @DepartmentID)
        begin
            print 'Error: The specified department does not exist.';
            return;
        end

        -- update the department record
        update Department
        set
            Name = coalesce(@Name, Name)
        where Id = @DepartmentID;

        print 'Department record updated successfully.';
    end try
    begin catch
        print 'An error occurred while updating the department record: ' + error_message();
    end catch
end;

go
exec SP_UpdateDepartment @DepartmentID=106 , @Name='Dermatology and Cosmetology';
