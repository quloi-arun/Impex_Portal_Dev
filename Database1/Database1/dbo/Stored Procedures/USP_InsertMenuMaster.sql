
CREATE PROCEDURE USP_InsertMenuMaster(
@_MenuName varchar(200) ,
@_MenuDescription varchar(200) ,
@_MenuOrder varchar(100) ,
@_MenuIcon varchar(100) ,
@_ProjectId int,
@_CreatedBy int
)
AS
BEGIN
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
DECLARE @_MenuId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Menu.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END; */
  IF EXISTS(SELECT MenuName,ProjectId FROM MenuMaster WHERE MenuName=@_MenuName and ProjectId=@_ProjectId)
  BEGIN
	SET @_message = 'Can not Bind Same Project and Same Module to Menu '; 
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
	save transaction USP_InsertMenuMaster
INSERT INTO MenuMaster(MenuName
,MenuDescription ,MenuOrder,MenuIcon,ProjectId,CreatedBy,IsActive,CreateDate,IsDeleted ) 

VALUES (@_MenuName,
@_MenuDescription ,@_MenuOrder,@_MenuIcon ,@_ProjectId,
@_CreatedBy,
1
,GetDate(),0
);
SET @_MenuId = SCOPE_IDENTITY();

lbexit:  
   if @trancount = 0   
    commit;
	SET @_message = 'Menu added Successfully'; 
	SET @_successCode = 200; 
	SELECT @_message Message,@_successCode SuccessCode,@_MenuId MenuId;
  end try  
  /*begin catch
	ROLLBACK;
	SET @_message = 'There are some issue while adding Menu.'; 
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
    rollback transaction USP_InsertMenuMaster;            
                        
   raiserror ('USP_InsertMenuMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch

END

END
