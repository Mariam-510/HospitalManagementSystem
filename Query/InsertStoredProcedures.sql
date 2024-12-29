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
            print 'Error: Department name cannot be NULL.'
            return
        end
        if exists (select 1 from Department where Name = @Name)
        begin
            print 'Department already exists'
            return
        end
        insert into Department (Name)
        values (@Name)
        print 'Department inserted successfully.'
    end try
    begin catch
        print 'An error occurred while inserting Department.' + error_message()
    end catch
end

go
exec InsertDepartment 'Dermatology'

--------------------------------------------------------------------------------------------------
--InsertDoctor Proc
go
create or alter procedure InsertDoctor @EmpType char(1), @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Salary money, @Street varchar(100), @City varchar(50) = 'Cairo', 
	@State varchar(50) = 'Egypt', @DeptID int, @Speciality nvarchar(100)  
as
begin
    begin try
        begin transaction

        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Doctor already exists'
            rollback transaction
            return
        end

        if @EmpType != 'D'
        begin
            print 'The employee type must be D (Doctor). No records were inserted.'
            rollback transaction
            return
        end

        declare @NewEmpID int
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Salary, Street, City, State, DeptID)
        values (@EmpType, @Fname, @Lname, @DOB, @Phone, @Gender, @Salary, @Street, @City, @State, @DeptID)
        set @NewEmpID = scope_identity()

        insert into Doctor (Id, Speciality)
        values (@NewEmpID, @Speciality)

        commit transaction
        print 'Doctor inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the doctor: ' + error_message()
    end catch
end

go
exec InsertDoctor @EmpType = 'D', @Fname = 'Ahmed',@Lname = 'Talaat',@DOB = '1980-05-15', @Phone = '04112793478',
@Gender = 'M', @Salary = 12700, @Street = '123 Elm St',@DeptID = 106, @Speciality = 'Dermatology'

--------------------------------------------------------------------------------------------------
--InsertNurse Proc
go
create or alter procedure InsertNurse @EmpType char(1), @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Salary money, @Street varchar(100), 
    @City varchar(50) = 'Cairo', @State varchar(50) = 'Egypt', @DeptID int
as
begin
    begin try
        begin transaction

        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Nurse already exists'
            rollback transaction
            return
        end

        if @EmpType != 'N'
        begin
            print 'The employee type must be N (Nurse). No records were inserted.'
            rollback transaction
            return
        end

        declare @NewEmpID int
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Salary, Street, City, State, DeptID)
        values (@EmpType, @Fname, @Lname, @DOB, @Phone, @Gender,@Salary, @Street, @City, @State, @DeptID)
        set @NewEmpID = scope_identity()

        insert into Nurse (Id)
        values (@NewEmpID)

        commit transaction
        print 'Nurse inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the nurse: ' + error_message()
    end catch
end

go
exec InsertNurse @EmpType = 'N',@Fname = 'Nour',@Lname = 'Adel',@DOB = '1980-05-15', @Phone = '01142793478', @Gender = 'F',
 @Salary = 6660, @Street = '123 Elm St', @DeptID = 106

--------------------------------------------------------------------------------------------------
--InsertReceptionist Proc
go
create or alter procedure InsertReceptionist @EmpType char(1), @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Salary money, @Street varchar(100), 
    @City varchar(50) = 'Cairo', @State varchar(50) = 'Egypt', @DeptID int
as
begin
    begin try
        begin transaction

        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Receptionist already exists'
            rollback transaction
            return
        end

        if @EmpType != 'R'
        begin
            print 'The employee type must be R (Receptionist). No records were inserted.'
            rollback transaction
            return
        end

        declare @NewEmpID int
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Salary, Street, City, State, DeptID)
        values (@EmpType, @Fname, @Lname, @DOB, @Phone, @Gender, @Salary, @Street, @City, @State, @DeptID)
        set @NewEmpID = scope_identity()

        insert into Receptionist (Id)
        values (@NewEmpID)

        commit transaction
        print 'Receptionist inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the receptionist: ' + error_message()
    end catch
end

go
exec InsertReceptionist @EmpType = 'R', @Fname = 'Radwa',@Lname = 'Mohamed',@DOB = '1980-05-15', @Phone = '01342793878', @Gender = 'F',
 @Salary = 4800, @Street = '13 maadi St',@DeptID = 105

