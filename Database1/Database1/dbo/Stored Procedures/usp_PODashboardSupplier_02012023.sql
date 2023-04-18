﻿CREATE procedure [dbo].[usp_PODashboardSupplier_02012023](@fromdate date,@todate date,@SupplierID int)  
as  
Begin  
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
where PODate between @fromdate and @todate and po.SupplierID=@SupplierID  
group by  FORMAT(Podate, 'MMMM'),po.SupplierID,po.Supplier  
end  