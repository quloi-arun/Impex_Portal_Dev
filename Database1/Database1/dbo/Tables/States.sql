CREATE TABLE [dbo].[States] (
    [StateId]   INT           IDENTITY (1, 1) NOT NULL,
    [Statename] VARCHAR (255) NOT NULL,
    [CountryId] INT           NULL,
    PRIMARY KEY CLUSTERED ([StateId] ASC)
);

