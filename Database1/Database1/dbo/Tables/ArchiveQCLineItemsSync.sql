CREATE TABLE [dbo].[ArchiveQCLineItemsSync] (
    [QCLineItemID]      INT             NULL,
    [ReceiptLineItemID] INT             NULL,
    [SupplierId]        INT             NULL,
    [POID]              INT             NULL,
    [Supplier]          NVARCHAR (100)  NULL,
    [PONumber]          VARCHAR (30)    NULL,
    [PartNo]            VARCHAR (50)    NULL,
    [ReceiptNo]         VARCHAR (30)    NULL,
    [ReceiptDate]       DATETIME        NULL,
    [QCStatus]          VARCHAR (20)    NULL,
    [QCStatusDate]      DATETIME        NULL,
    [ReceiptQty]        DECIMAL (18, 2) NULL,
    [AcceptedQty]       DECIMAL (18, 2) NULL,
    [RejectedQty]       DECIMAL (18, 2) NULL,
    [OnHoldQty]         DECIMAL (18, 2) NULL,
    [Reason]            VARCHAR (50)    NULL,
    [MainReason]        VARCHAR (50)    NULL,
    [ModifiedName]      VARCHAR (50)    NULL,
    [ModifiedDate]      DATETIME        NULL,
    [CreatedDate]       DATETIME        NULL
);

