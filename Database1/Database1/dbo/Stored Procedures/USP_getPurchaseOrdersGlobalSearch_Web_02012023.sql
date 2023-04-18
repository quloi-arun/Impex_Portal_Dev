  
--USP_getPurchaseOrdersGlobalSearch_Web '61M'  
CREATE PROCEDURE [dbo].[USP_getPurchaseOrdersGlobalSearch_Web_02012023]         
@SearchString VARCHAR(100)='',@SupplierId INT = 0  
AS  
BEGIN  
;WITH POCTE(POID) AS    
(   
SELECT DISTINCT POID FROM (  
SELECT POID,PartNo Search FROM PurchaseOrderLineItemsSync  
UNION ALL  
SELECT POID,PONumber FROM PurchaseOrdersSync  
)M  
WHERE ISNULL(@SearchString,'')='' OR M.Search LIKE '%'+@SearchString+'%')  
  
SELECT  
 POS.POID  
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
   ,SUBSTRING(FTPLink, LEN(FTPLink) - CHARINDEX('/', REVERSE(FTPLink)) + 2, LEN(FTPLink)) AS [FileName]  
   ,T.duedate  
   ,IIF(LatestAction IS NULL, 'New', IIF(PO_Status = 'FULLY RECEIVED, ACCEPTED', 'Completed', LatestAction)) LatestAction  
   ,Email  
   ,CAST(QTY.QTY AS VARCHAR(10)) QTY  
   ,CAST(MO.[Pending Qty] AS VARCHAR(10)) PendingQTY  
   ,RR.RejectedReason  
   ,IIF(IPO.POID IS NULL,0,1) IsInvoiceGenerated  
FROM [dbo].[PurchaseOrdersSync] POS  
JOIN POCTE C  
 ON POS.POID = C.POID  
LEFT JOIN (SELECT Poid, COUNT(poid) AS cnt, MAX(DueDate) DueDate FROM PurchaseOrderLineItemsSync GROUP BY Poid) T  
 ON T.poid = POS.poid  
LEFT JOIN (SELECT Poid, SUM(Qty) AS QTY FROM PurchaseOrderLineItemsSync GROUP BY Poid) Qty  
 ON Qty.poid = POS.poid  
LEFT JOIN (SELECT  
  MAX(RN) RN  
    ,M.POID  
    ,SUM(CAST([Pending Qty] AS INT)) [Pending Qty]  
 FROM (SELECT  
   ROW_NUMBER() OVER (PARTITION BY P.POID ORDER BY P.POLineID) RN  
     ,P.POID  
     ,P.Qty - COALESCE(QTY.ReceivedQty, 0) AS 'Pending Qty'  
  FROM PurchaseOrderLineItemsSync P  
  LEFT JOIN (SELECT POLineID, SUM(W.ReceivedQty) ReceivedQty FROM WarehouseReceiptLineItemsSync W GROUP BY POLineID) Qty  
   ON qty.POLineID = P.POLineID) M  
 GROUP BY M.POID) MO  
 ON MO.POID = POS.POID  
OUTER APPLY (SELECT TOP 1 RejectedReason FROM ActionHistory AH  
WHERE POS.poid = AH.ID AND ActionTaken='Rejected'  
ORDER BY ActionHistoryId DESC) RR  
OUTER APPLY (SELECT TOP 1 POID FROM SupplierInvoiceDocuments SI  
WHERE SI.POID = POS.POID  
) IPO  
WHERE PONumber LIKE 'PI%' AND (@SupplierId = 0 OR POS.SupplierID = @SupplierId)  
END  
  
  