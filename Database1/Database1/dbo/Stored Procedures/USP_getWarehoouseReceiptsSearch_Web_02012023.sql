CREATE PROCEDURE [dbo].[USP_getWarehoouseReceiptsSearch_Web_02012023]     
--@fromDate Datetime ='',                            
--@toDate Datetime ='',       
@fromDate Datetime =NULL,                            
@toDate Datetime =NULL,    
@PONO nvarchar(50) ='',                            
@RCPTNO nvarchar(50) ='' ,  
@SupplierID int =0  
AS     
BEGIN   
SET @ToDate = DATEADD(dd,1,@ToDate)  
SELECT *     
FROM [dbo].[WarehouseReceiptsSync]  
WHERE (@SupplierId = 0 OR SupplierId = @SupplierId)    
AND ((@fromDate IS NULL OR @toDate IS NULL) OR   
ReceiptDate BETWEEN @FromDate AND @ToDate)    
AND (@PONO = '' OR PONumber = @PONO)   
AND (@RCPTNO = '' OR ReceiptNo = @RCPTNO)  
AND PONumber NOT LIKE 'PD%'  
--AND (@PONumber = NULL OR PONumber = @PONumber)    
--IF @@ROWCOUNT > 0  
--select  SuccessCode=400,Message='Record Not Found'    
END