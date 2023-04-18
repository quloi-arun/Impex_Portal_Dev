CREATE PROCEDURE [dbo].[USP_insertPODueDateHistory]
AS
BEGIN
SELECT MZ.POID INTO #SkipPO FROM (
SELECT MO.POID,SUM(MO.Qty)Qty,SUM(MO.ReceivedQty)ReceivedQty FROM (
SELECT PO.POID--,PO.PONumber,POLI.PartNo,POLI.Qty,PO.DueDate,M.ReceivedQty,I.Qty,I.ReceivedQty, 
,POLI.Qty,IIF(ISNULL(M.ReceivedQty,0)>=ISNULL(I.ReceivedQty,0),ISNULL(M.ReceivedQty,0),ISNULL(I.ReceivedQty,0)) ReceivedQty
FROM PurchaseOrdersSync PO
JOIN PurchaseOrderLineItemsSync POLI
ON PO.POID = POLI.POID
OUTER APPLY (SELECT SUM(WHRL.ReceivedQty) ReceivedQty
			FROM WarehouseReceiptLineItemsSync WHRL
			WHERE POLI.POLineID = WHRL.POLineID
			GROUP BY WHRL.POLineID)M
OUTER APPLY (SELECT SID.POID,SI.PartNo,MAX(SI.Qty) Qty,SUM(SI.ReceivedQty) ReceivedQty FROM SupplierInvoiceDocuments SID
JOIN SupplierInvoices SI
ON SID.SupplierInvoiceDocumentsID = SI.SupplierInvoiceDocumentsID
WHERE PO.POID = SID.POID AND POLI.PartNo = SI.PartNo
GROUP BY SID.POID,SI.PartNo)I
WHERE CAST(PO.DueDate AS DATE) >= CAST(GETDATE() AS DATE) AND 
CAST(PO.DueDate AS DATE) <= CAST(DATEADD(dd,3,GETDATE()) AS DATE)
AND ISNULL(PO.isDeleted,0) = 0)MO
GROUP BY MO.POID)MZ
WHERE MZ.Qty=MZ.ReceivedQty AND MZ.ReceivedQty>0


INSERT INTO PurchaseOrdersDueHistoryEmail(POID,PONumber,PartNo,Qty,DueDate)
SELECT * FROM (
SELECT PO.POID,PO.PONumber,POLI.PartNo,POLI.Qty,PO.DueDate FROM PurchaseOrdersSync PO
JOIN PurchaseOrderLineItemsSync POLI
ON PO.POID = POLI.POID
LEFT JOIN #SkipPO SPO
ON PO.POID = SPO.POID
WHERE CAST(PO.DueDate AS DATE) >= CAST(GETDATE() AS DATE) AND 
CAST(PO.DueDate AS DATE) <= CAST(DATEADD(dd,3,GETDATE()) AS DATE)
AND SPO.POID IS NULL
EXCEPT
SELECT POID,PONumber,PartNo,Qty,DueDate FROM PurchaseOrdersDueHistoryEmail
)M
END









