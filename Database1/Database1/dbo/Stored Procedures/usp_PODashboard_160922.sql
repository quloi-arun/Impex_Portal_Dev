
CREATE procedure [dbo].[usp_PODashboard_160922](@fromdate date,@todate date,@SupplierId INT = NULL)  
as  
Begin  
SET @ToDate = DATEADD(dd,1,@ToDate)  
if(@SupplierId=0)
	set @SupplierId =null 
SELECT  
 FORMAT(Podate, 'MMMM') AS Mth  
   ,COUNT(FORMAT(Podate, 'MMMM')) AS POCount  
   ,COUNT(Pr.POID) AS 'PARTIALLY RECEIVED'  
   ,COUNT(Prf.POID) AS 'FULLY RECEIVED'  
   ,COUNT(PrQ.POID) AS 'QC PENDING'  
   ,COUNT(PrG.POID) AS 'GRN PENDING'  
   ,COUNT(WRQ.POID) AS 'QC PENDING'  
   ,COUNT(WRQD.POID) AS 'QC DONE'  
   ,FORMAT(Podate, 'MM') M,FORMAT(Podate, 'yyyy') Y  
FROM PurchaseOrdersSync po  
LEFT JOIN (SELECT  
  POID  
 FROM PurchaseOrdersSync  
 WHERE PO_Status = 'PARTIALLY RECEIVED, QC PENDING') PR  
 ON PR.POID = po.POID  
LEFT JOIN (SELECT  
  POID  
 FROM PurchaseOrdersSync  
 WHERE PO_Status = 'FULLY RECEIVED, ACCEPTED') PRF  
 ON PRF.POID = po.POID  
LEFT JOIN (SELECT  
  POID  
 FROM PurchaseOrdersSync  
 WHERE PO_Status = 'FULLY RECEIVED, QC PENDING') PRQ  
 ON PRQ.POID = po.POID  
LEFT JOIN (SELECT  
  POID  
 FROM PurchaseOrdersSync  
 WHERE PO_Status = 'NOT RECEIVED') PRG  
 ON PRG.POID = po.POID  


 LEFT JOIN (SELECT  
  POID  
 FROM WarehouseReceiptsSync  
 WHERE QCRemarks is Null) WRQ  
  ON WRQ.POID = po.POID 

  LEFT JOIN (SELECT  
  POID  
 FROM WarehouseReceiptsSync  
 WHERE QCRemarks='Qc Done') WRQD  
  ON WRQD.POID = po.POID 


WHERE PODate BETWEEN @fromdate AND @todate AND  
(SupplierID = @SupplierId OR @SupplierId IS NULL)  
GROUP BY FORMAT(Podate, 'MMMM'),FORMAT(Podate, 'MM'),FORMAT(Podate, 'yyyy')  
ORDER BY Y ASC, M ASC  
END