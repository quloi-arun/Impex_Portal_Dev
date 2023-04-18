
CREATE PROCEDURE [dbo].[USP_UpdateLatestAction] @FormName VARCHAR(30),@Id INT,@ActionTaken VARCHAR(20),@CreatedBy VARCHAR(50),@CreatedById INT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @trancount INT,@Message VARCHAR(500),@Scope INT
SET @trancount = @@trancount;
BEGIN try
IF @trancount = 0
BEGIN TRANSACTION
ELSE
SAVE TRANSACTION USP_UpdateLatestAction
IF(@FormName = 'PO')
BEGIN
UPDATE [dbo].[PurchaseOrdersSync] SET LatestAction = @ActionTaken WHERE POID = @Id
INSERT INTO ActionHistory (FormName,ID,ActionTaken,CreatedDate,CreatedBy,CreateById)
SELECT @FormName,@Id,@ActionTaken,GETDATE(),@CreatedBy,@CreatedById
SELECT 'Status Updated Successfully.' Message ,200 SuccessCode
IF(@ActionTaken IN ('Accepted','Rejected'))
BEGIN
INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate)
SELECT 'Purchase Order',(SELECT PONumber FROM [dbo].[PurchaseOrdersSync] WHERE POID=@Id),
'PO '+@ActionTaken,'Update',(SELECT SupplierID FROM [dbo].[PurchaseOrdersSync] WHERE POID=@Id),@CreatedById,GETDATE()
END
END ELSE IF (@FormName = 'GRN')
--BEGIN
--UPDATE [dbo].[PendingSalesOrderSync] SET LatestAction = @ActionTaken WHERE FileID = @Id
--INSERT INTO ActionHistory (FormName,ID,ActionTaken,CreatedDate,CreatedBy,CreateById)
--SELECT @FormName,@Id,@ActionTaken,GETDATE(),@CreatedBy,@CreatedById
--END ELSE IF (@FormName = 'QC')
BEGIN
UPDATE [dbo].[WarehouseReceiptsSync] SET LatestAction = @ActionTaken WHERE ReceiptID = @Id
INSERT INTO ActionHistory (FormName,ID,ActionTaken,CreatedDate,CreatedBy,CreateById)
SELECT @FormName,@Id,@ActionTaken,GETDATE(),@CreatedBy,@CreatedById
SELECT 'Status Updated Successfully.' Message ,200 SuccessCode
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
ROLLBACK TRANSACTION USP_UpdateLatestAction;
RAISERROR ('USP_UpdateLatestAction: %d: %s', 16, 1, @error, @message);
RETURN;
END CATCH
END
