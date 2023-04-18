CREATE TABLE [dbo].[ActionHistory] (
    [ActionHistoryId] INT           IDENTITY (1, 1) NOT NULL,
    [FormName]        VARCHAR (30)  NULL,
    [ID]              INT           NULL,
    [ActionTaken]     VARCHAR (20)  NULL,
    [CreatedDate]     DATETIME      NULL,
    [CreatedBy]       VARCHAR (50)  NULL,
    [CreateById]      INT           NULL,
    [RejectedReason]  VARCHAR (500) NULL,
    [EmailSentDate]   DATETIME      NULL,
    CONSTRAINT [PK_ActionHistoryId] PRIMARY KEY CLUSTERED ([ActionHistoryId] ASC)
);

