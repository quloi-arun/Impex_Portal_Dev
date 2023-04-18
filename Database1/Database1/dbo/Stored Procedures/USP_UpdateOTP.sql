CREATE PROCEDURE USP_UpdateOTP
@OTP varchar(10),
@ctime_Stamp datetime,
@UserId int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE MasterUser SET OTP = @OTP,ctime_Stamp=@ctime_Stamp
	WHERE UserId= @UserId      	 
END
