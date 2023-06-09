﻿CREATE TABLE [dbo].[PurchaseOrderLineItemsSync] (
    [POLineID]            INT             NOT NULL,
    [POID]                INT             NULL,
    [OrderImportLineID]   INT             NULL,
    [PartID]              INT             NULL,
    [PartNo]              VARCHAR (100)   NULL,
    [DueDate]             DATETIME        NULL,
    [PartDesc]            NVARCHAR (200)  NULL,
    [Qty]                 INT             NULL,
    [RatePerUnit]         DECIMAL (18, 4) NULL,
    [Currency]            VARCHAR (10)    NULL,
    [TotalUnit]           DECIMAL (18, 4) NULL,
    [CountPerUnit]        DECIMAL (18, 2) NULL,
    [UOM]                 VARCHAR (5)     NULL,
    [CurrencyRatePerUnit] DECIMAL (18, 4) NULL,
    [TotalAmount]         DECIMAL (18, 4) NULL,
    [TotalUSDAmount]      DECIMAL (18, 4) NULL,
    [SuppPoNumber]        VARCHAR (50)    NULL,
    [ShipToLocation]      VARCHAR (20)    NULL,
    [FileID]              INT             NULL,
    [Inputs]              VARCHAR (20)    NULL,
    [isReverseCharges]    BIT             NULL,
    [isExemptSupplies]    BIT             NULL,
    [isNilSupplies]       BIT             NULL,
    [isNonGSTSupplies]    BIT             NULL,
    [HSN]                 INT             NULL,
    [StockQty]            INT             NULL,
    CONSTRAINT [PK_PurchaseOrderLineItemsSync] PRIMARY KEY CLUSTERED ([POLineID] ASC)
);

