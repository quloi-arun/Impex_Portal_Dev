CREATE PROCEDURE [dbo].[USP_getSupplierInvoicesDetails]  
@SupplierId INT = 0,  
@FromDate DATETIME = NULL,  
@ToDate DATETIME = NULL  
AS  
BEGIN  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SET @ToDate = DATEADD(dd, 1, @ToDate)

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId = @SupplierId

SELECT  
 PO.POID  
   ,PO.PONumber  
   ,PO.SupplierID  
   ,PO.Supplier  
   ,SIM.PartNo
   ,SIDoc.InvoiceNo  
   ,SIDoc.InvoiceAmount  
   ,SIDoc.InvoiceDocLink  
   ,SIDoc.CargoReadyDate  
   ,SIDoc.CargoDelayedDate  
   ,MU.LoginId  
   ,SIDoc.CreatedDate 
   ,SIDoc.SupplierInvoiceDocumentsID
FROM SupplierInvoiceDocuments SIDoc  
CROSS APPLY (SELECT TOP 1  
  SI.PartNo  
 FROM SupplierInvoices SI  
 WHERE SIDoc.SupplierInvoiceDocumentsID = SI.SupplierInvoiceDocumentsID) SIM  
JOIN PurchaseOrdersSync PO  
 ON SIDoc.POID = PO.POID  
LEFT JOIN MasterUser MU  
 ON SIDoc.CreatedBy = MU.UserId  
WHERE ((@FromDate IS NULL OR @ToDate IS NULL) OR SIDoc.CreatedDate BETWEEN @FromDate AND @ToDate)  
AND (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier))
ORDER BY SIDoc.CreatedDate DESC  

SELECT  
 PO.POID  
   ,PO.PONumber  
   ,PO.SupplierID  
   ,PO.Supplier  
   ,SI.PartNo
   ,SIDoc.InvoiceNo  
   ,SIDoc.InvoiceAmount  
   ,SIDoc.InvoiceDocLink  
   ,SIDoc.CargoReadyDate  
   ,SIDoc.CargoDelayedDate  
   ,MU.LoginId  
   ,SIDoc.CreatedDate  
   ,SIDoc.SupplierInvoiceDocumentsID
FROM SupplierInvoiceDocuments SIDoc  
JOIN SupplierInvoices SI  
ON SIDoc.SupplierInvoiceDocumentsID = SI.SupplierInvoiceDocumentsID
JOIN PurchaseOrdersSync PO  
 ON SIDoc.POID = PO.POID  
LEFT JOIN MasterUser MU  
 ON SIDoc.CreatedBy = MU.UserId  
WHERE ((@FromDate IS NULL OR @ToDate IS NULL) OR SIDoc.CreatedDate BETWEEN @FromDate AND @ToDate)  
AND (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier))
ORDER BY SIDoc.CreatedDate DESC  
END