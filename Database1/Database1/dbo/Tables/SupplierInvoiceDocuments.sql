CREATE TABLE [dbo].[SupplierInvoiceDocuments] (
    [SupplierInvoiceDocumentsID] INT             IDENTITY (1, 1) NOT NULL,
    [POID]                       INT             NULL,
    [PONumber]                   VARCHAR (20)    NULL,
    [InvoiceNo]                  VARCHAR (20)    NULL,
    [InvoiceAmount]              DECIMAL (17, 2) NULL,
    [InvoiceDocLink]             VARCHAR (500)   NULL,
    [CreatedBy]                  INT             NULL,
    [CreatedDate]                DATETIME        NULL,
    [CargoReadyDate]             DATETIME        NULL,
    [CargoDelayedDate]           DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([SupplierInvoiceDocumentsID] ASC)
);

