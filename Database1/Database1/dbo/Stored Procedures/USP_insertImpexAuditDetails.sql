CREATE PROCEDURE [dbo].[USP_insertImpexAuditDetails] 
@Area VARCHAR(50),
@ControllerName VARCHAR(50),
@ActionName VARCHAR(50),
@LoginStatus VARCHAR(1),
@LoggedInAt VARCHAR(23),
@LoggedOutAt VARCHAR(23),
@PageAccessed VARCHAR(500),
@IPAddress VARCHAR(50),
@SessionID VARCHAR(50),
@UserID VARCHAR(50),
@RoleId VARCHAR(2),
@UserName VARCHAR(50),
@UserEmail VARCHAR(50),
@IsFirstLogin VARCHAR(2),
@UrlReferrer VARCHAR(max)

AS
BEGIN
SET NOCOUNT ON;

DECLARE @trancount INT;
SET @trancount = @@trancount;

BEGIN TRY  
IF @trancount = 0
BEGIN TRANSACTION
ELSE
SAVE TRANSACTION USP_insertImpexAuditDetails

INSERT INTO [dbo].[ImpexAudit] ([Area]
, [ControllerName]
, [ActionName]
, [LoginStatus]
, [LoggedInAt]
, [LoggedOutAt]
, [PageAccessed]
, [IPAddress]
, [SessionID]
, [UserID]
, [RoleId]
, [UserName]
, [UserEmail]
, [IsFirstLogin]
,[UrlReferrer]
, [CurrentDatetime])
	VALUES (@Area, @ControllerName, @ActionName, @LoginStatus, @LoggedInAt, @LoggedOutAt, @PageAccessed, @IPAddress, @SessionID, @UserID, @RoleId, @UserName, @UserEmail, @IsFirstLogin,@UrlReferrer,  GETDATE())

SELECT 'Audit log inserted successfully.' Message ,200 SuccessCode
lbexit:
IF @trancount = 0
COMMIT;
END TRY
BEGIN CATCH
DECLARE @error INT
	   ,@message VARCHAR(4000)
	   ,@xstate INT;
SELECT
	@error = ERROR_NUMBER()
   ,@message = ERROR_MESSAGE()
   ,@xstate = XACT_STATE();
IF @xstate = -1
ROLLBACK;
IF @xstate = 1
	AND @trancount = 0
ROLLBACK
IF @xstate = 1
	AND @trancount > 0
ROLLBACK TRANSACTION USP_insertImpexAuditDetails;
RAISERROR ('USP_insertImpexAuditDetails: %d: %s', 16, 1, @error, @message);
RETURN;
END CATCH
END