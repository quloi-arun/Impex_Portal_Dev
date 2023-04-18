CREATE procedure [dbo].[usp_getRejectQC](@FromDate DATETIME = NULL,        
@ToDate DATETIME = NULL , @SupplierId INT = NULL  )  
as  
Begin  
--select @SupplierID=ParentCompanyID from Companies  where companYid=@SupplierId
SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId = @SupplierId

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
 --left join Companies C on (C.ParentCompanyID= POS.SupplierID or C.companyid=POS.SupplierID)
where QC.RejectedQty>0 and    
QCStatusDate BETWEEN @FromDate AND @ToDate  
AND (@SupplierId = 0 OR POS.SupplierID IN (SELECT * FROM #Supplier))
--OR C.ParentCompanyID = @SupplierId or C.companYid =@SupplierId)  
END
