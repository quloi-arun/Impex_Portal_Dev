CREATE TABLE [dbo].[SavedRoleMenu] (
    [RMSF_Id]                  INT      IDENTITY (1, 1) NOT NULL,
    [ProjectId]                INT      NULL,
    [RoleId]                   INT      NULL,
    [MenuId]                   INT      NULL,
    [IsAssigneMenuFunction]    BIT      NULL,
    [SubMenuId]                INT      NULL,
    [IsAssigneSubMenuFunction] BIT      NULL,
    [IsActive]                 BIT      NULL,
    [CreatedBY]                INT      NOT NULL,
    [DeletedBY]                INT      NULL,
    [ModifiedBY]               INT      NULL,
    [CreateDate]               DATETIME NULL,
    [FunctionId_Menu]          INT      NULL,
    [FunctionId_SubMenu]       INT      NULL
);

