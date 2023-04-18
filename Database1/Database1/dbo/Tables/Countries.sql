CREATE TABLE [dbo].[Countries] (
    [CountryId]   INT           IDENTITY (1, 1) NOT NULL,
    [CountryName] VARCHAR (255) NOT NULL,
    [SortName]    VARCHAR (55)  NULL,
    [PhoneCode]   INT           NULL,
    PRIMARY KEY CLUSTERED ([CountryId] ASC)
);

