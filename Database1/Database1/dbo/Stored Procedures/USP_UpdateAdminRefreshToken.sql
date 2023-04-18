CREATE PROCEDURE [dbo].[USP_UpdateAdminRefreshToken](
@_UserId varchar(100),
@_Token varchar(max),
@_RefreshToken varchar(max),
@_CreatedDate datetime,    
@_ExpirationDate datetime, 
@_IpAddress nvarchar(200) ,
@_IsActive bit,    
@_IsInvalidated  bit
)
AS
BEGIN

set nocount on;  
  declare @trancount int;  
  set @trancount = @@trancount;  
  begin try  
   if @trancount = 0  
    begin transaction
	else
	save transaction  USP_InsertAdminRefreshToken
 
UPDATE UserRefreshToken set  UserId=@_UserId,Token=@_Token ,RefreshToken=@_RefreshToken,CreateDate=@_CreatedDate,
ExpiretionDate=@_ExpirationDate,IpAddress=@_IpAddress
,IsActive=@_IsActive,InValidated=@_IsInvalidated



	lbexit:  
    if @trancount = 0   
    commit; 
	SELECT 'Records Update Successfully' Message
  end try
 begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertAdminRefreshToken;            
                        
   raiserror ('USP_UPdateAdminRefreshToken: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END