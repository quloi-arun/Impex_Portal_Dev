CREATE PROCEDURE USP_getPriceChangeHistory(@POID INT)
AS
BEGIN
SELECT POID,PONumber,PartNo,OldPrice,NewPrice,
CASE WHEN isAcceptReject=1 THEN 'Accepted' WHEN isAcceptReject=0 THEN 'Rejected' ELSE 'No Action' END Status,
AcceptRejectDate,AR.LoginId AcceptRejectBy,CreatedDate,CB.LoginId CreatedBy
FROM PriceChangeHistory PCH
LEFT JOIN MasterUser AR
ON PCH.AcceptRejectBy = AR.UserId
LEFT JOIN MasterUser CB
ON PCH.CreatedBy = CB.UserId
WHERE POID = @POID
ORDER BY CreatedDate DESC
END