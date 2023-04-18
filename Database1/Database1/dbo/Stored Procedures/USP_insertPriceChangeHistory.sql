CREATE PROCEDURE [dbo].[USP_insertPriceChangeHistory](@tvpPriceChangeHistory AS tvpPriceChangeHistory READONLY,@CreatedBy INT)
AS
BEGIN
DECLARE @RequestIdentifier VARCHAR(20) 
SET @RequestIdentifier = (SELECT CONCAT(FORMAT(GETDATE(), 'ddMMyy'),FORMAT(GETDATE(), 'hhmmss')))
IF EXISTS (SELECT * FROM @tvpPriceChangeHistory)
BEGIN
INSERT INTO PriceChangeHistory (POID,PONumber,PartNo,OldPrice,NewPrice,CreatedBy,CreatedDate,RequestIdentifier)
SELECT POID,PONumber,PartNo,OldPrice,NewPrice,@CreatedBy,GETDATE(),@RequestIdentifier FROM @tvpPriceChangeHistory

INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,RequestIdentifier,DescriptionHeader)
SELECT TOP 1 'Purchase Order',POH.PONumber, 'Price Changed : '+ STUFF((SELECT ' | '+CONCAT(TPO.PartNo,'(Price):',CAST(TPO.OldPrice AS VARCHAR(20)),' To ',
CAST(TPO.NewPrice AS VARCHAR(20))) 
FROM PriceChangeHistory TPO WHERE TPO.RequestIdentifier=POH.RequestIdentifier FOR XML PATH('')),1,3,''),
'Insert',(SELECT TOP 1 SupplierID FROM PurchaseOrdersSync WHERE POID=POH.POID),@CreatedBy,GETDATE(),@RequestIdentifier,'Price has been changed' 
FROM PriceChangeHistory POH WHERE RequestIdentifier = @RequestIdentifier

SELECT 200 SuccessCode, 'Price Changed Successfully.' Message
END
ELSE 
BEGIN
SELECT 400 SuccessCode, 'There might be some issue in Price Changed.' Message
END
END