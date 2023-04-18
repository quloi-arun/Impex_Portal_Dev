CREATE TABLE [dbo].[ImpexPortalActionLog] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [ModuleName]        VARCHAR (30)  NULL,
    [Header]            VARCHAR (100) NULL,
    [Description]       VARCHAR (500) NULL,
    [Action]            VARCHAR (30)  NULL,
    [ViewBy]            INT           NULL,
    [UserID]            INT           NULL,
    [CreatedBy]         INT           NULL,
    [CreatedDate]       DATETIME      NULL,
    [RequestIdentifier] VARCHAR (20)  NULL,
    [Status]            VARCHAR (10)  NULL,
    [DescriptionHeader] VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

