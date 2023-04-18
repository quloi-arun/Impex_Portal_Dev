
CREATE PROCEDURE USP_getPOChangeHistory(@POID INT)
AS
BEGIN
SELECT POID,PONumber,PartNo,PCH.OldQty,PCH.NewQty,PCH.OldDueDate,PCH.NewDueDate,
CASE WHEN isAcceptReject=1 THEN 'Accepted' WHEN isAcceptReject=0 THEN 'Rejected' ELSE 'No Action' END Status,
AcceptRejectDate,AR.LoginId AcceptRejectBy,CreatedDate,CB.LoginId CreatedBy 
FROM POChangeHistory PCH
LEFT JOIN MasterUser AR
ON PCH.AcceptRejectBy = AR.UserId
LEFT JOIN MasterUser CB
ON PCH.CreatedBy = CB.UserId
WHERE POID = @POID
END