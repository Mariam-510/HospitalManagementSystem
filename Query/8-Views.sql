use Hospital

--------------------------------------------------------------------------------------------------
--PatientCareDetails  View
go
create or alter view V_PatientCareDetails
with encryption 
as
Select  
	vp.PatientID, vp.FullName, vp.DateOfBirth, vp.Age, vp.PhoneNumber, 
	vp.Gender, vp.StreetAddress, vp.City, vp.State, vp.PatientType,
	vp.DoctorInChargeId, vp.DoctorInChargeName, vp.RoomNumber,

		--Appointment details
	va.AppointmentID, va.AppointmentDate, va.AppointmentStatus,
	va.AppointmentNote, va.DoctorId, va.DoctorName,
	va.ReceptionistId, va.ReceptionistName,

	-- Report details
	vr.ReportID, vr.Disease, vr.Symptom, vr.Diagnosis,
    
	-- Prescription details
	vper.PrescriptionID, vper.PrescriptionDescription,

	-- Bill details
	vb.BillID, vb.TotalBilledAmount, vb.BillDate,
	vb.BillReceptionistId, vb.BillReceptionistName

from
V_AllPatients vp
left join V_AppointmentSummary va on vp.PatientID = va.PatientID
left join V_ReportSummary vr on vp.PatientID = vr.PatientID
left join V_PrescriptionSummary vper on vp.PatientID = vper.PatientID
left join V_BillSummary vb on vp.PatientID = vb.PatientID

go
select * from V_PatientCareDetails

--------------------------------------------------------------------------------------------------
--AllPatients View
go
create or alter view V_AllPatients
with encryption 
as
select 
    p.Id as PatientID, 
    concat_ws(' ', p.FName, p.LName) as FullName,
    case 
        when p.DOB is null then 'No DateOfBirth Provided'
        else cast(p.DOB as varchar)
    end as DateOfBirth,
    case 
        when p.DOB is null then 'No Age Provided'
        else cast(dbo.Fun_CalculateAge(p.DOB) as varchar)
    end as Age,
    p.Phone as PhoneNumber, 
    coalesce(p.Gender, 'Unknown') as Gender,
    coalesce(p.Street, 'No Address Provided') as StreetAddress,  
    p.City as City, 
    p.State as State, 
    case 
        when i.Id is not null then 'InPatient'
        when o.Id is not null then 'OutPatient'
        else 'Unknown'
    end as PatientType,
	coalesce(p.DId, 0) as DoctorInChargeId,
	coalesce(e.FName + ' ' + e.LName, 'No Doctor Assigned') as DoctorInChargeName,
	coalesce(cast(i.RoNum as varchar), 'No Room Assigned') as RoomNumber

from Patient p 
left join InPatient i on p.Id = i.Id
left join OutPatient o on p.Id = o.Id
left join Employee e on p.DId = e.Id

go
select * from V_AllPatients

--------------------------------------------------------------------------------------------------
--InPatients View
go
create or alter view V_InPatients
with encryption 
as 
select 
	PatientID, FullName, DateOfBirth, Age, PhoneNumber, Gender, 
	StreetAddress, City, State, DoctorInChargeId, DoctorInChargeName, RoomNumber
from V_AllPatients
where PatientType = 'InPatient'

go
select * from V_InPatients

--------------------------------------------------------------------------------------------------
--OutPatients View
go
create or alter view V_OutPatients
with encryption 
as
select 
	PatientID, FullName, DateOfBirth, Age, PhoneNumber, Gender,
	StreetAddress, City, State, DoctorInChargeId, DoctorInChargeName
from V_AllPatients
where PatientType = 'OutPatient'

go
select * from V_OutPatients

--------------------------------------------------------------------------------------------------
--AppointmentSummary View
go
create or alter view V_AppointmentSummary
with encryption 
as
select 
    p.Id as PatientID,
    concat(p.FName, ' ', p.LName) as PatientName,
    coalesce(a.Id, 0) as AppointmentID,
    coalesce(cast(a.Date as varchar), 'No Appointment Data') as AppointmentDate,
    coalesce(a.Status, 'No Appointment Data') as AppointmentStatus,
    coalesce(a.Note, 'No Note') as AppointmentNote,
    coalesce(a.DId, 0) as DoctorId,
    coalesce(e.Fname + ' ' + e.Lname, 'No Appointment Data') as DoctorName,
    coalesce(a.RId, 0) as ReceptionistId,
    coalesce(r.Fname + ' '+ r.Lname, 'No Appointment Data') as ReceptionistName
from Patient p 
left join Appointment a on a.PId = p.Id
left join Employee e on a.DId = e.Id
left join Employee r on a.RId = r.Id

go
select * from V_AppointmentSummary

