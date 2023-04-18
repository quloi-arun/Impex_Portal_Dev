CREATE PROCEDURE [dbo].[USP_insertDueDateNotification] @POID INT
AS
BEGIN
INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,DescriptionHeader)
SELECT 'Purchase Order',PO.PONumber,PO.PONumber + ' Purchase Order is due. Please update the status via Impex Portal.',
'Insert',PO.SupplierID,2,GETDATE(),'PO is getting due'
FROM PurchaseOrdersSync PO
WHERE PO.POID = @POID

UPDATE PurchaseOrdersDueHistoryEmail SET MailSentON=GETDATE() WHERE POID = @POID

SELECT 200 SuccessCode, 'Notification added.' Message
END