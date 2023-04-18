
CREATE PROCEDURE [dbo].[USP_changeForgotPassword]
(
@UserId int,
@_changePassCode VARCHAR(50),
@_email VARCHAR(100),
@_newPassword VARCHAR(200)
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
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
	SET @_message = 'Error while inserting passcode.'; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;
    --#For raising an error use RESIGNAL
    --#RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END;
START TRANSACTION; */
--declare @_email varchar(90) = 'harshB@gmai.com',@_changePassCode int = 111
IF EXISTS(SELECT 1 FROM MasterUser 
WHERE email=@_email AND PassCode=@_changePassCode AND PassCode IS NOT NULL) 
BEGIN
UPDATE MasterUser SET Password=@_newPassword,Passcode=NULL 
WHERE Email=@_email AND PassCode=@_changePassCode and UserId=@UserId;
SET @_message = 'You have successfully reset your password.'; 
SET @_successCode = 200; 
END
ELSE
BEGIN
SET @_message = 'The email or passcode you have entered is incorrect.'; 
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
