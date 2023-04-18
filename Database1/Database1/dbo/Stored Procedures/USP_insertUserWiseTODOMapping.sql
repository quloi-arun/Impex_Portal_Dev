CREATE PROCEDURE USP_insertUserWiseTODOMapping @UserId INT,@ImpexPortalActionLogId INT
AS
BEGIN
INSERT INTO UserWiseTODOMapping(UserId,ImpexPortalActionLogId,CreatedDate)
SELECT @UserId,@ImpexPortalActionLogId,GETDATE()
END