CREATE PROCEDURE [dbo].[USP_insertInvoiceWarningNotification] @POID INT, @CreatedBy INT,@InvoiceNo VARCHAR(50),@CalculatedAmt FLOAT, @InvoiceAmt FLOAT
AS
BEGIN
INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,DescriptionHeader)
SELECT 'Purchase Order',PO.PONumber,PO.Supplier + ' have tried to upload the incorrect amount ('+CAST(@CalculatedAmt AS VARCHAR(20))+' : '+CAST(@InvoiceAmt AS VARCHAR(20))+') to invoice.',
'Insert',PO.SupplierID,@CreatedBy,GETDATE(),'Wrong Invoice amount applied'
FROM PurchaseOrdersSync PO
WHERE PO.POID = @POID

SELECT 200 SuccessCode, 'Notification added.' Message
END