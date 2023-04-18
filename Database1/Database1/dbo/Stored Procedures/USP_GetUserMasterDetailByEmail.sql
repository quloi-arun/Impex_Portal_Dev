

CREATE PROCEDURE [dbo].[USP_GetUserMasterDetailByEmail]
(
@EmaiId VARCHAR(50)
)
AS
BEGIN
SELECT
UserId,FirstName,LastName,MobileNo,Email,
CreateDate
FROM MasterUser 
WHERE IsActive = 1 AND Email=@EmaiId and IsDeleted=0;
END
