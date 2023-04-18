CREATE Procedure [dbo].[usp_GetPurchaseorderlineitems](@POID as integer)
as
select p.*,PO.PONumber,PO.Supplier,PO.DeliveryTerms,PO.PaymentTerms,
PO.LatestAction,
--LatestAction = IIF(cast(PO.CreatedDate as date) <= '2022-12-14' and PO.LatestAction in('New','Updated','Viewed'),'Accepted',PO.LatestAction),
P.Qty-COALESCE(QTY.ReceivedQty,0) as'Pending Qty' from PurchaseOrderLineItemsSync P
LEFT JOIN PurchaseOrdersSync PO
ON P.POID = PO.POID
--left join (select POLineID ,Sum(InvoiceQty)InvoiceQty from WarehouseReceiptLineItemsSync
--W group by POLineID) Qty 
left join (select POLineID ,Sum(W.ReceivedQty)ReceivedQty from WarehouseReceiptLineItemsSync
W group by POLineID) Qty 
on qty.POLineID= P.POLineID where P.POID=@POID