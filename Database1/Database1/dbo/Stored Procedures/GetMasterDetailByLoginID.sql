
Create Procedure GetMasterDetailByLoginID
(
@LoginId int
)
As
BEGIN
select distinct MU.UserId,FirstName,LastName,LoginId,Password,MobileNo,Email,UserType,GlobalId, PM.ProjectId, PM.ProjectName,RM.RoleId,RM.RoleName, MM.MenuId, MM.MenuName,FM.FunctionId as FunctionId_Menu,coalesce(SRM.IsAssigneMenuFunction,0) as IsAssigneMenuFunction , 
FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,coalesce(SRMS.IsAssigneSubMenuFunction,0) as IsAssigneSubMenuFunction
 from ProjectMaster PM
 left join RoleMaster RM
 on PM.ProjectId=RM.ProjectId
LEFT JOIN RoletoUserMapping RUM
On RUM.RoleID = RM.RoleID
LEFT JOIN MasterUser MU
On MU.userid = RUM.UserID
 left join MenuMaster MM
 on RUM.ProjectId=MM.ProjectId
 left join L_Menu_Function LMF
 on LMF.MenuId=MM.MenuId
 left join FunctionMaster FM
 on FM.FunctionId= LMF.FunctionId 
 left join SavedRoleMenuSubMenuFunctions SRM
 on SRM.ProjectId=PM.ProjectId and RM.RoleId=SRM.RoleId and  MM.MenuId=SRM.MenuId
 left join  SubMenuMaster SM
 on SM.MenuId=MM.MenuId
 left join L_SubMenu_Function LSF
 on LSF.SubMenuId= SM.SubMenuId
 left join FunctionMaster FMS
 on FMS.FunctionId= LSF.FunctionId
 left join SavedRoleMenuSubMenuFunctions SRMS
 on
 SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId
where MU.LoginId = @LoginId
End