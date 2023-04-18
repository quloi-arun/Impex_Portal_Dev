CREATE TABLE [dbo].[SubMenuMaster] (
    [SubMenuId]          INT           IDENTITY (1, 1) NOT NULL,
    [SubMenuName]        VARCHAR (255) NOT NULL,
    [SUbMenuDescription] VARCHAR (255) NOT NULL,
    [SubMenuOrder]       VARCHAR (255) NULL,
    [SubMenuIcon]        VARCHAR (255) NULL,
    [ProjectId]          INT           NULL,
    [ModuleId]           INT           NULL,
    [MenuId]             INT           NULL,
    [CreateDate]         DATETIME      NOT NULL,
    [ModifyDate]         DATETIME      NULL,
    [IsActive]           BIT           NULL,
    [IsDeleted]          BIT           NULL,
    [CreatedBy]          INT           NOT NULL,
    [DeletedBy]          INT           NULL,
    [Modified_By]        INT           NULL,
    [DeleteDate]         DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([SubMenuId] ASC)
);

