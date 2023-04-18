  
CREATE Procedure [dbo].[USP_GetAssignRoleToMenuDetail]  
(  
@LoginId varchar(90)   
)  
As  
BEGIN  
  
select Distinct MM.MenuId, MM.MenuName,MM.MenuOrder,MM.MenuIcon
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
 on SRM.ProjectId=PM.ProjectId and RM.RoleId=SRM.RoleId and  MM.MenuId=SRM.MenuId and SRM.FunctionId_Menu=FM.FunctionId  
 left join  SubMenuMaster SM  
 on SM.MenuId=MM.MenuId  
 left join L_SubMenu_Function LSF  
 on LSF.SubMenuId= SM.SubMenuId  
 left join FunctionMaster FMS  
 on FMS.FunctionId= LSF.FunctionId  
 left join SavedRoleMenuSubMenuFunctions SRMS  
 on  
 SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId  
and SRMS.FunctionId_Menu = FMS.FunctionId and SRMS.FunctionId_SubMenu = FMS.FunctionId  
where MU.LoginId = @LoginId  
  
End  