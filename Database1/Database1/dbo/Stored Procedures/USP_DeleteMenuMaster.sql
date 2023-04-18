

CREATE PROCEDURE USP_DeleteMenuMaster
( @_MenuId int , @_UserId int
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
    save transaction USP_DeleteMenuMaster;
	UPDATE MenuMaster SET IsDeleted=1,DeleteDate=GETDATE(),DeletedBy=@_UserId  WHERE MenuId =@_MenuId;
	lbexit:                          
   if @trancount = 0                           
    commit;
	SELECT 'Records Deleted Successfully' Message,200 SuccessCode;
  end try                          
  begin catch
   declare @error int, @message varchar(4000), @xstate int;                          
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                          
   if @xstate = -1                          
    rollback;                          
   if @xstate = 1 and @trancount = 0                          
    rollback                          
   if @xstate = 1 and @trancount > 0                          
    rollback transaction USP_DeleteMenuMaster;                          
                          
   raiserror ('USP_DeleteMenuMaster: %d: %s', 16, 1, @error, @message) ;                          
   return;               
  end catch 

END
