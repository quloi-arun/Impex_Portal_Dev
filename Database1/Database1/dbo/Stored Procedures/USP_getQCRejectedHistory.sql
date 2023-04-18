CREATE PROCEDURE [dbo].[USP_getQCRejectedHistory] @UserID INT,@FromDate DATETIME = NULL,@ToDate DATETIME = NULL
AS
BEGIN

DECLARE @UserType VARCHAR(20) = ''
SET @UserType = (SELECT UserType FROM MasterUser WHERE UserId = @UserID)
SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN MasterUser MU
ON C1.CompanyID = MU.GlobalId
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE MU.UserId = @UserID

SELECT AQC.* FROM ArchiveQCLineItemsSync AQC
WHERE (@UserType = 'ImpexOperationAdmin' OR AQC.SupplierId IN (SELECT * FROM #Supplier))
AND CAST(AQC.CreatedDate AS DATE)>=@FromDate AND CAST(AQC.CreatedDate AS DATE)<=@ToDate
order by  QCStatusDate desc
END