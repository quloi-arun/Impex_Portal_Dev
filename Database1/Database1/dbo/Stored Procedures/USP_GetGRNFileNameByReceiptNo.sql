create PROCEDURE [dbo].[USP_GetGRNFileNameByReceiptNo]
(@ReceiptNo varchar(50) )
AS
BEGIN
SELECT
GN.FTPLink
FROM WarehouseReceiptsSync GN

WHERE  GN.ReceiptNo=@ReceiptNo
END