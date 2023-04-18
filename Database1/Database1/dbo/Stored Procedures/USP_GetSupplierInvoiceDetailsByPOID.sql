
CREATE PROCEDURE [dbo].[USP_GetSupplierInvoiceDetailsByPOID] @POID INT
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT SID.SupplierInvoiceDocumentsID,POID,SID.PONumber,SID.InvoiceNo,SID.InvoiceAmount,SID.InvoiceDocLink
,SI.PartNo,SI.Qty,SI.RatePerUnit,SI.ReceivedQty,SI.BalancedQty,SID.CargoReadyDate,SID.CargoDelayedDate
FROM SupplierInvoiceDocuments SID
JOIN SupplierInvoices SI
ON SID.SupplierInvoiceDocumentsID = SI.SupplierInvoiceDocumentsID
WHERE SID.POID=@POID
END