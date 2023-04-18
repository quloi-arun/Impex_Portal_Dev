CREATE PROCEDURE USP_GetOnboardingUserDetails @SupplierId INT=0, @Email NVARCHAR(100)=''
AS
BEGIN

SELECT DISTINCT C2.CompanyID,@Email Email FROM Companies C1
LEFT JOIN Companies C2
ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE C1.CompanyID = @SupplierId

END