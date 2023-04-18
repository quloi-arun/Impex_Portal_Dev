CREATE TABLE [dbo].[SupplierInvoices] (
    [SupplierInvoicesId]         INT             IDENTITY (1, 1) NOT NULL,
    [SupplierInvoiceDocumentsID] INT             NULL,
    [POLineId]                   INT             NULL,
    [PartNo]                     VARCHAR (50)    NULL,
    [Qty]                        INT             NULL,
    [RatePerUnit]                DECIMAL (17, 2) NULL,
    [PartRate]                   DECIMAL (17, 2) NULL,
    [ReceivedQty]                INT             NULL,
    [BalancedQty]                INT             NULL,
    [CreatedBy]                  INT             NULL,
    [CreatedDate]                DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([SupplierInvoicesId] ASC)
);

