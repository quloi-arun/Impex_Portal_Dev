CREATE PROCEDURE [dbo].[USP_updatePOChangeAcceptReject](@RequestIdentifier VARCHAR(20),@isAcceptReject BIT,@UpdatedBy INT)
AS
BEGIN
UPDATE POChangeHistory SET isAcceptReject=@isAcceptReject,AcceptRejectBy=@UpdatedBy,AcceptRejectDate=GETDATE() 
WHERE RequestIdentifier = @RequestIdentifier

UPDATE ImpexPortalActionLog SET Status = CASE WHEN @isAcceptReject=1 THEN 'Accepted' WHEN @isAcceptReject=0 THEN 'Rejected' ELSE NULL END WHERE RequestIdentifier = @RequestIdentifier

INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,RequestIdentifier,Status,DescriptionHeader)
SELECT TOP 1 'Purchase Order',POH.PONumber, CASE WHEN @isAcceptReject=1 THEN 'Order Accepted : ' WHEN @isAcceptReject=0 THEN 'Order Rejected : ' END + STUFF((SELECT ' | '+CONCAT(TPO.PartNo,'(Qty):',CAST(TPO.OldQty AS VARCHAR(20)),' To ',
CAST(TPO.NewQty AS VARCHAR(20)),' , ',TPO.PartNo,'(Due Date):',FORMAT(TPO.OldDueDate, 'dd-MM-yy'),' To ',FORMAT(TPO.NewDueDate, 'dd-MM-yy')) 
FROM POChangeHistory TPO WHERE TPO.RequestIdentifier=POH.RequestIdentifier FOR XML PATH('')),1,3,''),
'Insert',(SELECT TOP 1 SupplierID FROM PurchaseOrdersSync WHERE POID=POH.POID),@UpdatedBy,GETDATE(),@RequestIdentifier,CASE WHEN @isAcceptReject=1 THEN 'Accepted' WHEN @isAcceptReject=0 THEN 'Rejected' ELSE NULL END,
CASE WHEN @isAcceptReject=1 THEN 'Order has been Accepted' WHEN @isAcceptReject=0 THEN 'Order has been Rejected' ELSE NULL END 
FROM POChangeHistory POH WHERE RequestIdentifier = @RequestIdentifier

SELECT 200 SuccessCode, 'Flag Updated Successfully.' Message
END