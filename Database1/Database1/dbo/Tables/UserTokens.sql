CREATE TABLE [dbo].[UserTokens] (
    [HashId]       INT           IDENTITY (1, 1) NOT NULL,
    [PasswordSalt] VARCHAR (200) NULL,
    [UserId]       INT           NULL,
    [CreatedOn]    DATETIME      NULL,
    [ModifiedOn]   DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([HashId] ASC)
);

