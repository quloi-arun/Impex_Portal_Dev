

CREATE PROCEDURE USP_GetSubMenuMasterDetailById
(
@_SubMenuId int
)
AS
BEGIN
SELECT
SM.SubMenuId,SM.SubMenuName,SM.SUbMenuDescription,SM.SubMenuOrder,MM.MenuName,SM.ProjectId,SM.MenuId
FROM SubMenuMaster SM
left join  MenuMaster MM
ON SM.MenuId=MM.MenuId and SM.SubMenuId=@_SubMenuId and SM.IsActive=1 and SM.IsDeleted=0 
where SM.SubMenuId =@_SubMenuId;
END