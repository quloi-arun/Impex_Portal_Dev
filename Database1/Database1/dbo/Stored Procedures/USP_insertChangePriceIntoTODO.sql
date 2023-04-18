CREATE PROCEDURE [dbo].[USP_insertChangePriceIntoTODO] @PONumber VARCHAR(20),@PartsPrice VARCHAR(100), @CreatedBy INT
AS
BEGIN
INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,DescriptionHeader)
SELECT 'Purchase Order',@PONumber,'Price Changed : '+ @PartsPrice,'Insert',
(SELECT TOP 1 SupplierID FROM PurchaseOrdersSync WHERE PONumber=@PONumber),@CreatedBy,GETDATE(),'Price has been changed'

SELECT 200 SuccessCode, 'Price Changed Successfully.' Message
END