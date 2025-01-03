use Hospital

--------------------------------------------------------------------------------------------------
--GeneratePatientReport proc
go
create or alter procedure GeneratePatientReport @PatientID int
with encryption 
as
begin
    select * from V_PatientCareDetails vp
	where vp.PatientID = @PatientID
end

go
exec GeneratePatientReport @PatientID = 12

--------------------------------------------------------------------------------------------------
--GetBillStatistics proc
go
create or alter procedure GetBillStatistics
with encryption 
as
begin
    select 
        isnull(avg(case when P.PType = 'I' then B.Amount end), 0) as AvgInpatientBill,
        isnull(avg(case when P.PType = 'O' then B.Amount end), 0) as AvgOutpatientBill,
        isnull(max(case when P.PType = 'I' then B.Amount end), 0) as MaxInpatientBill,
        isnull(max(case when P.PType = 'O' then B.Amount end), 0) as MaxOutpatientBill
    from Bill B
    inner join Patient P on B.PId = P.Id
end

go
exec GetBillStatistics

--------------------------------------------------------------------------------------------------
--CheckPatientStatus proc
go
create or alter procedure CheckPatientStatus @PatientID int
with encryption 
as
begin
    -- Check if the patient exists as an inpatient still in the hospital
    if exists (
        select 1 
        from V_InpatientsStillInHospital
        where PatientID = @PatientID
    )
    begin
        select 'The patient is still in the hospital.' as Status,* 
		from Fun_GetPatientData(@PatientID)
    end
    else if exists (
        select 1 
        from V_AllPatients
        where PatientID = @PatientID and PatientType = 'OutPatient'
    )
    begin
        select 'The patient is an outpatient' as Status, * 
		from Fun_GetPatientData(@PatientID)

    end
    else if exists (
        select 1 
        from V_AllPatients
        where PatientID = @PatientID and PatientType = 'InPatient'
    )
    begin
        select 'The patient is an inpatient but has been discharged.' as Status, * 
		from Fun_GetPatientData(@PatientID)
    end
    else
    begin
        select 'The patient ID does not exist in the system.' as Status;
    end
end

go
exec CheckPatientStatus @PatientID = 7;
go
exec CheckPatientStatus @PatientID = 9;
go
exec CheckPatientStatus @PatientID = 5;

--------------------------------------------------------------------------------------------------
--GetInpatientStayDetails proc
go
create or alter procedure GetInpatientStayDetails @PatientID int
with encryption 
as
begin
    -- Check if the patient is an inpatient
    if exists (
        select 1
        from V_AllPatients
        where PatientID = @PatientID and PatientType = 'InPatient'
    )
    begin
        -- Call the view for the specific inpatient
        select *
        from V_InpatientStayDuration
        where PatientID = @PatientID;
    end
    else
    begin
        -- Return a message indicating the patient is not an inpatient
        select 'The specified patient is not an inpatient.' as Message;
    end
end

go
exec GetInpatientStayDetails @PatientID = 7;
go
exec GetInpatientStayDetails @PatientID = 9;
go
exec GetInpatientStayDetails @PatientID = 5;

--------------------------------------------------------------------------------------------------
--GetPatients proc
go
create or alter procedure GetPatients @PatientType varchar(10)
with encryption 
as
begin
    if @PatientType = 'all'
    begin
        select * from V_AllPatients
    end

    else if @PatientType = 'in'
    begin
        select * from V_InPatients
    end

    else if @PatientType = 'out'
    begin
        select * from V_OutPatients
    end

    else
    begin
        print 'Invalid Patient Type! Use "all", "in", or "out".'
    end
end

go
-- To get all patients (both in and out)
exec GetPatients @PatientType = 'all'
go
-- To get only in-patients
exec GetPatients @PatientType = 'in'
go
-- To get only out-patients
exec GetPatients @PatientType = 'out'

-------------------------------------------------------------------------------------------------------
--GetBillsWithRanking proc
go
create or alter procedure GetBillsWithRanking @num int, @type char(20)
with encryption 
as
begin
    if @type not in ('InPatient', 'OutPatient')
    begin
        print 'Invalid patient type. Use ''InPatient'' for inpatient or ''OutPatient'' for outpatient.';
        return;
    end;

    select *
    from 
    (
        select B.*, P.*,
            dense_rank() over (order by B.Amount desc) as RankByAmount
        from Bill B
        inner join V_AllPatients P on B.PId = P.PatientID 
        where P.PatientType = @type
    ) as RankedBills
    where RankByAmount <= @num
    order by RankByAmount;
end;

go
exec GetBillsWithRanking @num = 3, @type = 'InPatient';
go
exec GetBillsWithRanking @num = 5, @type = 'OutPatient';

-------------------------------------------------------------------------------------------------------
--GetEmployees proc
go
create or alter procedure GetEmployees @EmpType varchar(10)
with encryption 
as
begin
    if @EmpType = 'all'
    begin
        select * from V_AllEmployees;
    end

    else if @EmpType = 'd'
    begin
        select * from V_Doctors;
    end

    else if @EmpType = 'n'
    begin
        select * from V_Nurses;
    end
	else if @EmpType = 'r'
    begin
        select * from V_Receptionists;
    end
	else if @EmpType = 'other'
    begin
        select * from V_EmployeesWithOtherTypes;
    end

    else
    begin
        print 'Invalid Patient Type! Use "all", "d", or "n" , or "r" , or "other".';
    end
end

go
-- To get all Employees 
exec GetEmployees @EmpType = 'all';
go
-- To get only doctors
exec GetEmployees @EmpType = 'd';
go
-- To get only nurses
exec GetEmployees @EmpType = 'n';
go
-- To get only receptionists
exec GetEmployees @EmpType = 'r';
go
-- To get employees with other types
exec GetEmployees @EmpType = 'other';

-------------------------------------------------------------------------------------------------------
--TopRankedEmployeesByType proc
go
create or alter procedure Proc_TopRankedEmployeesByType @TopCount int, @EmpType varchar(20)
with encryption 
as
begin
    -- Handle invalid employee type
    if @EmpType not in ('Doctor', 'Nurse', 'Receptionist', 'Unknown')
    begin
        print 'Invalid employee type. Use ''Doctor'', ''Nurse'', ''Receptionist'', or ''Unknown''.';
        return;
    end;

    -- Query with filtering
    select * 
    from (
        select E.*, 
               dense_rank() over (order by E.Salary desc) as RankBySalary
        from V_AllEmployees E
        where E.EmployeeType = @EmpType
    ) as RankedEmployees
    where RankBySalary <= @TopCount
    order by RankBySalary;
end;

go
exec Proc_TopRankedEmployeesByType @TopCount = 5, @EmpType = 'Doctor';
go
exec Proc_TopRankedEmployeesByType @TopCount = 4, @EmpType = 'Nurse';
go
exec Proc_TopRankedEmployeesByType @TopCount = 3, @EmpType = 'Receptionist';
go
exec Proc_TopRankedEmployeesByType @TopCount = 2, @EmpType = 'Unknown';

