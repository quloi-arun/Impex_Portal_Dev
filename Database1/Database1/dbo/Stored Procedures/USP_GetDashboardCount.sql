CREATE PROCEDURE [dbo].[USP_GetDashboardCount] @SupplierId INT = NULL,@FromDate DATE = NULL,@ToDate DATE = NULL  
AS   
BEGIN  
--select @SupplierID=ParentCompanyID from Companies  where companYid=@SupplierId

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId = @SupplierId

SET @ToDate = DATEADD(dd,1,@ToDate)  
DECLARE @POCount INT = 0, @ForecastCount INT = 0, @GRNCount INT = 0, @InvoiceCount INT = 0   
SET @POCount = (SELECT COUNT(PO.POID) FROM PurchaseOrdersSync PO  
CROSS APPLY (SELECT TOP 1 PO.POID FROM PurchaseOrderLineItemsSync POL  
WHERE PO.POID = POL.POID)POLI  
 --left join Companies C on (C.ParentCompanyID= PO.SupplierID or C.companyid=PO.SupplierID)
WHERE 
  (@SupplierId = 0  OR PO.SupplierID IN (SELECT * FROM #Supplier))
--OR C.ParentCompanyID = @SupplierId or C.companYid =@SupplierId)
AND (PODate BETWEEN @FromDate AND @ToDate))  
  
SET @ForecastCount = (SELECT COUNT(FileID) FROM PendingSalesOrderSync
--left join Companies C on (C.ParentCompanyID= PendingSalesOrderSync.SupplierID or C.companyid=PendingSalesOrderSync.SupplierID)
WHERE OrderType = 'Forecast' AND   
(DueDate BETWEEN @FromDate AND @ToDate) AND 
  (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier)))
--OR C.ParentCompanyID = @SupplierId or C.companYid =@SupplierId))  
  
SET @GRNCount = (SELECT COUNT(POID) FROM WarehouseReceiptsSync
--left join Companies C on (C.ParentCompanyID= WarehouseReceiptsSync.SupplierID or C.companyid=WarehouseReceiptsSync.SupplierID)
WHERE (@SupplierId = 0  OR SupplierID IN (SELECT * FROM #Supplier))
--OR C.ParentCompanyID = @SupplierId or C.companYid =@SupplierId)  
AND (ReceiptDate BETWEEN @FromDate AND @ToDate))  
  
SET @InvoiceCount = (SELECT COUNT(POS.POID) FROM [dbo].[SupplierInvoiceDocuments] SI  
JOIN PurchaseOrdersSync POS  
ON SI.POID = POS.POID 
--left join Companies C on (C.ParentCompanyID= POS.SupplierID or C.companyid=POS.SupplierID)
WHERE (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier))
--OR C.ParentCompanyID = @SupplierId or C.companYid =@SupplierId)  
AND (SI.CreatedDate BETWEEN @FromDate AND @ToDate))  
  
SELECT @POCount POCount, @ForecastCount ForecastCount, @GRNCount GRNCount, @InvoiceCount InvoiceCount  
  
END
