CREATE PROCEDURE [dbo].[USP_getWarehoouseReceiptsSearch_Web]     
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
--select @SupplierID=ParentCompanyID from Companies  where companYid=@SupplierId

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId = @SupplierId

SELECT WarehouseReceiptsSync.*     
FROM [dbo].[WarehouseReceiptsSync]  
 --left join Companies C on (C.ParentCompanyID= WarehouseReceiptsSync.SupplierID 
 --or C.companyid=WarehouseReceiptsSync.SupplierID)
WHERE  (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier))
--OR C.ParentCompanyID = @SupplierId or C.companYid =@SupplierId)   
AND ((@fromDate IS NULL OR @toDate IS NULL) OR   
ReceiptDate BETWEEN @FromDate AND @ToDate)    
AND (@PONO = '' OR PONumber = @PONO)   
AND (@RCPTNO = '' OR ReceiptNo = @RCPTNO)  
AND PONumber NOT LIKE 'PD%'  
--AND (@PONumber = NULL OR PONumber = @PONumber)    
--IF @@ROWCOUNT > 0  
--select  SuccessCode=400,Message='Record Not Found'    
END
