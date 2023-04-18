﻿CREATE TABLE [dbo].[ProjectMaster] (
    [ProjectId]           INT           IDENTITY (1, 1) NOT NULL,
    [ProjectName]         VARCHAR (90)  NOT NULL,
    [WebSiteUrl]          VARCHAR (255) NOT NULL,
    [ProjectDescription]  VARCHAR (255) NULL,
    [Short_Description]   VARCHAR (105) NULL,
    [Status]              VARCHAR (70)  NULL,
    [Budget_Hour]         VARCHAR (70)  NULL,
    [StartDate]           DATETIME      NULL,
    [EndDate]             DATETIME      NULL,
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
    [IsApproved]          BIT           NULL,
    [Modified_By]         INT           NULL,
    [DeletedDate]         DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ProjectId] ASC)
);

