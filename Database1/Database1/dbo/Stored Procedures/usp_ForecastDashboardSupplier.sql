CREATE procedure [dbo].[usp_ForecastDashboardSupplier](@fromdate date,@todate date,@SupplierID int)  
AS  
BEGIN

--SELECT
--	@SupplierID = ParentCompanyID
--FROM Companies
--WHERE companYid = @SupplierId

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId = @SupplierId

SELECT
	SupplierID
   ,SupplierName
   ,FORMAT(SupplierDueDate, 'MMMM') AS Mth
   ,COUNT(FORMAT(SupplierDueDate, 'MMMM')) AS POCount
FROM [dbo].[PendingSalesOrderSync]
--LEFT JOIN Companies C
--	ON (C.ParentCompanyID = PendingSalesOrderSync.SupplierID
--			OR C.companyid = PendingSalesOrderSync.SupplierID)
WHERE SupplierDueDate BETWEEN @fromdate AND @todate
AND (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier))
--OR C.ParentCompanyID = @SupplierId
--OR C.companYid = @SupplierId)
GROUP BY SupplierID
		,SupplierName
		,FORMAT(SupplierDueDate, 'MMMM')

END