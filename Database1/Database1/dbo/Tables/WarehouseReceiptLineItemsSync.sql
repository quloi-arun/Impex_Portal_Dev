﻿CREATE TABLE [dbo].[WarehouseReceiptLineItemsSync] (
    [ReceiptLineItemID]   INT             NULL,
    [ReceiptID]           INT             NULL,
    [POLineID]            INT             NULL,
    [PartID]              INT             NULL,
    [PartNo]              NVARCHAR (50)   NULL,
    [DueDate]             DATETIME        NULL,
    [PartDesc]            NVARCHAR (200)  NULL,
    [POQty]               INT             NULL,
    [ReceivedQty]         DECIMAL (18, 2) NULL,
    [InvoiceQty]          DECIMAL (18, 2) NULL,
    [OrderImportLineID]   INT             NOT NULL,
    [POID]                INT             NOT NULL,
    [ShipToLocation]      NVARCHAR (100)  NOT NULL,
    [SupplierId]          INT             NOT NULL,
    [CustomerId]          INT             NOT NULL,
    [TotalUnit]           DECIMAL (18, 4) NULL,
    [CountPerUnit]        DECIMAL (18, 2) NULL,
    [UOM]                 VARCHAR (5)     NULL,
    [RatePerUnit]         DECIMAL (18, 2) NULL,
    [CurrencyRatePerUnit] DECIMAL (18, 4) NULL,
    [TotalAmount]         DECIMAL (18, 4) NULL,
    [TotalUSDAmount]      DECIMAL (18, 4) NULL,
    [SuppPoNumber]        VARCHAR (50)    NULL,
    [SAC_Code]            VARCHAR (10)    NULL,
    [SGST]                DECIMAL (18, 2) NULL,
    [SGSTAmount]          DECIMAL (18, 2) NULL,
    [CGST]                DECIMAL (18, 2) NULL,
    [CGSTAmount]          DECIMAL (18, 2) NULL,
    [IGST]                DECIMAL (18, 2) NULL,
    [IGSTAmount]          DECIMAL (18, 2) NULL,
    [StockQty]            INT             NULL
);

