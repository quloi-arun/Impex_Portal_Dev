
--USP_getPOForInvoiceCreation 3114,1,null,null
CREATE PROCEDURE [dbo].[USP_getPOForInvoiceCreation]
@SupplierId INT = 0,
@isInvoicingDone BIT = 0,
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

SELECT * FROM (
SELECT DISTINCT
	PO.POID
   ,PO.PONumber
   ,PO.PODate
   ,PO.POType
   ,PO.Supplier
   ,PO.Customer
   ,PO.PaymentTerms
   ,PO.DeliveryTerms
   ,PO.PO_Status
   ,PO.Remarks
   ,PO.FTPLink
   ,T.duedate
   ,IIF(PO.LatestAction IS NULL, 'New', IIF(Qty.QTY<=IRQ.ReceivedQty OR Qty.QTY<=MO.ReceivedQty OR PO.PO_Status = 'FULLY RECEIVED, ACCEPTED', 'Completed', PO.LatestAction)) LatestAction
   ,PO.Email
   ,CAST(QTY.QTY AS VARCHAR(10)) QTY
   ,CAST(MO.[Pending Qty] AS VARCHAR(10)) PendingQTY
   ,IIF(IPO.POID IS NULL, 0, 1) IsInvoiceGenerated
   ,MO.ReceivedQty TotalGRNQty
   ,IRQ.ReceivedQty TotalInvoiceQty
   ,IIF(Qty.QTY<=IRQ.ReceivedQty OR Qty.QTY<=MO.ReceivedQty OR PO.PO_Status = 'FULLY RECEIVED, ACCEPTED',1,0) InvoiceCompleteStatus
FROM [dbo].[PurchaseOrdersSync] PO
JOIN (SELECT Poid ,COUNT(poid) AS cnt ,MAX(DueDate) DueDate FROM PurchaseOrderLineItemsSync GROUP BY Poid) T
	ON T.poid = PO.poid
LEFT JOIN (SELECT Poid ,SUM(Qty) AS QTY FROM PurchaseOrderLineItemsSync GROUP BY Poid) Qty
	ON Qty.poid = PO.poid
OUTER APPLY (SELECT
		M.POID
	   ,SUM(CAST([Pending Qty] AS INT)) [Pending Qty]
	   ,SUM(CAST(ReceivedQty AS INT)) ReceivedQty
	FROM (SELECT
			ROW_NUMBER() OVER (PARTITION BY P.POID ORDER BY P.POLineID) RN
		   ,P.POID
		   ,P.Qty - COALESCE(QTY.ReceivedQty, 0) AS 'Pending Qty'
		   ,qty.ReceivedQty
		FROM PurchaseOrderLineItemsSync P
		LEFT JOIN (SELECT
				WHRL.POLineID
			   ,SUM(WHRL.ReceivedQty) ReceivedQty
			FROM WarehouseReceiptLineItemsSync WHRL
			GROUP BY WHRL.POLineID) qty
			ON qty.POLineID = P.POLineID) M
	WHERE PO.POID = M.POID
	GROUP BY M.POID) MO
OUTER APPLY (SELECT TOP 1 POID FROM SupplierInvoiceDocuments SI WHERE SI.POID = PO.POID) IPO
OUTER APPLY (SELECT SUM(SI.ReceivedQty) ReceivedQty FROM SupplierInvoiceDocuments SD
JOIN SupplierInvoices SI
ON SD.SupplierInvoiceDocumentsID = SI.SupplierInvoiceDocumentsID
WHERE SD.POID = PO.POID
)IRQ
WHERE ((@FromDate IS NULL OR @ToDate IS NULL) OR PO.CreatedDate BETWEEN @FromDate AND @ToDate)
AND PONumber LIKE 'PI%'
AND (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier))
AND ISNULL(PO.isDeleted,0) = 0
--AND PO.POID=3115515
)M
WHERE M.InvoiceCompleteStatus=@isInvoicingDone
AND M.LatestAction NOT IN ('New','Viewed')
ORDER BY PODate DESC

