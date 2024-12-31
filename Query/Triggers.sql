use Hospital

--------------------------------------------------------------------------------------------------
--UpdateRoomCapacityOnInsertPatient Trigger
go
create or alter trigger Trg_UpdateRoomCapacityOnInsertPatient
on InPatient
after insert
as
begin
    begin try
        begin transaction

        update Room
        set CurrentCapacity = CurrentCapacity + 1
        from Room
        inner join inserted i
        on Room.Num = i.RoNum;

        if exists (
            select 1
            from Room
            where CurrentCapacity > MaxCapacity
        )
        begin
            rollback transaction;
            print 'Error: CurrentCapacity exceeds MaxCapacity for one or more rooms.';
            return;
        end

        commit transaction;
        print 'Room capacity updated successfully for the newly admitted patient(s).'

    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction;

        print 'An error occurred while updating the room capacity: ' + error_message();
    end catch
end

--------------------------------------------------------------------------------------------------
--UpdateRoomCapacityOnBillInsert Trigger
go
create or alter trigger Trg_UpdateRoomCapacityOnBillInsert
on Bill
after insert
as
begin
    begin try
        begin transaction

        update Room
        set CurrentCapacity = CurrentCapacity - 1
        from Room r
        join InPatient ip on ip.RoNum = r.Num
        join inserted i on ip.Id = i.PId
        where exists (
            select 1 
            from Patient p 
            where p.Id = i.PId and p.PType = 'I'
        );

        if exists (
            select 1
            from Room
            where CurrentCapacity < 0
        )
        begin
            rollback transaction;
            print 'Error: CurrentCapacity cannot be less than zero.';
            return;
        end

        declare @RowsAffected int;
        set @RowsAffected = @@ROWCOUNT;

        commit transaction;

        if @RowsAffected > 0
        begin
            print cast(@RowsAffected as varchar) + ' room(s) updated successfully.';
        end

    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction;

        print 'An error occurred while updating the room capacity: ' + error_message();
    end catch
end

--------------------------------------------------------------------------------------------------
--UpdatePatientTypeToInPatient Trigger
go
create or alter trigger Trg_UpdatePatientTypeToInPatient
on InPatient
after insert
as
begin
    begin try
        update Patient
        set PType = 'I'
        from Patient
        inner join inserted i
        on Patient.Id = i.Id

        print 'Patient type updated to "I" for the newly inserted InPatient.'
    end try
    begin catch
        print 'An error occurred while updating Patient type to "I": ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--UpdatePatientTypeToOutPatient Trigger
go
create or alter trigger Trg_UpdatePatientTypeToOutPatient
on OutPatient
after insert
as
begin
    begin try
        update Patient
        set PType = 'O'
        from Patient
        inner join inserted i
        on Patient.Id = i.Id

        print 'Patient type updated to "O" for the newly inserted OutPatient.'
    end try
    begin catch
        print 'An error occurred while updating Patient type to "O": ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--UpdatePatientDoctorOnInsertAppointment Trigger
go
create or alter trigger Trg_UpdatePatientDoctorOnInsertAppointment
on Appointment
after insert
as
begin
    update Patient
    set DId = i.DId
    from Patient p
    join inserted i on p.Id = i.PId
    where i.Status != 'Cancelled'
	
	print 'Doctor of Patient updated'
end

--------------------------------------------------------------------------------------------------
--InsertExamineInPatientOnAppointment Trigger
go
create or alter trigger Trg_InsertExamineInPatientOnAppointment
on Appointment
after insert
as
begin
    insert into ExamineInPatient (DID, InPID, date)
    select 
        i.DId, ip.Id, i.Date
    from 
        inserted i
    join Patient p on i.PId = p.Id
    join InPatient ip on p.Id = ip.Id
    where 
        i.Status = 'Done'

    print 'ExamineInPatient record inserted successfully for InPatients with completed appointments.'
end

--------------------------------------------------------------------------------------------------
--InsertExamineInPatientOnUpdateAppointmentStatus Trigger
go
create or alter trigger Trg_InsertExamineInPatientOnUpdateAppointmentStatus
on Appointment
after update
as
begin
    insert into ExamineInPatient (DID, InPID, date)
    select 
        i.DId, ip.Id, i.Date
    from 
        inserted i
    join deleted d on i.Id = d.Id
    join Patient p on i.PId = p.Id
    join InPatient ip on p.Id = ip.Id
    where 
        i.Status = 'Done' and d.Status != 'Done' 

    print 'ExamineInPatient record inserted successfully for InPatients with updated completed appointments.'
end

--------------------------------------------------------------------------------------------------
