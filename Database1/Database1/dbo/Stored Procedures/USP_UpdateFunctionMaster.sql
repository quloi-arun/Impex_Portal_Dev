

CREATE PROCEDURE USP_UpdateFunctionMaster(
@_FunctionId int,
@_FunctionName varchar(255),
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
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction
	else
	save transaction USP_UpdateFunctionMaster
UPDATE FunctionMaster set 
FunctionName=@_FunctionName ,
IsActive=@_IsActive,
Modified_By=@_Modified_By,
ModifyDate= getdate()
WHERE FunctionId = @_FunctionId;	                
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
    rollback transaction USP_UpdateFunctionMaster;            
                        
   raiserror ('USP_UpdateFunctionMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
