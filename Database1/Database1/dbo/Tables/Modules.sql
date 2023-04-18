CREATE TABLE [dbo].[Modules] (
    [ModuleId]          INT           IDENTITY (1, 1) NOT NULL,
    [ModuleName]        VARCHAR (255) NOT NULL,
    [ModuleDescription] VARCHAR (255) NOT NULL,
    [ProjectId]         INT           NOT NULL,
    [CreateDate]        DATETIME      NOT NULL,
    [ModifyDate]        DATETIME      NULL,
    [IsActive]          TINYINT       NULL,
    [IsDeleted]         TINYINT       NULL,
    [CreatedBy]         INT           NOT NULL,
    [DeletedBy]         INT           NULL,
    [Modified_By]       INT           NULL,
    [DeletedDate]       DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ModuleId] ASC)
);

