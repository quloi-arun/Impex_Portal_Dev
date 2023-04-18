
CREATE PROCEDURE USP_InsertRoletoProjectMapping
@InsertRoletoProjectMapping InsertRoletoProjectMapping READONLY
AS
BEGIN
set nocount on;                        
  declare @trancount int;                        
  set @trancount = @@trancount;                        
  begin try                        
   if @trancount = 0                        
    begin transaction                        
   else                        
    save transaction USP_InsertRoletoProjectMapping
INSERT INTO RoletoProjectMapping
select RoleMasterId,PJM.ProjectId,MM.MenuId,SMM.SubMenuId,FM.FunctionId,IsChecked
from @InsertRoletoProjectMapping RPM
LEFT JOIN ProjectMaster PJM
on PJM.ProjectId = RPM.ProjectId
LEFT JOIN MenuMaster MM
ON MM.MenuId = RPM.MenuId
LEFT JOIN SubMenuMaster SMM
ON SMM.SubMenuId = RPM.SubMenuId
LEFT JOIN FunctionMaster FM
ON FM.FunctionId = RPM.FunctionId

lbexit:                        
   if @trancount = 0                         
    commit;
	SELECT 'Records Inserted Successfully' Message,200 SuccessCode;
  end try                        
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertRoletoProjectMapping;            
                        
   raiserror ('USP_InsertRoletoProjectMapping: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
	return;                      
  end catch
END
