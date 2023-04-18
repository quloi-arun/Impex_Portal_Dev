CREATE PROCEDURE [dbo].[USP_insertPOChangeIntoTODO] @PONumber VARCHAR(20),@PartsQty VARCHAR(100), @CreatedBy INT
AS
BEGIN
INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,DescriptionHeader)
SELECT 'Purchase Order',@PONumber,'Order Changed : '+ @PartsQty,'Insert',
(SELECT TOP 1 SupplierID FROM PurchaseOrdersSync WHERE PONumber=@PONumber),@CreatedBy,GETDATE(),'Order has been changed'

SELECT 200 SuccessCode, 'PO Changed Successfully.' Message
END