CREATE TABLE [dbo].[EmailLog] (
    [Mail_Form]    NVARCHAR (200) NULL,
    [Mail_To]      NVARCHAR (400) NULL,
    [Mail_ToCC]    NVARCHAR (400) NULL,
    [Mail_Bcc]     NVARCHAR (400) NULL,
    [MailSubject]  NVARCHAR (200) NULL,
    [MailHost]     NVARCHAR (200) NULL,
    [MailPort]     NVARCHAR (200) NULL,
    [SendDatetime] DATETIME       NULL
);

