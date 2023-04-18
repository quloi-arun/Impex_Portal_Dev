CREATE TABLE [dbo].[PurchaseOrdersSync_bk] (
    [POID]          INT            NOT NULL,
    [PONumber]      NVARCHAR (30)  NULL,
    [PODate]        DATETIME       NULL,
    [POType]        NVARCHAR (20)  NULL,
    [Supplier]      NVARCHAR (100) NULL,
    [Customer]      NVARCHAR (100) NULL,
    [PaymentTerms]  NVARCHAR (50)  NULL,
    [DeliveryTerms] NVARCHAR (50)  NULL,
    [PO_Status]     VARCHAR (30)   NULL,
    [Remarks]       NVARCHAR (500) NULL,
    [SupplierID]    INT            NULL,
    [CreatedDate]   DATETIME       NULL,
    [LatestAction]  VARCHAR (20)   NULL,
    [FTPLink]       VARCHAR (200)  NULL,
    [DueDate]       DATETIME       NULL,
    [Email]         VARCHAR (100)  NULL
);

