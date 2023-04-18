CREATE TABLE [dbo].[Cities] (
    [CityId]   INT           IDENTITY (1, 1) NOT NULL,
    [CityName] VARCHAR (255) NOT NULL,
    [StateId]  INT           NULL,
    PRIMARY KEY CLUSTERED ([CityId] ASC)
);

