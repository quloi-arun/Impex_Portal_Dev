
CREATE PROCEDURE [dbo].[USP_InsertRoleMaster](
@_RoleName varchar(200),
@_RoleDescription varchar(200),
@_ProjectId int,
@_ModuleId int=0,
@_CreatedBy int
)
AS
Begin
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
DECLARE @_RoleId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Role.'; 
    SET _successCode = 400;
SELECT _message Message, _successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END; */
  IF EXISTS(SELECT RoleName,ProjectId FROM RoleMaster WHERE RoleName=@_RoleName and ProjectId=@_ProjectId) 
  BEGIN
	SET @_message = 'Can not Bind Same Project and Same Module to Role '; 
    SET @_successCode = 400;
	SELECT @_message Message, @_successCode SuccessCode;
  END
ELSE
BEGIN
SET NOCOUNT ON;
	DECLARE @trancount INT;
	SET @trancount = @@trancount;
	BEGIN TRY
		IF @trancount = 0
			BEGIN TRANSACTION
			else                        
			save transaction USP_InsertRoleMaster
INSERT INTO RoleMaster(RoleName,
RoleDescription ,
ProjectId,
ModuleId,
CreatedBy,IsActive,CreateDate,IsDeleted ) 

VALUES (@_RoleName,@_RoleDescription ,@_ProjectId,@_ModuleId,@_CreatedBy,1,GETDATE(),0);
SET @_RoleId = SCOPE_IDENTITY();
lbexit:
		IF @trancount = 0
		COMMIT;
		SET @_message = 'Role added Successfully'; 
		SET @_successCode = 200;
		SELECT @_message Message, @_successCode SuccessCode, @_RoleId RoleId;
	
	END TRY
	/*BEGIN CATCH
	ROLLBACK;
	SET @_message = 'There are some issue while adding Role.'; 
    SET @_successCode = 400;
	SELECT @_message Message, @_successCode SuccessCode;
	END CATCH*/                       
   begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertRoleMaster;            
                        
   raiserror ('USP_InsertRoleMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
   end catch  

END
END
