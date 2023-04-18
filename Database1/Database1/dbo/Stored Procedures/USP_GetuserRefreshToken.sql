
create PROCEDURE [dbo].[USP_GetuserRefreshToken]
 @Token nvarchar(max),
 @RefreshToken nvarchar(300),
 @IsInvalidated bit
AS

BEGIN

      SET NOCOUNT ON;
	 select Token, RefreshToken, UserId, CreateDate, ExpiretionDate,IsActive,IpAddress,InValidated
	 from UserRefreshToken where 
	 InValidated=@IsInvalidated and Token=@Token and RefreshToken=@RefreshToken
	 
     -- select  @id  id ,SuccessCode=200,Message='User Add Successfully'
END