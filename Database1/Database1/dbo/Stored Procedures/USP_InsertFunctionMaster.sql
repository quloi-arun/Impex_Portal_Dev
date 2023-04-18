

CREATE PROCEDURE USP_InsertFunctionMaster(
@_FunctionName varchar(200),
@_CreatedBy int
)
AS
BEGIN
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
DECLARE @_FunctionId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Function.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END; */
  IF EXISTS(SELECT FunctionName FROM FunctionMaster WHERE FunctionName=@_FunctionName )
  BEGIN
	SET @_message = 'Function Name Alredy Exist '; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;
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
	save transaction USP_InsertFunctionMaster
INSERT INTO FunctionMaster(FunctionName,
CreatedBy,IsActive,CreateDate,IsDeleted ) 

VALUES (@_FunctionName,
@_CreatedBy,
1
,GETDATE(),0
);
SET @_FunctionId = SCOPE_IDENTITY();


lbexit:  
   if @trancount = 0   
    commit;
	SET @_message = 'Function added Successfully'; 
	SET @_successCode = 200; 
	SELECT @_message Message,@_successCode SuccessCode, @_FunctionId FunctionId;
  end try  
begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertFunctionMaster;            
                        
   raiserror ('USP_InsertFunctionMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
/*COMMIT;

SET _message = 'Function added Successfully'; 
SET _successCode = 200; 
SELECT _message Message,_successCode SuccessCode, _FunctionId FunctionId;
*/
END
END
