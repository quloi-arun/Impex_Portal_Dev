CREATE PROCEDURE USP_updateLastLogin @UserId INT
AS
BEGIN
IF EXISTS (SELECT TOP 1 1 FROM MasterUser WHERE UserId = @UserId)
BEGIN
UPDATE MasterUser SET LastLogin = GETDATE() WHERE UserId = @UserId
SELECT 'Last login details added sucessfully.' [Message], 200 SuccessCode
END
ELSE 
BEGIN
SELECT 'User not exists.' [Message], 400 SuccessCode
END
END