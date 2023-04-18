

CREATE  PROCEDURE USP_getAdminUserLoginDetails(@_LoginId VARCHAR(50))
AS
BEGIN
SELECT UserId,FirstName,LastName,LoginId,Password,MobileNo,Email
 FROM MasterUser
WHERE IsActive=1 AND LoginId=@_LoginId;
END
