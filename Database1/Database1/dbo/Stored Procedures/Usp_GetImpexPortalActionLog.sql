

  
  
    
CREATE PROCEDURE [dbo].[Usp_GetImpexPortalActionLog](@UserID INT)    
AS    
BEGIN    
--select top 100 [ModuleName]    
--           ,[Header]    
--           ,[Description]    
--           ,[Action] from ImpexPortalActionLog where @userid=0 or ViewBy=@UserID order by CreatedDate desc    
    
--SELECT TOP 100 IPAL.ModuleName,IPAL.Header,IPAL.Description,IPAL.Action     
--FROM ImpexPortalActionLog IPAL    
--LEFT JOIN MasterUser MU    
--ON (IPAL.ViewBy = MU.GlobalId) OR MU.UserType='ImpexOperationAdmin'    
----WHERE @UserID=0 OR (MU.UserId=@UserId AND IPAL.CreatedDate >= MU.LastLogin AND IPAL.CreatedDate < MU.TODOCheck)    
----WHERE MU.UserId=@UserId AND IPAL.CreatedDate > ISNULL(MU.TODOCheck,GETDATE()-15)    
--WHERE MU.UserId=@UserId AND IPAL.CreatedDate > GETDATE()-15    
--ORDER BY IPAL.CreatedDate DESC    
SELECT DISTINCT    
 C2.CompanyId INTO #Supplier    
FROM MasterUser MU    
JOIN Companies C1    
ON MU.GlobalId = C1.CompanyID    
LEFT JOIN Companies C2    
 ON C1.ParentCompanyID = C2.ParentCompanyID    
WHERE MU.UserId = @UserID    
    
----------------------------------------Notify After 24 hours if User doesnt take action    
    
select UT.ImpexPortalActionLogId,IA.Header,IA.ID,POID  
Into #temp    
from PurchaseOrdersSync PO    
JOIN ActionHistory AH    
ON AH.ID = PO.POID    
JOIN ImpexPortalActionLog IA    
ON IA.Header = PO.PONumber    
JOIN UserWiseTODOMapping UT    
ON UT.ImpexPortalActionLogId = IA.ID    
where PO.LatestAction in ('New','Viewed') and Dateadd(MINUTE,3,AH.CreatedDate) <= getdate()     
Order by AH.CreatedDate desc,PO.PONumber asc    

