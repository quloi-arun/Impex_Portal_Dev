CREATE TABLE [dbo].[CommentHistory] (
    [CommentHistoryId] INT           IDENTITY (1, 1) NOT NULL,
    [FormName]         VARCHAR (20)  NULL,
    [ID]               INT           NULL,
    [Comment]          VARCHAR (500) NULL,
    [CommentedBy]      INT           NULL,
    [CommetedDate]     DATETIME      NULL,
    [isEmailSent]      BIT           NULL,
    PRIMARY KEY CLUSTERED ([CommentHistoryId] ASC)
);

