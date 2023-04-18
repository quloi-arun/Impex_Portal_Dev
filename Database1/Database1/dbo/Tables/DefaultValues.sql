CREATE TABLE [dbo].[DefaultValues] (
    [DefaultValuesId] INT           IDENTITY (1, 1) NOT NULL,
    [FieldName]       VARCHAR (50)  NULL,
    [FieldValue]      VARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([DefaultValuesId] ASC)
);

