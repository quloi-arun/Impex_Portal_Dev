CREATE TYPE [dbo].[tvpPOChangeHistory] AS TABLE (
    [POID]       INT             NULL,
    [PONumber]   VARCHAR (50)    NULL,
    [PartNo]     VARCHAR (50)    NULL,
    [OldQty]     DECIMAL (18, 4) NULL,
    [NewQty]     DECIMAL (18, 4) NULL,
    [OldDueDate] DATETIME        NULL,
    [NewDueDate] DATETIME        NULL);

