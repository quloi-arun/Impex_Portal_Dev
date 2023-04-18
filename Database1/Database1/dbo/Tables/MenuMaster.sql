CREATE TABLE [dbo].[MenuMaster] (
    [MenuId]          INT           IDENTITY (1, 1) NOT NULL,
    [MenuName]        VARCHAR (255) NOT NULL,
    [MenuDescription] VARCHAR (255) NOT NULL,
    [MenuOrder]       VARCHAR (255) NULL,
    [MenuIcon]        VARCHAR (255) NULL,
    [ProjectId]       INT           NULL,
    [ModuleId]        INT           NULL,
    [CreateDate]      DATETIME      NOT NULL,
    [ModifyDate]      DATETIME      NULL,
    [IsActive]        BIT           NULL,
    [IsDeleted]       BIT           NULL,
    [CreatedBy]       INT           NOT NULL,
    [DeletedBy]       INT           NULL,
    [Modified_By]     INT           NULL,
    [DeleteDate]      DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([MenuId] ASC)
);