SELECT TOP 100 M.ID,M.ModuleName,LatestAction,M.Header,M.Description,M.Action,M.isRead,M.RequestIdentifier,M.CreatedDate,M.Status Into #UpdateIPAL  FROM (    
SELECT IPAL.ID,PO.LatestAction,IPAL.ModuleName,COALESCE(IPAL.DescriptionHeader,IPAL.Header) Header,IPAL.Description,IPAL.Action,IPAL.CreatedDate,IIF(UWM.ImpexPortalActionLogId IS NULL,0,1) isRead,MU.CreateDate,    
CASE WHEN Description LIKE 'Price Changed%' THEN 'TO'    
WHEN Description LIKE 'Order Changed%' THEN 'TS'    
WHEN Description LIKE 'PO Changed%' THEN 'TS'   
WHEN Description LIKE '%Please Accept PO,%' THEN 'TS'     
END TODO,MU.UserType,RequestIdentifier,IPAL.Status    
FROM ImpexPortalActionLog IPAL 
LEFT JOIN PurchaseOrdersSync PO
On PO.PONumber = IPAL.Header
LEFT JOIN MasterUser MU    
ON (IPAL.ViewBy IN (SELECT * FROM #Supplier)) OR MU.UserType='ImpexOperationAdmin'    
LEFT JOIN UserWiseTODOMapping UWM    
ON IPAL.ID = UWM.ImpexPortalActionLogId AND MU.UserId = UWM.UserId    
WHERE MU.UserId=@UserID)M    
WHERE ((M.UserType='ImpexOperationAdmin' AND M.TODO = 'TO') OR (M.UserType<>'ImpexOperationAdmin' AND M.TODO = 'TS'))    
AND M.CreatedDate>=M.CreateDate    
AND M.CreatedDate>='2022-12-14'    
ORDER BY M.isRead ASC,M.CreatedDate DESC    
--Drop TAble #temp  
  
-- select * from #temp    
    
delete from UserWiseTODOMapping    
where ImpexPortalActionLogId in (select ImpexPortalActionLogId from #temp)    
    
Update ImpexPortalActionLog    
set CreatedDate = getdate()    
from ImpexPortalActionLog where ID in (select ID from #UpdateIPAL
										where LatestAction in ('Viewed','New'))  
  
Update ActionHistory  
Set CreatedDate = getdate()  
where ID in (select POID from #temp)  
  
    
--------------------------------------------------------------------    
    
SELECT TOP 100 M.ID,M.ModuleName,M.Header,M.Description,M.Action,M.isRead,RID.RedirectId,M.RequestIdentifier,M.SubModule,M.CreatedDate,M.Status FROM (    
SELECT IPAL.ID,IPAL.ModuleName,COALESCE(IPAL.DescriptionHeader,IPAL.Header) Header,IPAL.Description,IPAL.Action,IPAL.CreatedDate,IIF(UWM.ImpexPortalActionLogId IS NULL,0,1) isRead,MU.CreateDate,    
CASE WHEN Description='QC Insert' THEN 'NS'    
WHEN Description LIKE 'Quality Check done%' THEN 'NS'    
WHEN Description LIKE '%GRN has been updated%' THEN 'NS'    
WHEN Description LIKE 'Price Changed%' THEN 'TO'    
WHEN Description LIKE 'Order Changed%' THEN 'TS'    
WHEN Description LIKE 'PO Changed%' THEN 'TS'    
WHEN Description='PO Accepted' THEN 'NO'    
WHEN Description LIKE 'New GRN%' THEN 'NS'    
WHEN Description LIKE '%Please check updated PO%' THEN 'NS'    
WHEN Description LIKE '%PO has been deleted%' THEN 'NS'    
WHEN Description LIKE '%Part has been deleted%' THEN 'NS'    
WHEN Description LIKE '%GRN has been deleted%' THEN 'NS'    
WHEN Description LIKE '%QC has been Approved%' THEN 'NS'    
WHEN Description LIKE '%QC has been Rejected%' THEN 'NS'    
WHEN Description LIKE '%Please Accept PO,%' THEN 'TS'    
WHEN Description='PO Rejected' THEN 'NO'    
WHEN Description='QC Update' THEN 'NS'    
WHEN Description LIKE 'Invoice (%' THEN 'NO'    
WHEN Description LIKE 'Cargo ready for%' THEN 'NO'    
WHEN Description LIKE '%Cargo is getting delay%' THEN 'NO'    
WHEN Description LIKE 'Price Accepted%' THEN 'NS'    
WHEN Description LIKE 'Price Rejected%' THEN 'NS'    
WHEN Description LIKE 'Order Accepted%' THEN 'NO'    
WHEN Description LIKE 'Order Rejected%' THEN 'NO'    
WHEN Description LIKE '%upload the incorrect amount%' THEN 'NO'    
WHEN Description LIKE '%Purchase Order is due%' THEN 'NS'    
WHEN Description LIKE 'PO Comment%' THEN 'NSNT'    
END TODO,MU.UserType,RequestIdentifier,CASE WHEN IPAL.Description LIKE 'Price Changed%' THEN 'Price Changed'    
WHEN IPAL.Description LIKE 'PO Changed%' THEN 'PO Changed'     
WHEN IPAL.Description LIKE 'Order Changed%' THEN 'PO Changed'     
WHEN IPAL.Description LIKE 'Invoice Generated%' THEN 'Invoice Generated'    
WHEN IPAL.Description LIKE 'Invoice (%' THEN 'Invoice Generated'    
ELSE IPAL.ModuleName END SubModule,IPAL.Status    
FROM ImpexPortalActionLog IPAL    
LEFT JOIN MasterUser MU    
ON (IPAL.ViewBy IN (SELECT * FROM #Supplier)) OR MU.UserType='ImpexOperationAdmin'    
LEFT JOIN UserWiseTODOMapping UWM    
ON IPAL.ID = UWM.ImpexPortalActionLogId AND MU.UserId = UWM.UserId    
WHERE MU.UserId=@UserId)M    
LEFT JOIN (    
SELECT IPAL.ID,COALESCE(POS.POID,WRS.ReceiptID,POSI.POID,WRSG.ReceiptID) RedirectId FROM ImpexPortalActionLog IPAL    
OUTER APPLY(SELECT TOP 1 POID FROM [dbo].PurchaseOrdersSync POSI    
WHERE IPAL.Header = POSI.PONumber AND IPAL.ModuleName='Purchase Order')POS    
OUTER APPLY(SELECT TOP 1 ReceiptID FROM [dbo].WarehouseReceiptsSync WRSI     
WHERE WRSI.ReceiptNo=IPAL.Header AND IPAL.ModuleName='QC Screen')WRS    
OUTER APPLY(SELECT TOP 1 POID FROM [dbo].PurchaseOrdersSync POSFI    
WHERE IPAL.Header = POSFI.PONumber AND IPAL.ModuleName='Invoice Screen')POSI    
OUTER APPLY(SELECT TOP 1 ReceiptID FROM [dbo].WarehouseReceiptsSync WRSGI     
WHERE WRSGI.ReceiptNo=IPAL.Header AND IPAL.ModuleName='GRN Order')WRSG)RID    
ON M.ID = RID.ID    
WHERE ((M.UserType='ImpexOperationAdmin' AND M.TODO = 'TO') OR (M.UserType<>'ImpexOperationAdmin' AND M.TODO = 'TS'))    
AND M.CreatedDate>=M.CreateDate    
AND M.CreatedDate>='2022-12-14'    
ORDER BY M.isRead ASC,M.CreatedDate DESC    
    
END    