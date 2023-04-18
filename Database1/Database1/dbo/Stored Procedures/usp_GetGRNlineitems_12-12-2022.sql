
CREATE Procedure [dbo].[usp_GetGRNlineitems_12-12-2022](@ReceiptID as integer)
as
select * from WarehouseReceiptLineItemsSync where ReceiptID=@ReceiptID