SELECT * FROM (
SELECT
    PO.POID
   ,PO.PONumber
   ,MO.PartNo
   ,IIF(PO.LatestAction IS NULL, 'New', IIF(Qty.QTY <= IRQ.ReceivedQty OR Qty.QTY <= MO.ReceivedQty OR PO.PO_Status = 'FULLY RECEIVED, ACCEPTED', 'Completed', PO.LatestAction)) LatestAction
   ,CAST(QTY.QTY AS VARCHAR(10)) QTY
   ,CAST(MO.[Pending Qty] AS VARCHAR(10)) PendingQTY
   ,IIF(IPO.POID IS NULL, 0, 1) IsInvoiceGenerated
   ,MO.ReceivedQty TotalGRNQty
   ,IRQ.ReceivedQty TotalInvoiceQty
   ,IIF(Qty.QTY <= IRQ.ReceivedQty OR Qty.QTY <= MO.ReceivedQty OR PO.PO_Status = 'FULLY RECEIVED, ACCEPTED', 1, 0) InvoiceCompleteStatus
FROM [dbo].[PurchaseOrdersSync] PO
JOIN (SELECT
		Poid
	   ,COUNT(poid) AS cnt
	   ,MAX(DueDate) DueDate
	FROM PurchaseOrderLineItemsSync
	GROUP BY Poid) T
	ON T.poid = PO.poid
LEFT JOIN (SELECT
		Poid
	   ,PartNo
	   ,SUM(Qty) AS QTY
	FROM PurchaseOrderLineItemsSync
	GROUP BY Poid
			,PartNo) Qty
	ON Qty.poid = PO.poid
OUTER APPLY (SELECT
		M.POID
	   ,M.PartNo
	   ,SUM(CAST([Pending Qty] AS INT)) [Pending Qty]
	   ,SUM(CAST(ReceivedQty AS INT)) ReceivedQty
	FROM (SELECT
			ROW_NUMBER() OVER (PARTITION BY P.POID ORDER BY P.POLineID) RN
		   ,P.POID
		   ,P.PartNo
		   ,P.Qty - COALESCE(QTY.ReceivedQty, 0) AS 'Pending Qty'
		   ,qty.ReceivedQty
		FROM PurchaseOrderLineItemsSync P
		LEFT JOIN (SELECT
				WHRL.POLineID
			   ,SUM(WHRL.ReceivedQty) ReceivedQty
			FROM WarehouseReceiptLineItemsSync WHRL
			GROUP BY WHRL.POLineID) qty
			ON qty.POLineID = P.POLineID) M
	WHERE PO.POID = M.POID
	AND Qty.PartNo = M.PartNo
	GROUP BY M.POID
			,M.PartNo) MO
OUTER APPLY (SELECT TOP 1
		POID
	FROM SupplierInvoiceDocuments SI
	WHERE SI.POID = PO.POID) IPO
OUTER APPLY (SELECT
		SUM(SI.ReceivedQty) ReceivedQty
	FROM SupplierInvoiceDocuments SD
	JOIN SupplierInvoices SI
		ON SD.SupplierInvoiceDocumentsID = SI.SupplierInvoiceDocumentsID
	WHERE SD.POID = PO.POID
	AND SI.PartNo = MO.PartNo) IRQ
WHERE
((@FromDate IS NULL OR @ToDate IS NULL) OR PO.CreatedDate BETWEEN @FromDate AND @ToDate) AND
PONumber LIKE 'PI%'
AND (@SupplierId = 0 OR SupplierID IN (SELECT * FROM #Supplier))
AND ISNULL(PO.isDeleted, 0) = 0
--AND PO.POID=3115515
)M
WHERE M.InvoiceCompleteStatus=@isInvoicingDone
AND M.LatestAction NOT IN ('New','Viewed')

END
