use Hospital

--------------------------------------------------------------------------------------------------
--CalculateAge function
go
create or alter function Fun_CalculateAge (@DOB date)
returns int
as
begin
    declare @Age int
    set @Age = datediff(year, @DOB, getdate()) 
               - case 
                   when month(@DOB) > month(getdate()) 
                        or (month(@DOB) = month(getdate()) and day(@DOB) > day(getdate())) 
                   then 1 
                   else 0 
                 end
    return @Age
end

--------------------------------------------------------------------------------------------------
--GetPatientData function
go
create or alter function Fun_GetPatientData (@PatientID int)
returns table
as
return
(
    select *
    from V_AllPatients
    where PatientID = @PatientID
)

go
select * from Fun_GetPatientData(12)

--------------------------------------------------------------------------------------------------
--GetPatientDataByPhone function
go
create or alter function Fun_GetPatientDataByPhone (@Phone varchar(15))
returns table
as
return
(
    select *
    from V_AllPatients
    where PhoneNumber = @Phone
)

go
select * from Fun_GetPatientDataByPhone('0101876543');

--------------------------------------------------------------------------------------------------
--GetPatientDataByFullName function
go
create or alter function Fun_GetPatientDataByFullName (@FullName varchar(100))
returns table
as
return
(
    select *
    from V_AllPatients
    where FullName like '%' + @FullName + '%'
)

go
select * from Fun_GetPatientDataByFullName('ahmed');

--------------------------------------------------------------------------------------------------
--GetAppointmentSummaryByPatient function
go
create or alter function Fun_GetAppointmentSummaryByPatient(@PatientID int)
returns table
as
return
(
    select *
    from V_AppointmentSummary
    where PatientID = @PatientID
)

go
select * from Fun_GetAppointmentSummaryByPatient(12)

--------------------------------------------------------------------------------------------------
--GetPrescriptionSummaryByPatientfunction
go
create or alter function Fun_GetPrescriptionSummaryByPatient (@PatientID int)
returns table
as
return
(
    select *
    from V_PrescriptionSummary
    where PatientID = @PatientID
)

go
select * from Fun_GetPrescriptionSummaryByPatient(12)

--------------------------------------------------------------------------------------------------
--GetReportSummaryByPatient function
go
create or alter function Fun_GetReportSummaryByPatient (@PatientID int)
returns table
as
return
(
    select *
	from V_ReportSummary
    where PatientID = @PatientID
)

go
select * from Fun_GetReportSummaryByPatient(12)

--------------------------------------------------------------------------------------------------
--GetBillSummaryByPatient function
go
create or alter function Fun_GetBillSummaryByPatient(@PatientID int)
returns table
as
return
(
    select *
	from V_BillSummary
    where PatientID = @PatientID
)

go
select * from Fun_GetBillSummaryByPatient(12)

--------------------------------------------------------------------------------------------------
--GetRoomsSummary function
go
create or alter function Fun_GetRoomsSummary (@RoomNum int)
returns table
as
return
(
    select *
	from V_RoomsSummary
    where RoomNumber = @RoomNum
)

go
select * from Fun_GetRoomsSummary(102)

--------------------------------------------------------------------------------------------------
--GetDrugData function
go
create or alter function GetDrugData (@c int)
returns table  
as
return 
(
	select * 
	from Drug 
	where Code=@c
)

go
select * from GetDrugData(127)

--------------------------------------------------------------------------------------------------
--GetEmployeeData function
go
create or alter function Fun_GetEmployeeData (@EmployeeID int)
returns table
as
return
(
    select *
    from V_AllEmployees
    where EmployeeID = @EmployeeID
)
go
select * from dbo.Fun_GetEmployeeData(11);
select * from dbo.Fun_GetEmployeeData(1);
select * from dbo.Fun_GetEmployeeData(6);
select * from dbo.Fun_GetEmployeeData(17);


--------------------------------------------------------------------------------------------------
--GetEmployeeDataByPhone function
go
create or alter function Fun_GetEmployeeDataByPhone (@Phone varchar(15))
returns table
as
return
(
    select *
    from V_AllEmployees
    where PhoneNumber = @Phone
)

go
select * from Fun_GetEmployeeDataByPhone('0123454321');

--------------------------------------------------------------------------------------------------
--GetEmployeeDataFullName function
go
create or alter function Fun_GetEmployeeDataByFullName (@FullName varchar(100))
returns table
as
return
(
    select *
    from V_AllEmployees
    where FullName like '%' + @FullName + '%'
)

go
select * from Fun_GetEmployeeDataByFullName('ahmed');


