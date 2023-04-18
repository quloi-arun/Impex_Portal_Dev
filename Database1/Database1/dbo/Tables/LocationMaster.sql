CREATE TABLE [dbo].[LocationMaster] (
    [LocId]        INT           IDENTITY (1, 1) NOT NULL,
    [locationName] VARCHAR (255) NOT NULL,
    [LocationCode] VARCHAR (255) NOT NULL,
    [CreateDate]   DATETIME      NOT NULL,
    [ModifyDate]   DATETIME      NULL,
    [IsActive]     BIT           NULL,
    [IsDeleted]    BIT           NULL,
    [CreatedBy]    INT           NOT NULL,
    [DeletedBy]    INT           NULL,
    PRIMARY KEY CLUSTERED ([LocId] ASC)
);

