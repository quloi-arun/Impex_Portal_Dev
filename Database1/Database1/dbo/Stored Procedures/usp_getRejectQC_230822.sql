CREATE procedure [dbo].[usp_getRejectQC_230822](@FromDate DATETIME = NULL,      
@ToDate DATETIME = NULL  )
as
Begin
select QC.*,Customer,Email,LatestAction,PODate,PONumber,PaymentTerms,Remarks,Supplier,DueDate 
from [dbo].[QCLineItemsSync] QC
JOIN PurchaseOrdersSync POS
ON QC.POID = POS.POID
where RejectedQty>0 and  
QCStatusDate BETWEEN @FromDate AND @ToDate
END