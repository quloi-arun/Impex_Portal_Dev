CREATE TABLE [dbo].[PriceChangeHistory] (
    [PriceChangeHistory] INT             IDENTITY (1, 1) NOT NULL,
    [POID]               INT             NULL,
    [PONumber]           VARCHAR (50)    NULL,
    [PartNo]             VARCHAR (50)    NULL,
    [OldPrice]           DECIMAL (18, 4) NULL,
    [NewPrice]           DECIMAL (18, 4) NULL,
    [isAcceptReject]     BIT             NULL,
    [AcceptRejectBy]     INT             NULL,
    [AcceptRejectDate]   DATETIME        NULL,
    [CreatedBy]          INT             NULL,
    [CreatedDate]        DATETIME        NULL,
    [RequestIdentifier]  VARCHAR (20)    NULL,
    PRIMARY KEY CLUSTERED ([PriceChangeHistory] ASC)
);

