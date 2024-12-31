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


