
CREATE PROCEDURE USP_GetSubMenuMasterDetail
AS
BEGIN
SELECT
SM.SubMenuId,SM.SubMenuName,SM.SUbMenuDescription,SM.SubMenuOrder, SM.MenuId,MM.MenuName,SM.ProjectId,PM.ProjectName,MM.MenuOrder
FROM SubMenuMaster SM
left join  MenuMaster MM
ON SM.MenuId=MM.MenuId 
Left join ProjectMaster PM
ON SM.ProjectId=PM.ProjectId
where SM.IsActive=1 and SM.IsDeleted=0;
END
