	

CREATE PROCEDURE USP_UpdateRoletoUserMapping(
@_RoletoUserMappingId int,
@_ProjectId int,
@_RoleId int,
@_UserId int,
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
START TRANSACTION; */
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction
	else
	save transaction USP_UpdateRoletoUserMapping
UPDATE RoletoUserMapping set 
ProjectId=@_ProjectId ,
RoleId=@_RoleId ,
UserId =@_UserId ,
Modified_By=@_Modified_By,
ModifyDate= GETDATE()
WHERE RoletoUserMappingId = @_RoletoUserMappingId;	
lbexit:                          
   if @trancount = 0                           
    commit; 
	SELECT 'Records Updated Successfully' Message,200 SuccessCode;
  end try                          
 /* begin catch
	ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
  END CATCH*/
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_UpdateRoletoUserMapping;            
                        
   raiserror ('USP_UpdateRoletoUserMapping: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
