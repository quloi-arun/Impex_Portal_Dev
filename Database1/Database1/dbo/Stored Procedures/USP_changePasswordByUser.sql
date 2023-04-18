
CREATE PROCEDURE [dbo].[USP_changePasswordByUser]
(
@UserId VARCHAR(50),
@Email VARCHAR(100),
@Password VARCHAR(200)
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
	save transaction USP_changeForgotPassword

IF EXISTS(SELECT 1 FROM MasterUser WHERE Email=@Email AND UserId=@UserId AND IsDeleted=0 AND IsActive=1) 
BEGIN
UPDATE MasterUser SET Password=@Password WHERE Email=@Email AND IsDeleted=0 AND IsActive=1;
SET @_message = 'You have successfully reset your password.'; 
SET @_successCode = 200; 
END
ELSE
BEGIN
SET @_message = 'The email or LoginId you have entered is incorrect.'; 
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
