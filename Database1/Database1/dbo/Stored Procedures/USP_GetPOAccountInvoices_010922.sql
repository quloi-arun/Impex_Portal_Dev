
CREATE PROCEDURE [dbo].[USP_GetPOAccountInvoices_010922] @POID INT
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT M1.* FROM (SELECT POS.POID,POLI.POLineID,POS.PONumber,POS.PODate,POS.PO_Status,POLI.PartNo,POLI.DueDate,POLI.Qty,POLI.RatePerUnit
,RQ.ReceivedQty,(ISNULL(POLI.Qty,0)-ISNULL(RQ.ReceivedQty,0)) BalancedQty
FROM PurchaseOrdersSync POS
JOIN PurchaseOrderLineItemsSync POLI
ON POS.POID = POLI.POID
LEFT JOIN (
SELECT WHRL.POLineID,SUM(WHRL.ReceivedQty) ReceivedQty FROM 
WarehouseReceiptLineItemsSync WHRL
GROUP BY WHRL.POLineID
)RQ
ON POLI.POLineID = RQ.POLineID
WHERE --POS.PODate >='2022-01-01' AND 
POLI.DueDate IS NOT NULL
AND POS.POID = @POID)M1
OUTER APPLY (SELECT * FROM (
SELECT DENSE_RANK() OVER (PARTITION BY SID.POID ORDER BY SID.SupplierInvoiceDocumentsID DESC) RN
,SID.POID,SI.PartNo,SI.Qty,SI.ReceivedQty,SI.BalancedQty
FROM SupplierInvoiceDocuments SID
JOIN SupplierInvoices SI
ON SID.SupplierInvoiceDocumentsID = SI.SupplierInvoiceDocumentsID
WHERE SID.POID=@POID)M
WHERE RN=1 AND M1.PartNo = M.PartNo)M2
WHERE M1.BalancedQty=M2.BalancedQty OR M2.BalancedQty IS NULL
--AND RQ.ReceivedQty>POLI.Qty

IF EXISTS (SELECT TOP 1 * FROM SupplierInvoiceDocuments WHERE POID = @POID)
BEGIN
SELECT POID,PONumber,InvoiceNo,CONCAT('https://vizio.atafreight.com/ImpexCoreDev/Invoice/',InvoiceDocLink) InvoiceDocLink FROM SupplierInvoiceDocuments WHERE POID = @POID
END
ELSE
BEGIN
SELECT 'Invoices Not Found' Message , 400 SuccessCode
END

END