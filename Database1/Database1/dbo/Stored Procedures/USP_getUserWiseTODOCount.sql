CREATE PROCEDURE [dbo].[USP_getUserWiseTODOCount] @UserId INT
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
IF EXISTS (SELECT TOP 1 1 FROM MasterUser WHERE UserId=@UserId)
BEGIN

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM MasterUser MU
JOIN Companies C1
ON MU.GlobalId = C1.CompanyID
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE MU.UserId = @UserID

SELECT COUNT(M.isRead) TotalCount FROM (
SELECT IPAL.ModuleName,IPAL.Header,IPAL.Description,IPAL.Action,IPAL.CreatedDate,IIF(UWM.ImpexPortalActionLogId IS NULL,0,1) isRead,MU.CreateDate,
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
END TODO, MU.UserType
FROM ImpexPortalActionLog IPAL
LEFT JOIN MasterUser MU
ON (IPAL.ViewBy IN (SELECT * FROM #Supplier)) OR MU.UserType='ImpexOperationAdmin'
LEFT JOIN UserWiseTODOMapping UWM
ON IPAL.ID = UWM.ImpexPortalActionLogId AND MU.UserId = UWM.UserId
WHERE MU.UserId=@UserId)M
WHERE M.isRead=0 AND ((M.UserType='ImpexOperationAdmin' AND M.TODO = 'TO') OR (M.UserType<>'ImpexOperationAdmin' AND M.TODO = 'TS'))
AND M.CreatedDate>=M.CreateDate
AND M.CreatedDate>='2022-12-14'
END
ELSE
BEGIN 
SELECT 0 TotalCount
END
END
