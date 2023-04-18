CREATE TABLE [dbo].[ImpexAudit] (
    [AuditId]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [Area]            VARCHAR (50)  NULL,
    [ControllerName]  VARCHAR (50)  NULL,
    [ActionName]      VARCHAR (50)  NULL,
    [LoginStatus]     VARCHAR (1)   NULL,
    [LoggedInAt]      VARCHAR (23)  NULL,
    [LoggedOutAt]     VARCHAR (23)  NULL,
    [PageAccessed]    VARCHAR (500) NULL,
    [IPAddress]       VARCHAR (50)  NULL,
    [SessionID]       VARCHAR (50)  NULL,
    [UserID]          VARCHAR (50)  NULL,
    [RoleId]          VARCHAR (2)   NULL,
    [UserName]        VARCHAR (50)  NULL,
    [UserEmail]       VARCHAR (50)  NULL,
    [IsFirstLogin]    VARCHAR (2)   NULL,
    [IsOTPRequired]   BIT           NULL,
    [CurrentDatetime] VARCHAR (23)  NULL,
    [UrlReferrer]     VARCHAR (MAX) NULL
);

