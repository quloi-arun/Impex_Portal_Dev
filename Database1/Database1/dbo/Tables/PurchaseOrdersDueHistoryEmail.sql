CREATE TABLE [dbo].[PurchaseOrdersDueHistoryEmail] (
    [PurchaseOrdersDueHistoryEmailId] INT            IDENTITY (1, 1) NOT NULL,
    [POID]                            INT            NULL,
    [PONumber]                        VARCHAR (30)   NULL,
    [PartNo]                          VARCHAR (50)   NULL,
    [Qty]                             INT            NULL,
    [DueDate]                         DATETIME       NULL,
    [CreatedDate]                     DATETIME       NULL,
    [MailSentON]                      DATETIME       NULL,
    [MailSentTo]                      VARCHAR (2000) NULL,
    PRIMARY KEY CLUSTERED ([PurchaseOrdersDueHistoryEmailId] ASC)
);

