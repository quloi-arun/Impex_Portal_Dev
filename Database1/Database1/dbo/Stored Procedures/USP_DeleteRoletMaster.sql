
CREATE PROCEDURE USP_DeleteRoletMaster(
@_RoleId int
,@_UserId int
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
    save transaction USP_DeleteRoletMaster
	UPDATE RoleMaster SET IsDeleted=1,DeletedDate=getdate(),DeletedBy=@_userId WHERE RoleId =@_RoleId;
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
    rollback transaction USP_DeleteRoletMaster;            
                        
   raiserror ('USP_DeleteRoletMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch

END
