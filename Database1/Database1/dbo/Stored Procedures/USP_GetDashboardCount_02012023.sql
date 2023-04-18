CREATE PROCEDURE [dbo].[USP_GetDashboardCount_02012023] @SupplierId INT = NULL,@FromDate DATE = NULL,@ToDate DATE = NULL  
AS   
BEGIN  
SET @ToDate = DATEADD(dd,1,@ToDate)  
DECLARE @POCount INT = 0, @ForecastCount INT = 0, @GRNCount INT = 0, @InvoiceCount INT = 0   
SET @POCount = (SELECT COUNT(PO.POID) FROM PurchaseOrdersSync PO  
CROSS APPLY (SELECT TOP 1 PO.POID FROM PurchaseOrderLineItemsSync POL  
WHERE PO.POID = POL.POID)POLI  
WHERE (SupplierID = @SupplierId OR @SupplierId IS NULL)  
AND (PODate BETWEEN @FromDate AND @ToDate))  
  
SET @ForecastCount = (SELECT COUNT(FileID) FROM PendingSalesOrderSync WHERE OrderType = 'Forecast' AND   
(DueDate BETWEEN @FromDate AND @ToDate) AND (SupplierID = @SupplierId OR @SupplierId IS NULL))  
  
SET @GRNCount = (SELECT COUNT(POID) FROM WarehouseReceiptsSync WHERE (SupplierID = @SupplierId OR @SupplierId IS NULL)  
AND (ReceiptDate BETWEEN @FromDate AND @ToDate))  
  
SET @InvoiceCount = (SELECT COUNT(POS.POID) FROM [dbo].[SupplierInvoiceDocuments] SI  
JOIN PurchaseOrdersSync POS  
ON SI.POID = POS.POID  
WHERE (POS.SupplierID = @SupplierId OR @SupplierId IS NULL)  
AND (SI.CreatedDate BETWEEN @FromDate AND @ToDate))  
  
SELECT @POCount POCount, @ForecastCount ForecastCount, @GRNCount GRNCount, @InvoiceCount InvoiceCount  
  
END