CREATE TYPE [dbo].[USP_InsertRoleMenuSubmenuFunctionMapping1] AS TABLE (
    [SRNO]                     INT IDENTITY (1, 1) NOT NULL,
    [ProjectID]                INT NULL,
    [RoleId]                   INT NULL,
    [MenuId]                   INT NULL,
    [FunctionId_Menu]          INT NULL,
    [IsAssigneMenuFunction]    BIT NULL,
    [SubMenuId]                INT NULL,
    [FunctionId_SubMenu]       INT NULL,
    [IsAssigneSubMenuFunction] BIT NULL,
    [Createdby]                INT NULL);

