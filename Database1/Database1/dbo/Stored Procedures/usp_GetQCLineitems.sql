Create Procedure usp_GetQCLineitems(@ReceiptID as integer)
as
select * from WarehouseReceiptLineItemsSync WRS 
left join QCLineItemsSync QC on WRS.ReceiptLineItemID=QC.ReceiptLineItemID where ReceiptID=@ReceiptID
