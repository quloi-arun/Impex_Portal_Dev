
CREATE PROCEDURE USP_GetMenuMasterDetailById(@_MenuId int)
AS
BEGIN
SELECT
MenuId,MenuName,MenuDescription,MenuOrder,MenuIcon,ProjectId,ModuleId,IsActive
FROM MenuMaster 
WHERE IsActive = 1 and IsDeleted=0 and MenuId =@_MenuId;
END
