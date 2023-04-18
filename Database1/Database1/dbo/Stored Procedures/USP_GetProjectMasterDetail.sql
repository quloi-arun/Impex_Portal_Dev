

CREATE PROCEDURE USP_GetProjectMasterDetail
AS
BEGIN
SELECT
ProjectId,ProjectName,WebSiteUrl,Short_Description,ContactPersonName,
ContactEmail,ContactPersonMobile,RegistrationDate,
CreateDate,ModifyDate,IsActive
FROM ProjectMaster 
WHERE IsActive = 1 and IsDeleted=0;
END
