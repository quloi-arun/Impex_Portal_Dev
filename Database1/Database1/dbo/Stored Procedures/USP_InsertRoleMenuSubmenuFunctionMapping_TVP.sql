

CREATE Procedure USP_InsertRoleMenuSubmenuFunctionMapping_TVP
@USP_InsertRoleMenuSubmenuFunctionMapping1 USP_InsertRoleMenuSubmenuFunctionMapping1 ReadOnly
AS
BEGIN
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;
  begin try                          
   if @trancount = 0 
    begin transaction
declare @count int,
@noofrecords int =0
,@ROWNo INT = 0
set @count = (select count(*) from @USP_InsertRoleMenuSubmenuFunctionMapping1)
while(@count>@noofrecords)
begin
SET @noofrecords = @noofrecords+1	

IF((select coalesce(SubMenuId,0) from @USP_InsertRoleMenuSubmenuFunctionMapping1 IMM WHERE IMM.SRNO = @noofrecords ) = 0)
BEGIN
If exists(Select top 1 SRMS.ProjectId,SRMS.RoleId,SRMS.MenuId,SRMS.RMSF_Id,SRMS.FunctionId_Menu from SavedRoleMenu SRMS
				 Join @USP_InsertRoleMenuSubmenuFunctionMapping1 IRMSFM
				 On IRMSFM.ProjectId = SRMS.ProjectId and IRMSFM.RoleId = SRMS.RoleId and IRMSFM.MenuId =SRMS.MenuId
				 and IRMSFM.FunctionId_Menu=SRMS.FunctionId_Menu
				 WHERE IRMSFM.SRNO = @noofrecords)
			/*

			Create Type USP_InsertRoleMenuSubmenuFunctionMapping AS Table
			(
			ProjectID int,RoleId int,MenuId int,FunctionId_Menu int,IsAssigneMenuFunction Bit,
			SubMenuId int,FunctionId_SubMenu int,IsAssigneSubMenuFunction Bit,Createdby int
			)
	        where SRMS.ProjectId = IRMSFM.ProjectID and SRMS.RoleId = @USP_InsertRoleMenuSubmenuFunctionMapping.RoleId
			and SRMS.MenuId=@USP_InsertRoleMenuSubmenuFunctionMapping.MenuId and FunctionId_Menu = @USP_InsertRoleMenuSubmenuFunctionMapping.FunctionId_Menu*/
BEGIN
  declare @trancount_Update int;                          
  set @trancount_Update = @@trancount;                       
    begin transaction
		Update	SavedRoleMenu 
		set IsAssigneMenuFunction = IRSM.IsAssigneMenuFunction
		from @USP_InsertRoleMenuSubmenuFunctionMapping1 IRSM
			where SavedRoleMenu.ProjectId = IRSM.ProjectID and SavedRoleMenu.RoleId = IRSM.RoleId
			and SavedRoleMenu.MenuId=IRSM.MenuId and SavedRoleMenu.FunctionId_Menu = IRSM.FunctionId_Menu 
			AND IRSM.SRNO = @noofrecords
	commit transaction
	select 'For update menu' + cast(@trancount_Update as Varchar(90))

END
ELSE
BEGIN

  declare @trancount_Insert int;                          
  set @trancount_Insert = @@trancount;                       
    begin transaction
Insert into SavedRoleMenu (ProjectId,RoleId,MenuId,FunctionId_Menu,IsAssigneMenuFunction,CreatedBY)	
select ProjectID,RoleId,MenuId,FunctionId_Menu,IsAssigneMenuFunction,Createdby from @USP_InsertRoleMenuSubmenuFunctionMapping1 IRSM
WHERE IRSM.SRNO = @noofrecords
	commit transaction
	select 'For insert menu' + cast(@trancount_Insert as Varchar(90))

--SELECT 'Records Inserted Successfully' Message,200 SuccessCode;

END
END


ELSE
BEGIN
If exists(Select SRMS.ProjectId,SRMS.RoleId,SRMS.MenuId,SRMS.RMSF_Id,SRMS.FunctionId_SubMenu from SavedRoleMenu SRMS
			JOIN @USP_InsertRoleMenuSubmenuFunctionMapping1 IRMSFM
			On IRMSFM.ProjectID = SRMS.ProjectId and IRMSFM.RoleId = SRMS.RoleId and IRMSFM.MenuId = SRMS.RoleId
			and IRMSFM.SubMenuId = SRMS.SubMenuId and IRMSFM.FunctionId_Menu = SRMS.FunctionId_Menu
			WHERE IRMSFM.SRNO = @noofrecords)
			/*where SRMS.ProjectId = @USP_InsertRoleMenuSubmenuFunctionMapping.ProjectID and SRMS.RoleId = @USP_InsertRoleMenuSubmenuFunctionMapping.RoleId
			and SRMS.MenuId= @USP_InsertRoleMenuSubmenuFunctionMapping.MenuId and
			SubMenuId=@USP_InsertRoleMenuSubmenuFunctionMapping.SubMenuId and
			FunctionId_SubMenu = @USP_InsertRoleMenuSubmenuFunctionMapping.FunctionId_SubMenu )*/
BEGIN
  declare @trancount_Update_Sub int;                          
  set @trancount_Update_Sub = @@trancount;                       
    begin transaction
		Update	SavedRoleMenu
		set IsAssigneSubMenuFunction = IRSFM.IsAssigneSubMenuFunction
			from @USP_InsertRoleMenuSubmenuFunctionMapping1 IRSFM
			where SavedRoleMenu.ProjectId = IRSFM.ProjectID and SavedRoleMenu.RoleId = IRSFM.RoleId
			and SavedRoleMenu.MenuId=IRSFM.MenuId and SavedRoleMenu.SubMenuId=IRSFM.SubMenuId and SavedRoleMenu.FunctionId_SubMenu = IRSFM.FunctionId_SubMenu
				AND IRSFM.SRNO = @noofrecords
commit transaction
		select 'For Update SubMenu' + cast(@trancount_Update_Sub as Varchar(90))

END
ELSE
BEGIN
  declare @trancount_Insert_SUB int;                          
  set @trancount_Insert_SUB = @@trancount;                       
    begin transaction
	Insert into SavedRoleMenu (ProjectId,RoleId,MenuId,SubMenuId,FunctionId_SubMenu,IsAssigneSubMenuFunction,CreatedBY)	
	select ProjectID,RoleId,MenuId,SubMenuId,Functionid_Submenu,IsAssigneSubMenuFunction,Createdby from @USP_InsertRoleMenuSubmenuFunctionMapping1 IRSM
	Where IRSM.SRNO = @noofrecords
	commit transaction
		select 'For insert SubMenu' + cast(@trancount_Insert_SUB as Varchar(90))


END
END
END
lbexit:                          
   if @trancount = 0                           
    commit;
	/*declare @Message Varchar(90) = case when @trancount_Update = 1 then 'Update for Menu'
										when @trancount_Insert = 1 then 'Insert for Menu'
										when @trancount_Update_Sub = 1 then 'Insert for SubMenu'
										when @trancount_Insert_Sub = 1 then 'Update for SubMenu'
									End
	Select @Message */
  end try                          
  begin catch 
	ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
  end catch
  
END


