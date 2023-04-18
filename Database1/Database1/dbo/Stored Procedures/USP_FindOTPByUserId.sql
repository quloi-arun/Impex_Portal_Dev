create proc USP_FindOTPByUserId
@UserId int
AS BEGIN
SET NOCOUNT ON;
 select  UserId,FirstName,LastName,Email,OTP,ctime_Stamp  from MasterUser where UserId=@UserId
END