CREATE PROCEDURE USP_updateAutoMailSentEmailDate @ActionHistoryId INT
AS
BEGIN
UPDATE ActionHistory SET EmailSentDate = GETDATE() WHERE ActionHistoryId = @ActionHistoryId
SELECT 200 SuccessCode, 'Sent date Updated Successfully.' Message
END