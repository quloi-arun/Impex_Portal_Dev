
create PROCEDURE [dbo].[USP_UpdateUserTokens]
(
@UserId int,
@passwordSalt VARCHAR(max)

)
AS
BEGIN
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0  
    begin transaction
	else
	save transaction USP_UpdateUserTokens

--declare @_email varchar(90) = 'harshB@gmai.com',@_changePassCode int = 111
IF EXISTS(SELECT 1 FROM UserTokens 
WHERE UserId=@UserId) 
BEGIN
UPDATE UserTokens SET PasswordSalt=@passwordSalt,ModifiedOn=GETDATE()
WHERE UserId=@UserId;
SET @_message = 'You have successfully update your PasswordSalt.'; 
SET @_successCode = 200; 
END
ELSE
BEGIN
SET @_message = 'The user you have entered is incorrect.'; 
SET @_successCode = 400; 
--SELECT @_message Message,@_successCode SuccessCode;
end
lbexit:                          
   if @trancount = 0                           
    commit;
	SELECT @_message Message,@_successCode SuccessCode;
  end try                          
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_changeForgotPassword;            
                        
   raiserror ('USP_changeForgotPassword: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
