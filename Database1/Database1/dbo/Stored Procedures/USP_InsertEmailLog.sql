
create PROCEDURE [dbo].[USP_InsertEmailLog] 
@Mail_Form  nvarchar(200),
@Mail_To nvarchar(400),
@Mail_ToCC nvarchar(400),
@Mail_Bcc nvarchar(400),
@MailSubject nvarchar(200),
@MailHost nvarchar(200),
@MailPort nvarchar(200)

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

INSERT INTO EmailLog (
Mail_Form,Mail_To,Mail_ToCC,Mail_Bcc,MailSubject,MailHost,MailPort,SendDatetime
)
	VALUES (@Mail_Form,@Mail_To,@Mail_ToCC,@Mail_Bcc,@MailSubject,@MailHost,@MailPort,  GETDATE())

SELECT 'Email log inserted successfully.' Message ,200 SuccessCode
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
RAISERROR ('USP_InsertEmailLog: %d: %s', 16, 1, @error, @message);
RETURN;
END CATCH
END