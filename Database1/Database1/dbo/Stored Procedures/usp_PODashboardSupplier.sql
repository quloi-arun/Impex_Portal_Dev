CREATE procedure [dbo].[usp_PODashboardSupplier](@fromdate date,@todate date,@SupplierID int)  
as  
Begin 

SELECT DISTINCT C2.CompanyId INTO #Supplier FROM Companies C1
LEFT JOIN Companies C2
ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId=@SupplierId

select po.SupplierID,po.Supplier, FORMAT(Podate, 'MMMM') as Mth,count(FORMAT(Podate, 'MMMM')) as POCount,  
count(Pr.POID) as'PARTIALLY RECEIVED',  
count(Prf.POID) as'FULLY RECEIVED',  
count(PrQ.POID) as'QC PENDING',  
count(PrG.POID) as'GRN PENDING'  
from PurchaseOrdersSync po  
left join (select POID from PurchaseOrdersSync  
where PO_Status='PARTIALLY RECEIVED, QC PENDING' ) PR on PR.POID=po.POID  
left join (select POID from PurchaseOrdersSync  
where PO_Status='FULLY RECEIVED, ACCEPTED' ) PRF on PRF.POID=po.POID  
left join (select POID from PurchaseOrdersSync  
where PO_Status='FULLY RECEIVED, QC PENDING' ) PRQ on PRQ.POID=po.POID  
left join (select POID from PurchaseOrdersSync  
where PO_Status='NOT RECEIVED' ) PRG on PRG.POID=po.POID 
 --left join Companies C on (C.ParentCompanyID= po.SupplierID or C.companyid=po.SupplierID)
where PODate between @fromdate and @todate and 
 (@SupplierId = 0 OR PO.SupplierID IN (SELECT * FROM #Supplier))
--OR C.ParentCompanyID = @SupplierId or C.companYid =@SupplierId)
group by  FORMAT(Podate, 'MMMM'),po.SupplierID,po.Supplier  
end  

