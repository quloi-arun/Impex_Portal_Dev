CREATE PROCEDURE [dbo].[USP_insertCargoDelayedNotification] @SupplierInvoiceDocumentsID INT, @CreatedBy INT
AS
BEGIN
INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,DescriptionHeader)
SELECT 'Purchase Order',SI.PONumber,'Cargo is getting delay for Invoice number : ("'+SI.InvoiceNo+'")',
'Insert',(SELECT TOP 1 PO.SupplierID FROM PurchaseOrdersSync PO WHERE PO.POID=SI.POID),@CreatedBy,GETDATE(),'Cargo is getting delayed'
FROM SupplierInvoiceDocuments SI WHERE SI.SupplierInvoiceDocumentsID=@SupplierInvoiceDocumentsID

SELECT 200 SuccessCode, 'Notification added.' Message
END