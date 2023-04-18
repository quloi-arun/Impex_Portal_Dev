
create PROCEDURE [dbo].[USP_UpdateCargoDelayedDate] 
@SupplierInvoiceDocumentsID INT, @CargoDelayedDate DATETIME
AS
BEGIN
UPDATE SupplierInvoiceDocuments
SET CargoDelayedDate = @CargoDelayedDate
WHERE SupplierInvoiceDocumentsID = @SupplierInvoiceDocumentsID
SELECT
	'Cargo Delayed Date updated successfully' Message
   ,200 SuccessCode
END