CREATE TABLE [dbo].[ClientMaster] (
    [ClientId]            INT           IDENTITY (1, 1) NOT NULL,
    [ProjectId]           INT           NOT NULL,
    [ClientName]          VARCHAR (255) NOT NULL,
    [Address]             VARCHAR (255) NOT NULL,
    [StartDate]           DATETIME      NULL,
    [EndDate]             DATETIME      NULL,
    [IsApproved]          BIT           NULL,
    [ContactPersonName]   VARCHAR (100) NULL,
    [ContactEmail]        VARCHAR (100) NULL,
    [ContactPersonMobile] VARCHAR (15)  NULL,
    [RegistrationDate]    DATETIME      NULL,
    [CreateDate]          DATETIME      NOT NULL,
    [ModifyDate]          DATETIME      NULL,
    [IsActive]            BIT           NULL,
    [IsDeleted]           BIT           NULL,
    [CreatedBy]           INT           NOT NULL,
    [DeletedBy]           INT           NULL,
    [DeleteDate]          DATETIME      NULL,
    [Modified_By]         INT           NULL,
    PRIMARY KEY CLUSTERED ([ClientId] ASC)
);

