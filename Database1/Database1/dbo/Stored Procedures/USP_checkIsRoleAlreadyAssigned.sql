


CREATE PROCEDURE USP_checkIsRoleAlreadyAssigned(@_UserId int)
As
BEGIN
IF EXISTS(SELECT 1 FROM RoletoUserMapping WHERE UserId=@_UserId)
BEGIN
SELECT 'true' Status;
END
ELSE
BEGIN
SELECT 'false' Status;
END
END

