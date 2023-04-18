CREATE PROCEDURE USP_insertRejectedReason @POID INT, @RejectedReason VARCHAR(500)
AS
BEGIN
DECLARE @ActionHistoryId INT = 0
SET @ActionHistoryId = (SELECT TOP 1 ActionHistoryId FROM ActionHistory WHERE ID=@POID AND ActionTaken='Rejected' AND RejectedReason IS NULL ORDER BY ActionHistoryId DESC)
IF(@ActionHistoryId>0)
BEGIN
UPDATE ActionHistory SET RejectedReason = @RejectedReason WHERE ActionHistoryId = @ActionHistoryId
SELECT 'Rejected reason inserted Successfully.' Message ,200 SuccessCode
END
END