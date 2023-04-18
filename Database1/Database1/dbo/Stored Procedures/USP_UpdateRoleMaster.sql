
CREATE PROCEDURE USP_UpdateRoleMaster(
@_RoleID Int,
@_RoleName varchar(255),
@_RoleDescription varchar(255),
@_ProjectId int,
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
END;
START TRANSACTION;*/
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction
	else
	save transaction USP_UpdateRoleMaster
UPDATE RoleMaster set 
RoleName=@_RoleName,
RoleDescription =@_RoleDescription,
ProjectId=@_ProjectId,
IsActive=@_IsActive ,
Modified_By=@_Modified_By,
ModifyDate= GETDATE()
WHERE RoleId = @_RoleId;	
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
    rollback transaction USP_UpdateRoleMaster;            
                        
   raiserror ('USP_UpdateRoleMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
