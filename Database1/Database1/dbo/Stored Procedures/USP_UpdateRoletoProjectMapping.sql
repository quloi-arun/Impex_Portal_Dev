CREATE PROCEDURE USP_UpdateRoletoProjectMapping
@UpdateRoletoProjectMapping UpdateRoletoProjectMapping READONLY
AS
BEGIN
  set nocount on;                        
  declare @trancount int;                        
  set @trancount = @@trancount;                        
  begin try                        
   if @trancount = 0                        
    begin transaction                        
   else                        
    save transaction USP_UpdateRoletoProjectMapping  
 Update RoletoProjectMapping
 set --RoletoProjectMappingId = UM.RoletoProjectMappingId
 IsChecked = UM.IsChecked
 from @UpdateRoletoProjectMapping UM
 where RoletoProjectMapping.RoletoProjectMappingId = UM.RoletoProjectMappingId
 --where UM.RoletoProjectMappingId = RoletoProjectMappingId
 lbexit:                        
   if @trancount = 0                         
    commit;                        
  end try                        
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_UpdateRoletoProjectMapping;            
                        
   raiserror ('USP_UpdateRoletoProjectMapping: %d: %s', 16, 1, @error, @message) ;                        
   return;                                         
  end catch  
END
