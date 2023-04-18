 CREATE PROCEDURE [dbo].[USP_UserRefreshToken]  

 (  @ExpiredToken  nvarchar(max) ,  @RefreshToken  nvarchar(max) ,  @IpAddress  nvarchar(100)=NULL ) 

 AS BEGIN
SELECT
	UserRefreshTokenId
   ,Token
   ,RefreshToken
   ,CreateDate
   ,ExpiretionDate
   ,IsActive
   ,IpAddress
   ,InValidated
FROM UserRefreshToken
WHERE InValidated = 0
AND Token = @ExpiredToken
AND RefreshToken = @RefreshToken
--AND IpAddress = @IpAddress;
END