CREATE PROCEDURE USP_updateLastReadTODO @UserId INT
AS
BEGIN
IF EXISTS (SELECT TOP 1 1 FROM MasterUser WHERE UserId = @UserId)
BEGIN
UPDATE MasterUser SET TODOCheck = GETDATE() WHERE UserId = @UserId
SELECT 'TODO details added sucessfully.' [Message], 200 SuccessCode
END
ELSE 
BEGIN
SELECT 'User not exists.' [Message], 400 SuccessCode
END
END