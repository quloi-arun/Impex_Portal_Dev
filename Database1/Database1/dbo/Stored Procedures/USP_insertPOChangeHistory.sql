CREATE PROCEDURE [dbo].[USP_insertPOChangeHistory](@tvpPOChangeHistory AS tvpPOChangeHistory READONLY,@CreatedBy INT)
AS
BEGIN
DECLARE @RequestIdentifier VARCHAR(20) 
SET @RequestIdentifier = (SELECT CONCAT(FORMAT(GETDATE(), 'ddMMyy'),FORMAT(GETDATE(), 'hhmmss')))
IF EXISTS (SELECT * FROM @tvpPOChangeHistory)
BEGIN
INSERT INTO POChangeHistory (POID,PONumber,PartNo,OldQty,NewQty,OldDueDate,NewDueDate,CreatedBy,CreatedDate,RequestIdentifier)
SELECT POID,PONumber,PartNo,OldQty,NewQty,OldDueDate,NewDueDate,@CreatedBy,GETDATE(),@RequestIdentifier FROM @tvpPOChangeHistory

INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,RequestIdentifier,DescriptionHeader)
SELECT TOP 1 'Purchase Order',POH.PONumber, 'PO Changed : '+ STUFF((SELECT ' | '+CONCAT(TPO.PartNo,'(Qty):',CAST(TPO.OldQty AS VARCHAR(20)),' To ',
CAST(TPO.NewQty AS VARCHAR(20)),' , ',TPO.PartNo,'(Due Date):',FORMAT(TPO.OldDueDate, 'dd-MM-yy'),' To ',FORMAT(TPO.NewDueDate, 'dd-MM-yy')) 
FROM POChangeHistory TPO WHERE TPO.RequestIdentifier=POH.RequestIdentifier FOR XML PATH('')),1,3,''),
'Insert',(SELECT TOP 1 SupplierID FROM PurchaseOrdersSync WHERE POID=POH.POID),@CreatedBy,GETDATE(),@RequestIdentifier,'Order has been changed' 
FROM POChangeHistory POH WHERE RequestIdentifier = @RequestIdentifier
SELECT 200 SuccessCode, 'Order Changed Successfully.' Message
END
ELSE 
BEGIN
SELECT 400 SuccessCode, 'There might be some issue in Order Changed.' Message
END
END