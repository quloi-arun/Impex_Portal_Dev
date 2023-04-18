


CREATE PROCEDURE [dbo].[USP_updatePassCode]
(
@UserId INT,
@passcode VARCHAR(1000)
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
	save transaction USP_updatePassCode
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
	SET _message = 'Error while update path.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END; 
START TRANSACTION; */
UPDATE MasterUser SET PassCode=@passcode WHERE UserId=@UserId
/*COMMIT;
SET _message = 'Successfully Update.'; 
SET _successCode = 200; 
SELECT _message Message,_successCode SuccessCode;
END$$
DELIMITER ;  */
lbexit:                          
   if @trancount = 0                           
    commit; 
	SELECT @passcode Passcode,@UserId UserId;
  end try                          
  /*begin catch 
	ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
  END CATCH*/
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_updatePassCode;            
                        
   raiserror ('USP_updatePassCode: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch

end
