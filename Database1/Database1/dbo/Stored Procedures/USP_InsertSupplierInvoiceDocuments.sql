CREATE PROCEDURE [dbo].[USP_InsertSupplierInvoiceDocuments]
@POID INT,@PONumber VARCHAR(20),@InvoiceNo VARCHAR(20),@InvoiceAmount DECIMAL(17,2),
@InvoiceDocLink VARCHAR(500),@CreatedBy INT,
@TVP_SupplierInvoices TVP_SupplierInvoices READONLY
AS
BEGIN
SET NOCOUNT ON;
DECLARE @trancount INT,@Message VARCHAR(500)
SET @trancount = @@trancount;

BEGIN try
IF @trancount = 0
BEGIN TRANSACTION
ELSE
SAVE TRANSACTION USP_InsertSupplierInvoiceDoc

IF EXISTS (SELECT TOP 1 1 FROM SupplierInvoiceDocuments WHERE PONumber = @PONumber AND InvoiceNo = @InvoiceNo)
BEGIN
SELECT 'Invoice No already exists.' Message, 400 SuccessCode
END 
ELSE
BEGIN
DECLARE @DocId INT = 0
INSERT INTO SupplierInvoiceDocuments(POID,PONumber,InvoiceNo,InvoiceAmount,InvoiceDocLink,CreatedBy,CreatedDate)
SELECT @POID,@PONumber,@InvoiceNo,@InvoiceAmount,@InvoiceDocLink,@CreatedBy,GETDATE()

SET @DocId = SCOPE_IDENTITY()

INSERT INTO SupplierInvoices (SupplierInvoiceDocumentsID,POLineId,PartNo,Qty,RatePerUnit,PartRate,
ReceivedQty,BalancedQty,CreatedBy,CreatedDate)
SELECT @DocId,POLineId,PartNo,Qty,RatePerUnit,PartRate,ReceivedQty,BalancedQty,@CreatedBy,GETDATE() 
FROM @TVP_SupplierInvoices

IF(@DocId>0)
BEGIN
SELECT
	'Invoice document details added successfully.' Message
   ,200 SuccessCode

UPDATE [dbo].[PurchaseOrdersSync] SET LatestAction = 'Invoice Generated' WHERE POID = @POID
INSERT INTO ActionHistory (FormName,ID,ActionTaken,CreatedDate,CreatedBy,CreateById)
SELECT 'Invoice Action',@POID,'Invoice Generated',GETDATE(),'Invoice',@CreatedBy

INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,DescriptionHeader)
SELECT 'Invoice Screen',@PONumber,'Invoice ('+@InvoiceNo+') for the '+@PONumber+' Purchase order has been generated.','Update',(SELECT SupplierID FROM PurchaseOrdersSync WHERE POID=@POID),@CreatedBy,GETDATE(),'Invoice has been uploaded'
END
ELSE
BEGIN
SELECT
	'Invoice document details not added.' Message
   ,400 SuccessCode
END
END
LBEXIT:

IF @trancount = 0
COMMIT;
END TRY
BEGIN CATCH
DECLARE @error INT
	   ,@xstate INT;
SELECT
	@error = ERROR_NUMBER()
   ,@Message = ERROR_MESSAGE()
   ,@xstate = XACT_STATE()
IF @xstate = -1
ROLLBACK;
IF @xstate = 1
	AND @trancount = 0
ROLLBACK
IF @xstate = 1
	AND @trancount > 0
ROLLBACK TRANSACTION USP_InsertSupplierInvoiceDoc;
RAISERROR ('USP_InsertSupplierInvoiceDocuments: %d: %s', 16, 1, @error, @message);
RETURN;
END CATCH

END
