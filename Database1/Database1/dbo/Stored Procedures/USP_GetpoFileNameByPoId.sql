create PROCEDURE [dbo].[USP_GetpoFileNameByPoId]
(@PoId int )
AS
BEGIN
SELECT
Po.FTPLink
FROM PurchaseOrdersSync PO

WHERE  PO.POID=@PoId
END