--------------------------------------------------------------------------------------------------
--PrescriptionSummary View
go
create or alter view V_PrescriptionSummary
with encryption 
as
select 
    P.Id as PatientID,
    concat(P.FName, ' ', P.LName) as PatientName,
    coalesce(pre.Id, 0) as PrescriptionID,
    coalesce(pre.Description, 'No Prescription Data') as PrescriptionDescription
from Patient P 
left join Prescription pre on p.Id = pre.PID

go
select * from V_PrescriptionSummary

--------------------------------------------------------------------------------------------------
--ReportSummary View
go
create or alter view V_ReportSummary
with encryption 
as
select 
    P.Id as PatientID,
    concat(P.FName, ' ', P.LName) as PatientName,
    coalesce(r.Id, 0) as ReportID,
    coalesce(r.Disease, 'No Report Data') as Disease,
    coalesce(r.Symptom, 'No Report Data') as Symptom,
    coalesce(r.Diagnosis, 'No Report Data') as Diagnosis
from Patient P 
left join Report r on r.PId = p.Id

go
select * from V_ReportSummary

--------------------------------------------------------------------------------------------------
--BillSummary View
go
create or alter view V_BillSummary
with encryption
as 
select 
    P.Id as PatientID,
    concat(P.FName, ' ', P.LName) as PatientName,
    coalesce(B.Id, 0) as BillID,
    coalesce(B.Amount, 0) as TotalBilledAmount,
    coalesce(cast(B.Date as varchar), 'No Bill Data') as BillDate,
    coalesce(B.RID, 0) as BillReceptionistId,
    coalesce(e.FName+ ' '+ e.LName, 'No Bill Data') as BillReceptionistName
from Patient P 
left join Bill B on P.Id = B.PId 
left join Employee e on B.RID = e.Id 

go
select * from V_BillSummary

--------------------------------------------------------------------------------------------------
--RoomsSummary View
go
create or alter view V_RoomsSummary
with encryption
as 
select 
    R.Num as RoomNumber,
    R.MaxCapacity,
    R.CurrentCapacity,
    N.Id as NurseId,
    E.FName + ' ' + E.LName  as NurseInChargeName
from Room R left join Nurse N 
on R.NId =N.Id left join Employee E
on N.Id = E.Id

go
select * from V_RoomsSummary

--------------------------------------------------------------------------------------------------
--OccupiedRooms View
go
create or alter view V_OccupiedRooms 
with encryption
as 
select *
from V_RoomsSummary
where CurrentCapacity > 0

go
select * from V_OccupiedRooms

--------------------------------------------------------------------------------------------------
--RoomUtilization View
go
Create or alter view V_RoomUtilization
with Encryption
as
Select 
    VR.RoomNumber,
    VR.MaxCapacity,
    VR.CurrentCapacity,
    Round((CAST(VR.CurrentCapacity as float) / VR.MaxCapacity) * 100 , 2)
	as UtilizationPercentage
from V_RoomsSummary VR;

go
Select * from V_RoomUtilization;

--------------------------------------------------------------------------------------------------
--InpatientStayDuration View
go
create or alter view V_InpatientStayDuration
with encryption
as
select 
    P.PatientID, P.FullName, P.RoomNumber,
    datediff(
        day, 
        A.Date, 
        coalesce(B.Date, getdate()) -- Use B.Date if available, otherwise use current date
    ) as DaysInHospital,
    A.Date as AppointmentDate,
    coalesce(cast(B.Date as varchar), 'No Bill yet Still in Hospital') as BillDate

from V_AllPatients P
inner join Appointment A on P.PatientID = A.PId
left join Bill B on P.PatientID = B.PId
where P.PatientType = 'InPatient'

go
select * from V_InpatientStayDuration
order by DaysInHospital desc

--------------------------------------------------------------------------------------------------
--InpatientsStillInHospital View
go
create or alter view V_InpatientsStillInHospital
with encryption
as
select 
    P.PatientID, P.FullName, P.RoomNumber

from V_AllPatients P
where P.PatientType = 'InPatient' 
and P.PatientID not in (select b.PId from Bill b)

go
select * from V_InpatientsStillInHospital

--------------------------------------------------------------------------------------------------
--MedicationPrescription View
go
Create or alter view V_MedicationPrescription 
with encryption
as
Select 
    P.Id AS PatientId,
    concat(P.FName, ' ', P.LName) as PatientName,
    D.Code AS DrugCode,
    D.Name AS DrugName,
    D.RecDosage AS RecommendedDosage,
    GD.Dosage AS GivenDosage,
    GD.GivenDate,
	Gd.NID as ByNurseId,
    E.FName + ' ' + E.LName  as ByNurse
from 
Patient P
join InPatient IP ON P.Id = IP.Id
join GivenDrug GD ON IP.Id = GD.InPid
join Drug D ON GD.DrugCode = D.Code
join Employee E on Gd.NID = E.Id;

