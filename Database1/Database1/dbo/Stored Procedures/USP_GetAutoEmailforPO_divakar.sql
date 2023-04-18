  
CREATE PROCEDURE USP_GetAutoEmailforPO_divakar 
AS  
BEGIN  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

DECLARE @tableHTML NVARCHAR(MAX)= '';
DECLARE @Style NVARCHAR(MAX)= '';
DECLARE @EMailer NVARCHAR(MAX)= '';

SET @Style += +N'<style type="text/css">' + N'.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}'
    + N'.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}'
    + N'.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f38630;}'
    + N'.tg .tg-9ajh{font-weight:bold;background-color:#68cbd0}' + N'.tg .tg-hgcj{font-weight:bold;text-align:center}'
    + N'</style>';


SET @tableHTML += @Style + @tableHTML
	+ N'<table class="tg">' --DEFINE TABLE



	--Define Column Headers and Column Span for each Header Column
	+ N'<tr>' 
    + N'<th class="tg-hgcj" colspan="2">Order Information</th>' 
	+ N'<th class="tg-hgcj" colspan="2">Summary</th>'
	+ N'</tr>' 

	---Define Column Sub-Headers
	+ N'<tr>'
	+ N'<td class="tg-9ajh">Order Date</td>'
    + N'<td class="tg-9ajh">Shipping Method</td>' 
	+ N'<td class="tg-9ajh">Order QTY</td>'
    + N'<td class="tg-9ajh">Order Total</td></tr>'
	
	 + CAST(( 
	 SELECT td = '' ,
					'',
                    td = '',
					'',
                    td = '' ,
					'',
                    td = '' ,
					''

FROM (SELECT  
  PO.PONumber  
    ,PO.DueDate  
    ,PO.LatestAction  
    ,IIF(PO.LatestAction = 'Viewed', AH.CreatedDate, PO.CreatedDate) CreatedDate  
    ,CASE  
   WHEN PO.LatestAction = 'Viewed' AND  
    DATEADD(dd, 1, AH.CreatedDate) < GETDATE() AND  
    AH.CreatedDate >= '2022-07-01' THEN 1  
   WHEN PO.LatestAction IN ('New', 'Updated') AND  
    DATEADD(dd, 1, PO.CreatedDate) < GETDATE() AND  
    PO.CreatedDate >= '2022-07-01' THEN 1  
   ELSE 0  
  END Trg  
    ,Part.PartNo  
    ,EM.TOMail  
    ,PO.Supplier  
 FROM PurchaseOrdersSync PO  
 LEFT JOIN (SELECT M.Supplier,M.SupplierID,  
STUFF((SELECT ','+MU.Email FROM MasterUser MU WHERE MU.GlobalId = M.SupplierId  
FOR XML PATH('')),1,1,'') TOMail  
FROM (  
SELECT DISTINCT Supplier,SupplierID FROM PurchaseOrdersSync)M)EM  
ON PO.SupplierID = EM.SupplierID  
 OUTER APPLY (SELECT  
   STUFF((SELECT  
     CONCAT(' <tr><td>', POS.PartNo, '</td><td>', PO.PONumber, '</td>', '<td>', POS.Qty, '</td>', '<td>',  
     POS.DueDate, '</td></tr>')  
    FROM PurchaseOrderLineItemsSync POS  
    WHERE PO.POID = POS.POID  
    FOR XML PATH (''))  
   , 1, 1, '') PartNo) Part  
 LEFT JOIN ActionHistory AH  
  ON PO.POID = AH.ID  
  AND AH.FormName = 'PO'  
  AND PO.LatestAction = AH.ActionTaken  
 WHERE PO.LatestAction IN ('New', 'Updated', 'Viewed')) M  
WHERE M.Trg = 1  

FOR
             XML PATH('tr') ,
                 TYPE
           ) AS NVARCHAR(MAX)) + N'</table>';       




 
       
         
 

 
END