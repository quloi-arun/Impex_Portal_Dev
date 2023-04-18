CREATE TYPE [dbo].[InsertRoletoProjectMapping] AS TABLE (
    [RoleMasterId] INT NULL,
    [ProjectId]    INT NULL,
    [MenuId]       INT NULL,
    [SubMenuId]    INT NULL,
    [FunctionId]   INT NULL,
    [IsChecked]    BIT NULL);