go
select * from V_MedicationPrescription
order by PatientId

-------------------------------------------------------------------------------------------------
--CountGivenDrugByPatient View
go
Create OR alter view V_CountGivenDrugByPatient 
as
select 
	GD.inpid as PatientId, concat_ws(' ', P.FName, P.LName) as PatientFullName,
	GD.DrugCode , D.Name,
	Count(GD.Dosage) As DosageCount 
from GivenDrug GD
inner join Drug D on GD.DrugCode=D.Code
inner join Patient P on GD.Inpid = P.Id
group by GD.inpid, P.FName, P.LName, GD.DrugCode, D.Name

go
select * from V_CountGivenDrugByPatient 
order by PatientId, DrugCode

--------------------------------------------------------------------------------------------------
--TopPrescribedDrugs View
go
Create OR alter view V_NumOfDrugUsed
with encryption
as
Select
    D.Code AS DrugCode,
    D.Name AS DrugName,
    COUNT(GD.Inpid) AS NumOfDrugUsed
from
Drug D
left join GivenDrug GD ON D.Code = GD.DrugCode
group by D.Code, D.Name

go
select * from V_NumOfDrugUsed
order by NumOfDrugUsed DESC;

-------------------------------------------------------------------------------------------------
--NumOfTimeNurseServedPatient View
go
Create OR alter view V_NumOfTimeNurseServedPatient
as
select 
	Gi.NID as NurseId,
	concat_ws(' ', E.FName, E.LName) as NurseFullName,
	Count(Gi.InPid)As NumOfTimesServedPatient   
from GivenDrug Gi 
inner join InPatient on inpid=id
inner join Employee E on Gi.NID=E.Id
group by Gi.NID,E.Fname,E.Lname 

go
select * from V_NumOfTimeNurseServedPatient
order by NumOfTimesServedPatient desc;

--------------------------------------------------------------------------------------------------
--DepartmentSalaryReport View
--View display avg and total salary of each department
go
create or alter view V_DepartmentSalaryReport 
with encryption 
as
select 
    D.Id as DepartmentId, D.Name as DepartmentName,
	sum(E.Salary) as TotalSalary,
	avg(E.Salary) as AvgSalary
from Employee E
join Department D on E.DeptID = D.Id
group by D.Id, D.Name

go
select * from  V_DepartmentSalaryReport
order by DepartmentId

--------------------------------------------------------------------------------------------------
-- AllEmployees View
go
create or alter view V_AllEmployees
as
select 
    e.Id as EmployeeID,
    concat_ws(' ', e.FName, e.LName) as FullName,
    case 
        when e.DOB is null then 'No DateOfBirth Provided'
        else cast(e.DOB as varchar)
    end as DateOfBirth,
    case 
        when e.DOB is null then 'No Age Provided'
        else cast(dbo.Fun_CalculateAge(e.DOB) as varchar)
    end as Age,
    e.Phone as PhoneNumber,
    coalesce(e.Gender, 'Unknown') as Gender,
    coalesce(e.Street, 'No Address Provided') as StreetAddress,
    e.City as City,
    e.State as State,
    case 
        when e.EmpType = 'D' then 'Doctor'
        when e.EmpType = 'N' then 'Nurse'
        when e.EmpType = 'R' then 'Receptionist'
        else 'Unknown'
    end as EmployeeType,
    e.Salary as Salary,
	coalesce(cast(E.DeptID as varchar), 'No Department') as DepartmentID,	
	coalesce(d.Name, 'No Department') as DepartmentName

from Employee e
left join Department d on e.DeptID = d.Id;

go
select * from V_AllEmployees;

--------------------------------------------------------------------------------------------------
-- Doctors View
go
create or alter view V_Doctors
as
select ve.*, d.Speciality as Speciality
from Doctor d
inner join V_AllEmployees ve on d.Id = ve.EmployeeID

go
select * from V_Doctors;

-------------------------------------------------------------------------------------------------
-- Nurses View
go
create or alter view V_Nurses
as
select ve.*
from Nurse n
inner join V_AllEmployees ve on n.Id = ve.EmployeeID

go
select * from V_Nurses;

----------------------------------------------------------------------------------------
-- Receptionists View
go
create or alter view V_Receptionists
as
select ve.*
from Receptionist r
inner join V_AllEmployees ve on r.Id = ve.EmployeeID

go
select * from V_Receptionists;

-------------------------------------------------------------------------------------------------
-- EmployeesWithNullType View
go
create or alter view V_EmployeesWithOtherTypes
as
select ve.*
from V_AllEmployees ve
where EmployeeType = 'Unknown'

go
select * from V_EmployeesWithOtherTypes;
