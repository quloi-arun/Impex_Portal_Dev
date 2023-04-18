

Create procedure usp_InsertImpexPortalActionLog(@ModuleName varchar(30)
           ,@Header varchar(100)
           ,@Description varchar(500)
           ,@Action varchar(30)
           ,@ViewBy int
           ,@UserID int
           ,@CreatedBy int
           )
		   as
		   Begin
INSERT INTO [dbo].[ImpexPortalActionLog]
           ([ModuleName]
           ,[Header]
           ,[Description]
           ,[Action]
           ,[ViewBy]
           ,[UserID]
           ,[CreatedBy]
           ,[CreatedDate])
     VALUES
           (@ModuleName,@header,@Description,@Action,@ViewBy,@UserID,@createdBY,getdate())
End

