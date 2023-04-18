
CREATE PROCEDURE USP_UpdateMapping_Menu_Function(
@_Menu_FunctionId int,
@_MenuId int,
@_FunctionId int,
@_IsActive tinyint,
@_Modified_By int
)
AS
BEGIN
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END; */
IF EXISTS(SELECT MenuId,FunctionId,Menu_FunctionId FROM L_Menu_Function 
WHERE MenuId=@_MenuId and FunctionId=@_FunctionId and Menu_FunctionId=@_Menu_FunctionId )
BEGIN
	 SELECT 'Allredy Exit this Mapping.' Message,400 SuccessCode;
END
ELSE
BEGIN
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction
	else
	save transaction USP_UpdateMapping_Menu_Function
UPDATE L_Menu_Function set 
MenuId=@_MenuId ,
FunctionId=@_FunctionId,
IsActive=@_IsActive,
Modified_By=@_Modified_By,
ModifyDate= GETDATE()
WHERE Menu_FunctionId = @_Menu_FunctionId;	
lbexit:                          
   if @trancount = 0                           
    commit;         
	SELECT 'Records Updated Successfully' Message,200 SuccessCode;
  end try                          
  /*begin catch 
	ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
  end catch*/
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_UpdateMapping_Menu_Function;            
                        
   raiserror ('USP_UpdateMapping_Menu_Function: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
END
