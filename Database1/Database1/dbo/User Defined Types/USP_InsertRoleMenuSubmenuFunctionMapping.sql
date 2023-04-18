CREATE TYPE [dbo].[USP_InsertRoleMenuSubmenuFunctionMapping] AS TABLE (
    [ProjectID]                INT NULL,
    [RoleId]                   INT NULL,
    [MenuId]                   INT NULL,
    [FunctionId_Menu]          INT NULL,
    [IsAssigneMenuFunction]    BIT NULL,
    [SubMenuId]                INT NULL,
    [FunctionId_SubMenu]       INT NULL,
    [IsAssigneSubMenuFunction] BIT NULL,
    [Createdby]                INT NULL);

