CREATE TABLE [dbo].[QCLineItemsSync] (
    [QCLineItemID]              INT             NOT NULL,
    [QCID]                      INT             NOT NULL,
    [ReceiptLineItemID]         INT             NULL,
    [ReceiptQty]                DECIMAL (18, 2) NULL,
    [AcceptedQty]               DECIMAL (18, 2) NULL,
    [RejectedQty]               DECIMAL (18, 2) NULL,
    [OnHoldQty]                 DECIMAL (18, 2) NULL,
    [QCStatus]                  NVARCHAR (20)   NULL,
    [QCStatusDate]              DATETIME        NULL,
    [POLineID]                  INT             NOT NULL,
    [OrderImportLineID]         INT             NOT NULL,
    [POID]                      INT             NOT NULL,
    [ShipToLocation]            NVARCHAR (100)  NOT NULL,
    [SupplierId]                INT             NOT NULL,
    [CustomerId]                INT             NOT NULL,
    [RejectedInvoiceLineItemId] INT             NOT NULL,
    [PendingQty]                INT             NULL,
    [TotalUnit]                 DECIMAL (18, 4) NULL,
    [CountPerUnit]              DECIMAL (18, 2) NULL,
    [UOM]                       VARCHAR (5)     NULL,
    [RatePerUnit]               DECIMAL (18, 2) NULL,
    [CurrencyRatePerUnit]       DECIMAL (18, 4) NULL,
    [TotalAmount]               DECIMAL (18, 4) NULL,
    [TotalUSDAmount]            DECIMAL (18, 4) NULL,
    [SuppPoNumber]              VARCHAR (50)    NULL,
    [StockQty]                  INT             NULL,
    [MainReason]                VARCHAR (50)    NULL,
    [Reason]                    VARCHAR (50)    NULL,
    [ModifiedBy]                INT             NULL,
    [ModifiedName]              VARCHAR (50)    NULL,
    [ModifiedDate]              DATETIME        NULL,
    CONSTRAINT [PK_QCLineItemsSync] PRIMARY KEY CLUSTERED ([QCLineItemID] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_QCLineItemsSync_REJ] ON [dbo].[QCLineItemsSync]
FOR UPDATE,INSERT 
NOT FOR REPLICATION 
AS
BEGIN
IF EXISTS (SELECT I.QCLineItemID FROM INSERTED I
	LEFT JOIN DELETED QC 
	ON I.QCLineItemID = QC.QCLineItemID
	WHERE I.RejectedQty > 0.00 AND (I.RejectedQty<>QC.RejectedQty OR I.Reason<>QC.Reason OR I.MainReason<>QC.MainReason OR QC.QCLineItemID IS NULL))
BEGIN
	INSERT INTO ArchiveQCLineItemsSync (QCLineItemID, ReceiptLineItemID, SupplierId, POID, Supplier, PONumber, PartNo, ReceiptNo, ReceiptDate, QCStatus, QCStatusDate,
	ReceiptQty, AcceptedQty, RejectedQty, OnHoldQty, Reason, MainReason, ModifiedName, ModifiedDate, CreatedDate)
	SELECT QC.QCLineItemID,QC.ReceiptLineItemID,QC.SupplierId,QC.POID,PO.Supplier,PO.PONumber,WR.PartNo,WR.ReceiptNo
	,WR.ReceiptDate,QC.QCStatus,QC.QCStatusDate,QC.ReceiptQty,QC.AcceptedQty,QC.RejectedQty,QC.OnHoldQty,QC.Reason
	,QC.MainReason,QC.ModifiedName,QC.ModifiedDate,GETDATE()
	FROM INSERTED QC
	LEFT JOIN PurchaseOrdersSync PO
		ON QC.POID = PO.POID
	LEFT JOIN WarehouseReceiptsSync WR
		ON QC.ReceiptLineItemID = WR.ReceiptLineItemID
END
END



