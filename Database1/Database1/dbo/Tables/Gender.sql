CREATE TABLE [dbo].[Gender] (
    [GenderId] INT           IDENTITY (1, 1) NOT NULL,
    [Gender]   VARCHAR (255) NOT NULL,
    PRIMARY KEY CLUSTERED ([GenderId] ASC)
);

