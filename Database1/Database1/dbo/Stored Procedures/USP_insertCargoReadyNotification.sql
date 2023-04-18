CREATE PROCEDURE [dbo].[USP_insertCargoReadyNotification] @SupplierInvoiceDocumentsID INT, @CreatedBy INT
AS
BEGIN
INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,DescriptionHeader)
SELECT 'Purchase Order',SI.PONumber,'Cargo ready for '+SI.PONumber+ ' (Invoice Number : "'+SI.InvoiceNo+'")',
'Insert',(SELECT TOP 1 PO.SupplierID FROM PurchaseOrdersSync PO WHERE PO.POID=SI.POID),@CreatedBy,GETDATE(),'Cargo is ready for '+SI.PONumber
FROM SupplierInvoiceDocuments SI WHERE SI.SupplierInvoiceDocumentsID=@SupplierInvoiceDocumentsID

SELECT 200 SuccessCode, 'Notification added.' Message
END