CREATE TABLE [dbo].[L_SubMenu_Function] (
    [SubMenu_FunctionId] INT      IDENTITY (1, 1) NOT NULL,
    [RoleId]             INT      NULL,
    [SubMenuId]          INT      NULL,
    [FunctionId]         INT      NULL,
    [CreateDate]         DATETIME NOT NULL,
    [ModifyDate]         DATETIME NULL,
    [IsActive]           BIT      NULL,
    [IsDeleted]          BIT      NULL,
    [CreatedBy]          INT      NOT NULL,
    [DeletedBy]          INT      NULL,
    [DeleteDate]         DATETIME NULL,
    [Modified_By]        INT      NULL,
    PRIMARY KEY CLUSTERED ([SubMenu_FunctionId] ASC)
);

