
CREATE PROCEDURE USP_DeleteUserMaster(
 @_MuserId int, @_userId int
)
AS
BEGIN
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
  
  BEGIN
    ROLLBACK;
    SELECT 'There are some issue while deleting records.' Message,400 SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END;
  START TRANSACTION; */
  set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction 
	else
	save transaction USP_DeleteUserMaster
	UPDATE MasterUser SET IsDeleted=1,DeletedDate=getdate(),DeletedBy=@_userId WHERE UserId =@_MuserId;
	lbexit:                          
   if @trancount = 0                           
    commit;
	SELECT 'Records Deleted Successfully' Message,200 SuccessCode;
  end try                          
  /*begin catch 
	ROLLBACK;
    SELECT 'There are some issue while deleting records.' Message,400 SuccessCode;
  end catch*/
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_DeleteUserMaster;            
                        
   raiserror ('USP_DeleteUserMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
