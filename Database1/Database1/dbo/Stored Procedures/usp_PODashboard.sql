CREATE PROCEDURE [dbo].[usp_PODashboard](@fromdate date,@todate date,@SupplierId INT = NULL)    
AS   
BEGIN  
SET @ToDate = DATEADD(dd, 1, @ToDate)  
    --select @SupplierID=ParentCompanyID from Companies  where companYid=@SupplierId
IF(@SupplierId IS NULL)  
SET @SupplierId = 0

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId = @SupplierId

SELECT COUNT(SI.InvoiceNo) InvoiceCount,FORMAT(SI.CreatedDate, 'MM') M  
   ,FORMAT(SI.CreatedDate, 'yyyy') Y INTO #InvoiceData FROM SupplierInvoiceDocuments SI
JOIN PurchaseOrdersSync PO
ON SI.POID = PO.POID
WHERE (@SupplierId = 0 OR PO.SupplierID IN (SELECT * FROM #Supplier))
AND SI.CreatedDate>=@fromdate AND SI.CreatedDate<=@todate
GROUP BY FORMAT(SI.CreatedDate, 'MM'),FORMAT(SI.CreatedDate, 'yyyy')
  
SELECT M.*,IC.InvoiceCount AS 'Uploaded Invoices' FROM (
SELECT  
 FORMAT(PO.CreatedDate, 'MMMM') AS Mth  
   ,COUNT(po.POID) AS POCount  
   ,SUM(IIF(PO_Status = 'PARTIALLY RECEIVED, QC PENDING',1,0)) 'PARTIALLY RECEIVED'  
   ,SUM(IIF(PO_Status = 'FULLY RECEIVED, ACCEPTED',1,0)) 'FULLY RECEIVED'  
   ,SUM(IIF(PO_Status = 'NOT RECEIVED',1,0)) 'GRN PENDING'  
   ,SUM(WRQ.[QC PENDING]) AS 'QC PENDING'  
   ,SUM(WRQD.[QC DONE]) AS 'QC DONE'  
   ,FORMAT(PO.CreatedDate, 'MM') M  
   ,FORMAT(PO.CreatedDate, 'yyyy') Y  
FROM PurchaseOrdersSync po
LEFT JOIN SupplierInvoiceDocuments SIDM 
On SIDM.POID = PO.POID
LEFT JOIN (SELECT POID,COUNT(POID) 'QC PENDING'  
 FROM WarehouseReceiptsSync  
 WHERE QCRemarks IS NULL  
 GROUP BY POID) WRQ  
 ON WRQ.POID = po.POID  
LEFT JOIN (SELECT POID,COUNT(POID) 'QC DONE'  
 FROM WarehouseReceiptsSync  
 WHERE QCRemarks = 'Qc Done'  
 GROUP BY POID) WRQD  
 ON WRQD.POID = po.POID
 --left join Companies C on (C.ParentCompanyID= po.SupplierID or C.companyid=po.SupplierID)
WHERE PO.CreatedDate BETWEEN @fromdate AND @todate  
AND (@SupplierId = 0 OR PO.SupplierID IN (SELECT * FROM #Supplier))
--OR C.ParentCompanyID = @SupplierId or C.companYid =@SupplierId)  
GROUP BY FORMAT(PO.CreatedDate, 'MMMM'),FORMAT(PO.CreatedDate, 'MM'),FORMAT(PO.CreatedDate, 'yyyy') )M
LEFT JOIN #InvoiceData IC
ON IC.M = M.M AND IC.Y = M.Y
ORDER BY M.Y ASC, M.M ASC  
END  