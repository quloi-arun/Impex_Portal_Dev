

-- exec USP_InsertRoleMenuSubmenuFunctionMapping 1,1,1,1,1,1,1,1,1
-- exec USP_InsertRoleMenuSubmenuFunctionMapping 1,1,2,null,0,1,1,1,1
-- select * from SavedRoleMenuSubMenuFunctions
-- select * from SubMenuMaster

CREATE Procedure [dbo].[USP_InsertRoleMenuSubmenuFunctionMapping]
(
@ProjectID int,@RoleId int,@MenuId int,@FunctionId_Menu int,@IsAssigneMenuFunction Bit,
@SubMenuId int = null,@FunctionId_SubMenu int = Null,@IsAssigneSubMenuFunction Bit = Null,@Createdby int
)
AS
BEGIN
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction
IF( coalesce(@SubMenuId,0) = 0)
BEGIN
			If exists(Select SRMS.ProjectId,SRMS.RoleId,SRMS.MenuId,SRMS.RMSF_Id,FunctionId_Menu from SavedRoleMenuSubMenuFunctions SRMS
			where SRMS.ProjectId = @ProjectID and SRMS.RoleId = @RoleId
			and SRMS.MenuId=@MenuId and FunctionId_Menu = @FunctionId_Menu)
BEGIN	
		if exists(Select top 1 MenuId  from SubMenuMaster where MenuId=@MenuId)
		BEGIN
		Select 'You Cannot Assign Function to menu because this menu has already Assigned Submenu' as Message,400 SuccessCode
		END
		else
		begin
		Update	SavedRoleMenuSubMenuFunctions 
		set IsAssigneMenuFunction = @IsAssigneMenuFunction
		where ProjectId = @ProjectID and RoleId = @RoleId
		and MenuId=@MenuId and FunctionId_Menu = @FunctionId_Menu 
		end
END
ELSE
BEGIN
	if exists(Select top 1 MenuId  from SubMenuMaster where MenuId=@MenuId)
		BEGIN
		Select 'You Cannot Assign Function to menu because this menu has already Assigned Submenu' as Message,400 SuccessCode
		END
		else
		begin
		Insert into SavedRoleMenuSubMenuFunctions (ProjectId,RoleId,MenuId,FunctionId_Menu,IsAssigneMenuFunction,CreatedBY)	
		values(@ProjectID,@RoleId,@MenuId,@FunctionId_Menu,@IsAssigneMenuFunction,@Createdby)
		end
END
END
ELSE
BEGIN
If exists(Select SRMS.ProjectId,SRMS.RoleId,SRMS.MenuId,SRMS.RMSF_Id,FunctionId_SubMenu from SavedRoleMenuSubMenuFunctions SRMS
			where SRMS.ProjectId = @ProjectID and SRMS.RoleId = @RoleId
			and SRMS.MenuId=@MenuId and SubMenuId=@SubMenuId and FunctionId_SubMenu = @FunctionId_SubMenu )
BEGIN
			if exists(Select top 1 MenuId  from SubMenuMaster where MenuId=@MenuId)
		BEGIN
		Select 'You Cannot Assign Function to menu because this menu has already Assigned Submenu' as Message,400 SuccessCode
		END
		else
		begin
		Update	SavedRoleMenuSubMenuFunctions
		set IsAssigneSubMenuFunction = @IsAssigneSubMenuFunction
		where ProjectId = @ProjectID and RoleId = @RoleId
			and MenuId=@MenuId and SubMenuId=@SubMenuId and FunctionId_SubMenu = @FunctionId_SubMenu
		end
END
ELSE
BEGIN
		if exists(Select top 1 MenuId  from SubMenuMaster where MenuId=@MenuId)
		BEGIN
		Select 'You Cannot Assign Function to menu because this menu has already Assigned Submenu' as Message,400 SuccessCode
		END
		else
		begin
		Insert into SavedRoleMenuSubMenuFunctions (ProjectId,RoleId,MenuId,SubMenuId,FunctionId_SubMenu,IsAssigneSubMenuFunction,CreatedBY)	
	values(@ProjectID,@RoleId,@MenuId,@SubMenuId,@Functionid_Submenu,@IsAssigneSubMenuFunction,@Createdby)
		end
END
END

lbexit:                
   if @trancount = 0                           
    commit;
	if not exists(Select top 1 MenuId  from SubMenuMaster where MenuId=@MenuId)
	begin
			    SELECT 'Records Insert/Update Successfully' Message,200 SuccessCode;
	end
  end try
  begin catch 
	ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
  end catch
  
END



