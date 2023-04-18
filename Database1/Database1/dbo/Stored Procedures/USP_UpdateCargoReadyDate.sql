CREATE PROCEDURE USP_UpdateCargoReadyDate @SupplierInvoiceDocumentsID INT, @CargoReadyDate DATETIME
AS
BEGIN
UPDATE SupplierInvoiceDocuments SET CargoReadyDate = @CargoReadyDate WHERE SupplierInvoiceDocumentsID = @SupplierInvoiceDocumentsID
SELECT 'Cargo Ready Date updated successfully' Message, 200 SuccessCode
END