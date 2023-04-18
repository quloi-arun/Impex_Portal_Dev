

CREATE PROCEDURE [dbo].[USP_InsertAdminRefreshToken](
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
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
    SELECT 'There are some issue while inserting records.' Message,400 SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END;
START TRANSACTION;*/
set nocount on;  
  declare @trancount int;  
  set @trancount = @@trancount;  
  begin try  
   if @trancount = 0  
    begin transaction
	else
	save transaction  USP_InsertAdminRefreshToken
 
INSERT INTO UserRefreshToken(UserId,Token ,RefreshToken,CreateDate,ExpiretionDate,IpAddress,IsActive,InValidated) 

VALUES (@_UserId,@_Token,@_RefreshToken,@_CreatedDate,@_ExpirationDate,@_IpAddress,@_IsActive,@_IsInvalidated
);
	lbexit:  
    if @trancount = 0   
    commit; 
	SELECT 'Records Inserted Successfully' Message
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
                        
   raiserror ('USP_InsertAdminRefreshToken: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
