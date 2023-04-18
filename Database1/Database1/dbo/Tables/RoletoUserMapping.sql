CREATE TABLE [dbo].[RoletoUserMapping] (
    [RoletoUserMappingId] INT      IDENTITY (1, 1) NOT NULL,
    [ProjectId]           INT      NULL,
    [RoleId]              INT      NULL,
    [UserId]              INT      NOT NULL,
    [CreatedBy]           INT      NOT NULL,
    [CreateDate]          DATETIME NULL,
    [Modified_By]         INT      NULL,
    [ModifyDate]          DATETIME NULL,
    [IsDeleted]           BIT      NULL,
    [DeletedBy]           INT      NULL,
    [DeleteDate]          DATETIME NULL,
    PRIMARY KEY CLUSTERED ([RoletoUserMappingId] ASC)
);

