

CREATE PROCEDURE USP_InsertMapping_Menu_Function(
@_MenuId int ,
@_FunctionId int ,
@_CreatedBy int
)
AS
BEGIN
DECLARE @_message VARCHAR(200)= ''; 
DECLARE @_successCode INT = 0;
DECLARE @_Menu_FunctionId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Function.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END; */
 IF EXISTS(SELECT MenuId,FunctionId FROM L_Menu_Function WHERE MenuId=@_MenuId and FunctionId=@_FunctionId )
 BEGIN
	SET @_message = 'Allredy Exit this Mapping '; 
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
	save transaction USP_InsertMapping_Menu_Function
 INSERT INTO L_Menu_Function(MenuId,FunctionId,CreatedBy,CreateDate,IsDeleted,IsActive ) 
 VALUES (
@_MenuId,@_FunctionId,@_CreatedBy,
 getdate(),0,1
);
SET @_Menu_FunctionId = SCOPE_IDENTITY();

  lbexit:  
   if @trancount = 0   
    commit;
	    SET @_message = 'Mapping  Successfully'; 
		SET @_successCode = 200; 
		SELECT @_message Message,@_successCode SuccessCode, @_Menu_FunctionId  Menu_FunctionId;
  end try  
  /*begin catch
	ROLLBACK;
	SET @_message = 'There are some issue while adding Function.'; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;
  end catch*/
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertMapping_Menu_Function;            
                        
   raiserror ('USP_InsertMapping_Menu_Function: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
  END 
END
