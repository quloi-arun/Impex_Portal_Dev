

CREATE PROCEDURE [dbo].[USP_InsertRoletoUserMapping](
@_ProjectId int,
@_RoleId int  ,
@_UserId int,
@_CreatedBy int
)
AS
BEGIN
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
DECLARE @_RoletoUserMappingId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Menu.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END; */ --  select * from RoletoUserMapping
  IF EXISTS(SELECT ProjectId,UserId FROM RoletoUserMapping WHERE ProjectId=@_ProjectId and UserId=@_UserId and IsDeleted = 0) 
  BEGIN
	SET @_message = 'Role is Already Assigned to User of this Project '; 
    --SET _successCode = 400; 
    SELECT @_message Message
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
    save transaction USP_InsertRoletoUserMapping 
INSERT INTO RoletoUserMapping(ProjectId,RoleId ,UserId,CreatedBy,CreateDate,IsDeleted) 

VALUES (@_ProjectId, @_RoleId,@_UserId ,@_CreatedBy,GETDATE(),0);
SET @_RoletoUserMappingId = SCOPE_IDENTITY();	
--SET @_successCode = 200; 
 lbexit:                        
   if @trancount = 0                         
    commit; 
	SET @_message = 'Role Mapped To User Successfully'; 
	SET @_successCode = 200; 
	SELECT @_message Message,@_successCode SuccessCode,@_RoletoUserMappingId RoletoUserMappingId;
  end try                        
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertRoletoUserMapping;            
                        
   raiserror ('USP_InsertRoletoUserMapping: %d: %s', 16, 1, @error, @message) ;                        
   return;                                           
  end catch 
END 
END

