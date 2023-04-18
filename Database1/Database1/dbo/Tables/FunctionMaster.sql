CREATE TABLE [dbo].[FunctionMaster] (
    [FunctionId]   INT          IDENTITY (1, 1) NOT NULL,
    [FunctionName] VARCHAR (80) NOT NULL,
    [CreateDate]   DATETIME     NOT NULL,
    [ModifyDate]   DATETIME     NULL,
    [IsActive]     BIT          NULL,
    [IsDeleted]    BIT          NULL,
    [CreatedBy]    INT          NOT NULL,
    [DeletedBy]    INT          NULL,
    [Modified_By]  INT          NULL,
    [DeletedDate]  DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([FunctionId] ASC)
);