--------------------------------------------------------------------------------------------------
--InsertPatient Proc
go
create or alter proc InsertPatient @Fname varchar(50), @Lname varchar(50),@DOB date, @Phone varchar(15),
		@Gender char(1), @Street varchar(100), @City varchar(50) = 'Cairo', @State varchar(50) = 'Egypt'
as
begin
    begin try
        insert into Patient (Fname, Lname, DOB, Phone, Gender, Street, City, State)
        values (@Fname, @Lname, @DOB, @Phone, @Gender, @Street, @City, @State)
    end try
    begin catch
        print 'An error occurred while inserting the Patient.' + error_message()
    end catch
end

go
exec InsertPatient @Fname = 'Kamal', @Lname = 'Saad', @DOB = '1995-08-16', @Phone = '0119876543', @Gender = 'M',
 @Street = 'Al-Haram St', @City = 'Giza'
go
exec InsertPatient @Fname = 'Laila', @Lname = 'Naguib', @DOB = '2000-02-28', @Phone = '0122345678', @Gender = 'F',
 @Street = 'Al-Mokattam St'

--------------------------------------------------------------------------------------------------
--InsertRoom Proc
go
create or alter proc InsertRoom @MaxCapacity int, @CurrentCapacity int, @NId int
as 
 begin 
	begin try
		 insert into Room (MaxCapacity, CurrentCapacity ,NId)
		 values (@MaxCapacity, @CurrentCapacity, @NId)
		 print 'Room record inserted successfully'
	end try
	
	begin catch
		print 'An error occurred while inserting the room.' + error_message()
	end catch
 end 

go
exec InsertRoom @MaxCapacity = 3, @CurrentCapacity = 0,  @NId = 15

--------------------------------------------------------------------------------------------------
--InsertReport Proc
go
create or alter proc InsertReport @Disease varchar(100), @Symptom varchar(100), @Diagnosis varchar(100), 
	@PId int, @DID int, @Date datetime2, @PType char(1), @RoNum int = null
as
begin
    begin try
        begin transaction

        declare @InsertedReport table (Id int)

        insert into Report (Disease, Symptom, Diagnosis, PId)
        output inserted.Id into @InsertedReport
        values (@Disease, @Symptom, @Diagnosis, @PId)
        print 'Report record inserted successfully'

        declare @RepId int
        select @RepId = Id from @InsertedReport

        insert into ReportDoctor (RepId, DId, Date)
        values (@RepId, @DID, @Date)
        print 'ReportDoctor record inserted successfully'

        if @PType = 'O'
        begin
            insert into OutPatient (Id)
            values (@PId)
			
			update Patient
            set PType = 'O'
            where Id = @PId

			print 'OutPatient record inserted successfully'
        end
        else if @PType = 'I'
        begin
            if not exists (select 1 from Room where Num = @RoNum)
            begin
                print 'Room does not exist'
                rollback transaction
                return
            end

            declare @maxCap int, @curCap int
            select @maxCap = MaxCapacity, @curCap = CurrentCapacity 
            from Room where Num = @RoNum

            if @curCap < @maxCap
            begin
                insert into InPatient (Id, RoNum)
                values (@PId, @RoNum)
				
				update Patient
                set PType = 'I'
                where Id = @PId

                update Room
                set CurrentCapacity = CurrentCapacity + 1
                where Num = @RoNum
											
				print 'InPatient record inserted successfully'

            end
            else
            begin
                print 'This room is full'
                rollback transaction
                return
            end
        end
        else
        begin
            print 'The patient type must be I or O. No records were inserted.'
            rollback transaction
            return
        end

        commit transaction
        print 'All recored inserted successfully'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the Report.' + error_message()
    end catch
end

go
exec InsertReport
@Disease = 'Cold', @Symptom = 'Sneezing, Runny Nose', @Diagnosis = 'Allergic Rhinitis', @PId = 11, @DID = 14, 
@Date = '2024-12-30 14:30:00', @PType = 'O'
go
exec InsertReport
@Disease = 'Pneumonia', @Symptom = 'Shortness of breath, Cough', @Diagnosis = 'Bacterial Infection', @PId = 12, @DID = 14,
@Date = '2024-12-27 16:45:00', @PType = 'I', @RoNum = 105

