  
CREATE procedure [dbo].[usp_getRejectQC_02012023](@FromDate DATETIME = NULL,        
@ToDate DATETIME = NULL , @SupplierId INT = NULL  )  
as  
Begin  
SET @ToDate = DATEADD(dd,1,@ToDate)  
select QC.*,Customer,Email,POS.LatestAction,POS.PODate,POS.PONumber,PaymentTerms,Remarks,Supplier,POS.DueDate,  
POLS.PartNo,WRS.ReceiptNo,WRS.ReceiptDate,WRS.FileName  
from [dbo].[QCLineItemsSync] QC  
JOIN PurchaseOrdersSync POS  
ON QC.POID = POS.POID  
LEFT JOIN PurchaseOrderLineItemsSync POLS  
ON QC.POLineID = POLS.POLineID  
LEFT JOIN WarehouseReceiptsSync WRS  
ON QC.POID = WRS.POID AND POLS.PartNo = WRS.PartNo AND QC.ReceiptLineItemID = WRS.ReceiptLineItemID  
where QC.RejectedQty>0 and    
QCStatusDate BETWEEN @FromDate AND @ToDate  
AND (POS.SupplierID = @SupplierId OR @SupplierId IS NULL)  
END