Create Procedure Usp_GetMasterUserDetailById
(
@Userid int
)
As
Begin
Select * from MasterUser
where userid = @Userid and IsActive = 1 and IsDeleted = 0
end