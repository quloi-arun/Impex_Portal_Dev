CREATE procedure usp_getRejectQCCount(@FromDate DATETIME = NULL,        
@ToDate DATETIME = NULL  )  
as  
Begin  
select Count(*) as TotalCount from [dbo].[QCLineItemsSync]  
where RejectedQty>0 and    
QCStatusDate BETWEEN @FromDate AND @ToDate  
END