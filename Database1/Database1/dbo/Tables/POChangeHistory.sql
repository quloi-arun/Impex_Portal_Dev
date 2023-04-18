CREATE TABLE [dbo].[POChangeHistory] (
    [POChangeHistory]   INT             IDENTITY (1, 1) NOT NULL,
    [POID]              INT             NULL,
    [PONumber]          VARCHAR (50)    NULL,
    [PartNo]            VARCHAR (50)    NULL,
    [OldQty]            DECIMAL (18, 4) NULL,
    [NewQty]            DECIMAL (18, 4) NULL,
    [OldDueDate]        DATETIME        NULL,
    [NewDueDate]        DATETIME        NULL,
    [isAcceptReject]    BIT             NULL,
    [AcceptRejectBy]    INT             NULL,
    [AcceptRejectDate]  DATETIME        NULL,
    [CreatedBy]         INT             NULL,
    [CreatedDate]       DATETIME        NULL,
    [RequestIdentifier] VARCHAR (20)    NULL,
    PRIMARY KEY CLUSTERED ([POChangeHistory] ASC)
);

