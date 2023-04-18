
CREATE PROCEDURE USP_DeleteMapping_Menu_Function
(
@_Menu_FunctionId int
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
    save transaction USP_DeleteMapping_Menu_Function;                          
	UPDATE L_Menu_Function SET IsDeleted=1,DeleteDate=getdate(),DeletedBy=@_UserId  WHERE Menu_FunctionId =@_Menu_FunctionId;
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
    rollback transaction USP_DeleteMapping_Menu_Function;                          
                          
   raiserror ('USP_DeleteMapping_Menu_Function: %d: %s', 16, 1, @error, @message) ;                          
   return;               
  end catch 

END