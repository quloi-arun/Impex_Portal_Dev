CREATE PROCEDURE [dbo].[USP_PendingSalesOrderSync_Web]     
@fromDate Datetime =null,                            
@toDate Datetime =null,                            
@SupplierID int =0  
AS     
BEGIN 

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId = @SupplierId

SELECT *     
FROM [dbo].[PendingSalesOrderSync]    
WHERE (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier))
--OR SupplierId = @SupplierId)    
AND ((@fromDate IS NULL OR @toDate IS NULL) OR   
Duedate BETWEEN @FromDate AND @ToDate)
AND OrderType='Forecast'
--AND (@PONumber = NULL OR PONumber = @PONumber)    
--IF @@ROWCOUNT > 0  
--select  SuccessCode=400,Message='Record Not Found'    
END
