
CREATE PROCEDURE [dbo].[USP_getPurchaseOrdersSearch_Web_281122]         
@SupplierId INT = 0,        
@FromDate DATETIME = NULL,        
@ToDate DATETIME = NULL,        
--@PONumber VARCHAR(30) = NULL   ,    
@PONumber VARCHAR(30) = '',    
@PoId int =0    
AS         
BEGIN  
SET @ToDate = DATEADD(dd, 1, @ToDate)  
SELECT  
 PurchaseOrdersSync.POID  
   ,PONumber  
   ,PODate  
   ,POType  
   ,Supplier  
   ,Customer  
   ,PaymentTerms  
   ,DeliveryTerms  
   ,PO_Status  
   ,Remarks  
   ,FTPLink  
   --,SUBSTRING(FTPLink, LEN(FTPLink) - CHARINDEX('/', REVERSE(FTPLink)) + 2, LEN(FTPLink)) AS [FileName]  
   ,IIF(PurchaseOrdersSync.POID=3113181,'https://s3.eu-west-1.amazonaws.com/docs.quloi.com/PI222303070_PURCHASE%20ORDER_202211011228027403.pdf/PI222303070_PURCHASE%20ORDER_202211011228027403-1667285884471.pdf',SUBSTRING(FTPLink, LEN(FTPLink) - CHARINDEX('
/', REVERSE(FTPLink)) + 2, LEN(FTPLink))) [FileName]  
   ,T.duedate  
   ,IIF(LatestAction IS NULL, 'New', IIF(PO_Status = 'FULLY RECEIVED, ACCEPTED', 'Completed', LatestAction)) LatestAction  
   ,Email  
 --  ,CASE  
 -- WHEN T.cnt > 1 THEN 'Multiple Parts'  
 -- ELSE CAST(QTY.QTY AS VARCHAR(10))  
 --END QTY  
 --  ,CASE  
 -- WHEN MO.RN > 1 THEN 'Multiple Parts'  
 -- ELSE CAST(MO.[Pending Qty] AS VARCHAR(10))  
 --END PendingQTY  
 ,
 --POLIS.PartNo
 --,POLIS.QTY as 'Part QTY'
 --,RatePerUnit as 'Rates'
 CAST(QTY.QTY AS VARCHAR(10)) QTY  
 ,CAST(MO.[Pending Qty] AS VARCHAR(10)) PendingQTY  
 ,RR.RejectedReason  
 ,IIF(IPO.POID IS NULL,0,1) IsInvoiceGenerated

FROM [dbo].[PurchaseOrdersSync] 
--left join PurchaseOrderLineItemsSync POLIS on POLIS.POID=PurchaseOrdersSync.POID

LEFT JOIN (SELECT  
  Poid  
    ,COUNT(poid) AS cnt  
    ,MAX(DueDate) DueDate  
 FROM PurchaseOrderLineItemsSync  
 GROUP BY Poid) T  
 ON T.poid = PurchaseOrdersSync.poid  
LEFT JOIN (SELECT  
  Poid  
    ,SUM(Qty) AS QTY  
 FROM PurchaseOrderLineItemsSync  
 GROUP BY Poid) Qty  
 ON Qty.poid = PurchaseOrdersSync.poid  
LEFT JOIN (SELECT  
  MAX(RN) RN  
    ,M.POID  
    ,SUM(CAST([Pending Qty] AS INT)) [Pending Qty]  
 FROM (SELECT  
   ROW_NUMBER() OVER (PARTITION BY P.POID ORDER BY P.POLineID) RN  
     ,P.POID  
     ,P.Qty - COALESCE(QTY.InvoiceQty, 0) AS 'Pending Qty'  
  FROM PurchaseOrderLineItemsSync P  
  LEFT JOIN (SELECT  
    POLineID  
      ,SUM(InvoiceQty) InvoiceQty  
   FROM WarehouseReceiptLineItemsSync  
   W  
   GROUP BY POLineID) Qty  
   ON qty.POLineID = P.POLineID) M  
 GROUP BY M.POID) MO  
 ON MO.POID = PurchaseOrdersSync.POID  
OUTER APPLY (SELECT TOP 1 RejectedReason FROM ActionHistory AH  
WHERE PurchaseOrdersSync.poid = AH.ID AND ActionTaken='Rejected'  
ORDER BY ActionHistoryId DESC) RR  
OUTER APPLY (SELECT TOP 1 POID FROM SupplierInvoiceDocuments SI  
WHERE SI.POID = PurchaseOrdersSync.POID  
) IPO  
  
WHERE (@SupplierId = 0  
OR SupplierId = @SupplierId)  
AND (@PoId = 0  
OR PurchaseOrdersSync.POID = @PoId)  
AND ((@FromDate IS NULL  
OR @ToDate IS NULL)  
OR CreatedDate BETWEEN @FromDate AND @ToDate)  
AND (@PONumber = ''  
OR PONumber = @PONumber)  
AND PONumber LIKE 'PI%'  
ORDER BY PODate DESC  




select POLIS.Poid,PartNo,Qty,RatePerUnit from [dbo].[PurchaseOrdersSync] 
left join PurchaseOrderLineItemsSync POLIS on POLIS.POID=PurchaseOrdersSync.POID
where (@SupplierId = 0  
OR SupplierId = @SupplierId)  
AND (@PoId = 0  
OR PurchaseOrdersSync.POID = @PoId)  
AND ((@FromDate IS NULL  
OR @ToDate IS NULL)  
OR CreatedDate BETWEEN @FromDate AND @ToDate)  
AND (@PONumber = ''  
OR PONumber = @PONumber)  
AND PONumber LIKE 'PI%'  
ORDER BY PODate DESC  
--AND (@PONumber = NULL OR PONumber = @PONumber)        
--IF @@ROWCOUNT > 0      
--select  SuccessCode=400,Message='Record Not Found'        
END