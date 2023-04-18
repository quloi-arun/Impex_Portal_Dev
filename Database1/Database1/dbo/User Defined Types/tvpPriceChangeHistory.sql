CREATE TYPE [dbo].[tvpPriceChangeHistory] AS TABLE (
    [POID]     INT             NULL,
    [PONumber] VARCHAR (50)    NULL,
    [PartNo]   VARCHAR (50)    NULL,
    [OldPrice] DECIMAL (18, 4) NULL,
    [NewPrice] DECIMAL (18, 4) NULL);