--------------------------------------------------------------------------------------------------
--InsertAppointment Proc
go
create or alter procedure InsertAppointment @AppointmentDate datetime2, @Note varchar(100), @DoctorID int, @PatientID int, @ReceptionistID int          
as
begin
    begin try
        begin transaction

        if not exists (select 1 from Doctor where Id = @DoctorID)
        begin
            print 'Doctor ID does not exist.'
            rollback transaction
            return
        end

        if not exists (select 1 from Patient where Id = @PatientID)
        begin
            print 'Patient ID does not exist.'
            rollback transaction
            return
        end

        if not exists (select 1 from Receptionist where Id = @ReceptionistID)
        begin
            print 'Receptionist ID does not exist.'
            rollback transaction
            return
        end

        insert into Appointment (Date, Note, DId, PId, RId)
        values (@AppointmentDate, @Note, @DoctorID, @PatientID, @ReceptionistID)

        update Patient
        set DId = @DoctorID
        where Id = @PatientID

        commit transaction

        print 'Appointment inserted successfully and patient assigned to the doctor.'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the appointment: ' + error_message()
    end catch
end

go
exec InsertAppointment @AppointmentDate = '2024-12-30 14:30:00', @Note = 'Follow-up visit', @DoctorID = 14, @PatientID = 11, @ReceptionistID = 16
go
exec InsertAppointment @AppointmentDate = '2024-12-27 16:45:00', @Note = null, @DoctorID = 14, @PatientID = 12, @ReceptionistID = 16

--------------------------------------------------------------------------------------------------
--InsertBill Proc
go
create or alter procedure InsertBill @Amount money, @PId int, @RID int, @Date datetime2
as
begin
    begin try
        begin transaction;

        insert into Bill (Amount, PId, RID, Date)
        values (@Amount, @PId, @RID, @Date);

        declare @PType char(1);
        select @PType = PType
        from Patient 
        where Id = @PId;

        if @PType = 'I'
        begin
            declare @RoNum int;

            select @RoNum = RoNum
            from InPatient
            where Id = @PId;

            update Room
            set CurrentCapacity = CurrentCapacity - 1
            where Num = @RoNum;

            print 'Room capacity updated successfully.';
            
        end

        commit transaction;
        print 'Bill record inserted successfully.';
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction;
        end

        print 'An error occurred while inserting the bill: ' + error_message();
    end catch
end;

go
exec InsertBill @Amount = 300, @PID = 11, @RID = 16, @Date = '2024-12-30 15:00:00'
go
exec InsertBill @Amount = 5000, @PID = 12, @RID = 16, @Date = '2024-12-28 13:00:00'

--------------------------------------------------------------------------------------------------
--InsertDrug Proc
go
create or alter procedure InsertDrug @code int,@name varchar(50), @RecDosage varchar(50) 
as 
begin
	Begin try
		insert into Drug (Code, Name, RecDosage) values (@code, @name, @RecDosage)
		print  'Drug record inserted successfully'
	End try
	Begin catch
		print 'An error occurred while inserting Drug.' + error_message()
	End catch
end

go
exec InsertDrug @code = 127, @name = 'Amoxicillin', @RecDosage = '500 mg every 8 hours'

--------------------------------------------------------------------------------------------------
--InsertExaminePatient Proc
go
create or alter procedure InsertExaminePatient @DID int,@InPID int, @date date
as 
begin
	Begin try
		insert into ExamineInPatient (DID, InPID, date) values (@DID, @InPID, @date)
		print 'ExaminePatient record inserted successfully'
	End try
	Begin catch
		print 'An error occurred while inserting ExaminePatient.' + error_message()
	End catch
end

go
exec InsertExaminePatient @DID = 14, @InPID = 12, @Date = '2024-12-27 16:45:00'

--------------------------------------------------------------------------------------------------
--InsertGivenDrug Proc
go
create or alter procedure InsertGivenDrug @Dosage varchar(30),@Date Date,@DragCode int,@Inpid int,@NID int
as 
begin
   Begin try
		insert into GivenDrug (Dosage, GivenDate, DrugCode, Inpid, NID) 
		values(@Dosage,@Date,@DragCode,@Inpid,@NID)
		print 'GivenDrug record inserted successfully'
   End try
   Begin catch
		print 'An error occurred while inserting GivenDrug.' + error_message()
   End catch
end

go
exec InsertGivenDrug @Dosage = '500mg', @Date = '2024-12-27 21:00:00', @DragCode = 127, @Inpid = 12, @NID = 15

--------------------------------------------------------------------------------------------------