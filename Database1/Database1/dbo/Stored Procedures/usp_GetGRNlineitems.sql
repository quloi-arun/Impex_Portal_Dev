CREATE Procedure [dbo].[usp_GetGRNlineitems](@ReceiptID as integer)
as
select WHRL.*,WHR.ReceiptNo from WarehouseReceiptLineItemsSync WHRL
JOIN WarehouseReceiptsSync WHR
ON WHRL.ReceiptLineItemID = WHR.ReceiptLineItemID
where WHRL.ReceiptID=@ReceiptID