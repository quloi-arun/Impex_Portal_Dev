CREATE PROCEDURE [dbo].[USP_updatePriceChangeAcceptReject](@RequestIdentifier VARCHAR(20),@isAcceptReject BIT,@UpdatedBy INT)
AS
BEGIN
UPDATE PriceChangeHistory SET isAcceptReject=@isAcceptReject,AcceptRejectBy=@UpdatedBy,AcceptRejectDate=GETDATE() 
WHERE RequestIdentifier = @RequestIdentifier

UPDATE ImpexPortalActionLog SET Status = CASE WHEN @isAcceptReject=1 THEN 'Accepted' WHEN @isAcceptReject=0 THEN 'Rejected' ELSE NULL END WHERE RequestIdentifier = @RequestIdentifier

INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,RequestIdentifier,Status,DescriptionHeader)
SELECT TOP 1 'Purchase Order',POH.PONumber, CASE WHEN @isAcceptReject=1 THEN 'Price Accepted : ' WHEN @isAcceptReject=0 THEN 'Price Rejected : ' END + STUFF((SELECT ' | '+CONCAT(TPO.PartNo,'(Price):',CAST(TPO.OldPrice AS VARCHAR(20)),' To ',
CAST(TPO.NewPrice AS VARCHAR(20))) 
FROM PriceChangeHistory TPO WHERE TPO.RequestIdentifier=POH.RequestIdentifier FOR XML PATH('')),1,3,''),
'Insert',(SELECT TOP 1 SupplierID FROM PurchaseOrdersSync WHERE POID=POH.POID),@UpdatedBy,GETDATE(),@RequestIdentifier,CASE WHEN @isAcceptReject=1 THEN 'Accepted' WHEN @isAcceptReject=0 THEN 'Rejected' ELSE NULL END,
CASE WHEN @isAcceptReject=1 THEN 'Price has been Accepted' WHEN @isAcceptReject=0 THEN 'Price has been Rejected' ELSE NULL END
FROM PriceChangeHistory POH WHERE RequestIdentifier = @RequestIdentifier

SELECT 200 SuccessCode, 'Flag Updated Successfully.' Message
END