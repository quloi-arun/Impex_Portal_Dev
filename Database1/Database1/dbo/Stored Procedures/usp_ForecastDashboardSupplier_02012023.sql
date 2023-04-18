Create procedure [dbo].[usp_ForecastDashboardSupplier_02012023](@fromdate date,@todate date,@SupplierID int)  
as  
Begin  
  
SELECT SupplierID,SupplierName,FORMAT(SupplierDueDate, 'MMMM') as Mth  ,count(FORMAT(SupplierDueDate, 'MMMM')) as POCount    
FROM [dbo].[PendingSalesOrderSync]    
where SupplierDueDate between @fromdate and @todate and SupplierID=@SupplierID  
group by SupplierID,SupplierName,FORMAT(SupplierDueDate, 'MMMM')   
  
end  