CREATE TABLE [dbo].[OfficeMaster] (
    [OfficeId]       INT           IDENTITY (1, 1) NOT NULL,
    [OfficeName]     VARCHAR (255) NOT NULL,
    [OfficeCodeCode] VARCHAR (255) NOT NULL,
    [CreateDate]     DATETIME      NOT NULL,
    [ModifyDate]     DATETIME      NULL,
    [IsActive]       BIT           NULL,
    [IsDeleted]      BIT           NULL,
    [CreatedBy]      INT           NOT NULL,
    [DeletedBy]      INT           NULL,
    PRIMARY KEY CLUSTERED ([OfficeId] ASC)
);

