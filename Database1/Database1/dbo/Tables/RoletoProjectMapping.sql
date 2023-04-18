CREATE TABLE [dbo].[RoletoProjectMapping] (
    [RoletoProjectMappingId] INT IDENTITY (1, 1) NOT NULL,
    [RoleMasterId]           INT NULL,
    [ProjectId]              INT NULL,
    [MenuId]                 INT NULL,
    [SubMenuId]              INT NULL,
    [FunctionId]             INT NULL,
    [IsChecked]              BIT NULL,
    PRIMARY KEY CLUSTERED ([RoletoProjectMappingId] ASC)
);

