﻿
CREATE PROCEDURE [dbo].[USP_GetPOAccountInvoices_130722] @POID INT
AS
BEGIN
SELECT POS.POID,POLI.POLineID,POS.PONumber,POS.PODate,POS.PO_Status,POLI.PartNo,POLI.DueDate,POLI.Qty,POLI.RatePerUnit
,RQ.ReceivedQty,(ISNULL(POLI.Qty,0)-ISNULL(RQ.ReceivedQty,0)) BalancedQty
FROM PurchaseOrdersSync POS
JOIN PurchaseOrderLineItemsSync POLI
ON POS.POID = POLI.POID
LEFT JOIN (
SELECT WHRL.POLineID,SUM(WHRL.ReceivedQty) ReceivedQty FROM 
WarehouseReceiptLineItemsSync WHRL
GROUP BY WHRL.POLineID
)RQ
ON POLI.POLineID = RQ.POLineID
WHERE --POS.PODate >='2022-01-01' AND 
POLI.DueDate IS NOT NULL
AND POS.POID = @POID
--AND RQ.ReceivedQty>POLI.Qty
END