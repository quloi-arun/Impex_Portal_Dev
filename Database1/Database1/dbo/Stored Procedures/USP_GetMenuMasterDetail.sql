
CREATE PROCEDURE USP_GetMenuMasterDetail
AS
BEGIN
SELECT
MM.MenuId,MM.MenuName,MM.MenuDescription,MM.MenuOrder,MM.projectId,PM.ProjectName,
MM.CreateDate,MM.ModifyDate
FROM MenuMaster MM
Left Join ProjectMaster PM
on MM.ProjectId=PM.ProjectId
WHERE MM.IsActive = 1 and  MM.IsDeleted=0;
END
