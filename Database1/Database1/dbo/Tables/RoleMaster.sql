CREATE TABLE [dbo].[RoleMaster] (
    [RoleId]          INT           IDENTITY (1, 1) NOT NULL,
    [RoleName]        VARCHAR (255) NOT NULL,
    [RoleDescription] VARCHAR (255) NOT NULL,
    [ProjectId]       INT           NOT NULL,
    [ModuleId]        INT           NOT NULL,
    [CreateDate]      DATETIME      NOT NULL,
    [ModifyDate]      DATETIME      NULL,
    [IsActive]        BIT           NULL,
    [IsDeleted]       BIT           NULL,
    [CreatedBy]       INT           NOT NULL,
    [DeletedBy]       INT           NULL,
    [Modified_By]     INT           NULL,
    [DeletedDate]     DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([RoleId] ASC)
);

