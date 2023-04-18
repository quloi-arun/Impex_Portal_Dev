
CREATE PROCEDURE USP_InsertModuleMaster(
@_ModuleName varchar(200) ,
@_ModuleDescription varchar(200) ,
@_ProjectId int,
@_CreatedBy int)
AS
BEGIN
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
DECLARE @_ModuleId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Module.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END; */
  IF EXISTS(SELECT ModuleName,ProjectId FROM Modules WHERE ModuleName=@_ModuleName and ProjectId=@_ProjectId) 
  BEGIN
	SET @_message = 'Can not Bind Same Project to Same Module '; 
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
	save transaction USP_InsertModuleMaster
INSERT INTO Modules(ModuleName,
ModuleDescription ,
ProjectId  ,
CreatedBy,IsActive,CreateDate, IsDeleted ) 

VALUES (@_ModuleName,
@_ModuleDescription ,
@_ProjectId  ,
@_CreatedBy,1,GETDATE(),0
);
SET @_ModuleId = SCOPE_IDENTITY();
  
  lbexit:  
   if @trancount = 0   
    commit;
	SET @_message = 'Module added Successfully'; 
	SET @_successCode = 200; 
	SELECT @_message Message,@_successCode SuccessCode,@_ModuleId ModuleId;
  end try  
  /*begin catch
	ROLLBACK;
	SET @_message = 'There are some issue while adding Module.'; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;
  END Catch*/
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertModuleMaster;            
                        
   raiserror ('USP_InsertModuleMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
END
