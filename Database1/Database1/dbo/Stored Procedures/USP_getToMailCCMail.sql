CREATE PROCEDURE [dbo].[USP_getToMailCCMail] @SupplierId INT,@SendTo VARCHAR(10) --Supplier,Impex,Both
AS
BEGIN

DECLARE @EMail1 VARCHAR(1000) = '',@EMail2 VARCHAR(1000) = '',@BCCMail VARCHAR(500) = ''
SET @BCCMail = (SELECT TOP 1 FieldValue FROM DefaultValues WHERE FieldName='BCCMail')

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM Companies C1
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyId = @SupplierId

SET @EMail1 = (SELECT
STUFF((SELECT DISTINCT
			',' + ISNULL(MUI.Email,'')
		FROM MasterUser MUI
		WHERE MUI.UserType = 'ImpexOperationAdmin'
		FOR XML PATH (''))
	, 1, 1, ''))

SET @EMail2 = (SELECT
	STUFF((SELECT DISTINCT
			',' + ISNULL(MUI.Email,'')
		FROM MasterUser MUI
		WHERE MUI.GlobalId IN (SELECT * FROM #Supplier)
		FOR XML PATH (''))
	, 1, 1, ''))

--SELECT
--	STUFF((SELECT DISTINCT
--			',' + MUI.Email
--		FROM MasterUser MUI
--		WHERE (@SendTo = 'Supplier'
--		AND MUI.GlobalId = @SupplierId)
--		OR (@SendTo = 'Impex'
--		AND MUI.UserType = 'ImpexOperationAdmin')
--		OR (@SendTo = 'Both'
--		AND (MUI.GlobalId = @SupplierId
--		OR MUI.UserType = 'ImpexOperationAdmin'))
--		FOR XML PATH (''))
--	, 1, 1, '') TOMail
--   ,'' CCMail
--   ,'mungare@quloi.com,saylid@quloi.com,ddhande@quloi.com' BCCMail

SELECT 
CASE 
	WHEN @SendTo = 'Supplier' AND ISNULL(@SupplierId,0)>0 THEN @EMail2
	WHEN @SendTo = 'Impex' AND ISNULL(@SupplierId,0)>0 THEN @EMail1
ELSE @BCCMail END TOMail,
CASE 
	WHEN @SendTo = 'Supplier' AND ISNULL(@SupplierId,0)>0 THEN @EMail1
	WHEN @SendTo = 'Impex' AND ISNULL(@SupplierId,0)>0 THEN @EMail2
ELSE @BCCMail END CCMail,
@BCCMail BCCMail
END