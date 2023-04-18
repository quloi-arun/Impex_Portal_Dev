
Create PROCEDURE [dbo].[USP_UpdateMFADate]
@UserId int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE MasterUser SET MFADate = GETDATE()
	WHERE UserId= @UserId      	 
END
