--USP_getPurchaseOrdersSearch_Web 3114,null,null  
CREATE PROCEDURE [dbo].[USP_getPurchaseOrdersSearch_Web_02012023]  
@SupplierId INT = 0,  
@FromDate DATETIME = NULL,  
@ToDate DATETIME = NULL,  
@PONumber VARCHAR(30) = '',  
@PoId INT =0  
AS  
BEGIN  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET @ToDate = DATEADD(dd, 1, @ToDate)  
SELECT DISTINCT  
 PO.POID  
   ,PO.PONumber  
   ,PO.PODate  
   ,PO.POType  
   ,PO.Supplier  
   ,SM.SupplierEmails  
   ,PO.Customer  
   ,PO.PaymentTerms  
   ,PO.DeliveryTerms  
   ,PO.PO_Status  
   ,PO.Remarks  
   ,PO.FTPLink  
   ,SUBSTRING(PO.FTPLink, LEN(PO.FTPLink) - CHARINDEX('/', REVERSE(PO.FTPLink)) + 2, LEN(PO.FTPLink)) [FileName]  
   ,T.duedate  
   ,IIF(PO.LatestAction IS NULL, 'New', IIF(PO.PO_Status = 'FULLY RECEIVED, ACCEPTED', 'Completed', PO.LatestAction)) LatestAction  
   ,PO.Email  
   ,CAST(QTY.QTY AS VARCHAR(10)) QTY  
   ,CAST(MO.[Pending Qty] AS VARCHAR(10)) PendingQTY  
   ,'' RejectedReason  
   ,IIF(IPO.POID IS NULL, 0, 1) IsInvoiceGenerated  
   ,'' CCMail  
   ,'mungare@quloi.com,saylid@quloi.com,ddhande@quloi.com' BCCMail  
FROM [dbo].[PurchaseOrdersSync] PO  
JOIN (SELECT Poid ,COUNT(poid) AS cnt ,MAX(DueDate) DueDate FROM PurchaseOrderLineItemsSync GROUP BY Poid) T  
 ON T.poid = PO.poid  
LEFT JOIN (SELECT Poid ,SUM(Qty) AS QTY FROM PurchaseOrderLineItemsSync GROUP BY Poid) Qty  
 ON Qty.poid = PO.poid  
OUTER APPLY (SELECT STUFF((SELECT DISTINCT ',' + MU.Email  
  FROM MasterUser MU  
  WHERE MU.GlobalId = PO.SupplierID  
  AND ISNULL(MU.Email, '') <> ''  
  FOR XML PATH ('')), 1, 1, '') SupplierEmails)SM  
OUTER APPLY (SELECT  
  M.POID  
    ,SUM(CAST([Pending Qty] AS INT)) [Pending Qty]  
 FROM (SELECT  
   ROW_NUMBER() OVER (PARTITION BY P.POID ORDER BY P.POLineID) RN  
     ,P.POID  
     ,P.Qty - COALESCE(QTY.ReceivedQty, 0) AS 'Pending Qty'  
  FROM PurchaseOrderLineItemsSync P  
  LEFT JOIN (SELECT  
    WHRL.POLineID  
      ,SUM(WHRL.ReceivedQty) ReceivedQty  
   FROM WarehouseReceiptLineItemsSync WHRL  
   GROUP BY WHRL.POLineID) qty  
   ON qty.POLineID = P.POLineID) M  
 WHERE PO.POID = M.POID  
 GROUP BY M.POID) MO  
OUTER APPLY (SELECT TOP 1 POID FROM SupplierInvoiceDocuments SI WHERE SI.POID = PO.POID) IPO  
WHERE ((@FromDate IS NULL OR @ToDate IS NULL) OR PO.CreatedDate BETWEEN @FromDate AND @ToDate)  
AND PONumber LIKE 'PI%'  
AND (@SupplierId = 0 OR SupplierID = @SupplierId)  
AND (@PONumber = '' OR PONumber = @PONumber)  
AND (@PoId = 0 OR PO.POID = @PoId)  
ORDER BY PODate DESC  
  
SELECT  
 POLIS.Poid  
   ,POLIS.PartNo  
   ,POLIS.Qty  
   ,POLIS.RatePerUnit  
   ,CAST(POLIS.Qty - COALESCE(QTY.ReceivedQty, 0) AS INT) AS 'PendingQty'  
FROM [dbo].[PurchaseOrdersSync]  
JOIN PurchaseOrderLineItemsSync POLIS  
 ON POLIS.POID = PurchaseOrdersSync.POID  
OUTER APPLY (SELECT  
  WHRL.POLineID  
    ,SUM(WHRL.ReceivedQty) ReceivedQty  
 FROM WarehouseReceiptLineItemsSync WHRL  
 WHERE WHRL.POLineID = POLIS.POLineID  
 GROUP BY WHRL.POLineID) qty  
WHERE ((@FromDate IS NULL OR @ToDate IS NULL) OR PurchaseOrdersSync.CreatedDate BETWEEN @FromDate AND @ToDate)  
AND PONumber LIKE 'PI%'  
AND (@SupplierId = 0 OR SupplierId = @SupplierId)  
AND (@PONumber = '' OR PONumber = @PONumber)  
AND (@PoId = 0 OR PurchaseOrdersSync.POID = @PoId)  
ORDER BY PODate DESC  
  
END