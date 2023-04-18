CREATE TABLE [dbo].[UserRefreshToken] (
    [UserRefreshTokenId] INT            IDENTITY (1, 1) NOT NULL,
    [UserId]             INT            NULL,
    [Token]              NVARCHAR (MAX) NULL,
    [RefreshToken]       NVARCHAR (MAX) NULL,
    [CreateDate]         DATETIME       NOT NULL,
    [ExpiretionDate]     DATETIME       NULL,
    [IpAddress]          VARCHAR (100)  NULL,
    [IsActive]           BIT            NULL,
    [InValidated]        BIT            NULL,
    PRIMARY KEY CLUSTERED ([UserRefreshTokenId] ASC)
);

