

CREATE PROCEDURE USP_GetProjectMasterDetailById(@_ProjectId int)
AS
BEGIN
SELECT
ProjectId,ProjectName,WebSiteUrl,Short_Description,ContactPersonName,ContactEmail,ContactEmail,ContactPersonMobile,RegistrationDate,
CreateDate,ModifyDate,IsActive
FROM ProjectMaster 
WHERE IsActive=1 and IsDeleted=0 and ProjectId=@_ProjectId;
END
