CREATE TYPE [dbo].[TVP_SupplierInvoices] AS TABLE (
    [POLineId]    INT             NULL,
    [PartNo]      VARCHAR (50)    NULL,
    [Qty]         INT             NULL,
    [RatePerUnit] DECIMAL (17, 2) NULL,
    [PartRate]    DECIMAL (17, 2) NULL,
    [ReceivedQty] INT             NULL,
    [BalancedQty] INT             NULL);

