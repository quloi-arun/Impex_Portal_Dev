CREATE PROCEDURE [dbo].[usp_PODashboard_02012023](@fromdate date,@todate date,@SupplierId INT = NULL)    
AS   
BEGIN  
SET @ToDate = DATEADD(dd, 1, @ToDate)  
    
IF(@SupplierId=0)  
SET @SupplierId = NULL  
SELECT  
 FORMAT(Podate, 'MMMM') AS Mth  
   ,COUNT(po.POID) AS POCount  
   ,SUM(IIF(PO_Status = 'PARTIALLY RECEIVED, QC PENDING',1,0)) 'PARTIALLY RECEIVED'  
   ,SUM(IIF(PO_Status = 'FULLY RECEIVED, ACCEPTED',1,0)) 'FULLY RECEIVED'  
   ,SUM(IIF(PO_Status = 'NOT RECEIVED',1,0)) 'GRN PENDING'  
   ,SUM(WRQ.[QC PENDING]) AS 'QC PENDING'  
   ,SUM(WRQD.[QC DONE]) AS 'QC DONE'  
   ,FORMAT(Podate, 'MM') M  
   ,FORMAT(Podate, 'yyyy') Y  
FROM PurchaseOrdersSync po  
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
WHERE PODate BETWEEN @fromdate AND @todate  
AND (SupplierID = @SupplierId OR @SupplierId IS NULL)  
GROUP BY FORMAT(Podate, 'MMMM'),FORMAT(Podate, 'MM'),FORMAT(Podate, 'yyyy')  
ORDER BY Y ASC, M ASC  
END  