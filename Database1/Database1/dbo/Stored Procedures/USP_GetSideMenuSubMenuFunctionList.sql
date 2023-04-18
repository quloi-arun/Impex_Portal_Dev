  
CREATE Procedure [dbo].[USP_GetSideMenuSubMenuFunctionList]  
(  
@LoginId varchar(90)   
)  
As  
BEGIN  
   
select Distinct MM.MenuId , MM.MenuName,MM.MenuIcon,MM.MenuOrder


--SELECT FM.FunctionId as FunctionId_Menu


--select Distinct MU.UserId,FirstName,LastName,LoginId,Password,MobileNo,Email,UserType,GlobalId, PM.ProjectId, PM.ProjectName,RM.RoleId,RM.RoleName,  
--FM.FunctionId as FunctionId_Menu, (Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,   
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,SM.SubMenuOrder,SM.SubMenuIcon, FMS.FunctionId as FunctionId_SubMenu,  
--FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
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
where MU.LoginId = @LoginId  ;

  select Distinct 
 MM.MenuId, FM.FunctionName as MenuPermission,(Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction 


--SELECT FM.FunctionId as FunctionId_Menu


--select Distinct MU.UserId,FirstName,LastName,LoginId,Password,MobileNo,Email,UserType,GlobalId, PM.ProjectId, PM.ProjectName,RM.RoleId,RM.RoleName,  
--FM.FunctionId as FunctionId_Menu, (Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,   
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,SM.SubMenuOrder,SM.SubMenuIcon, FMS.FunctionId as FunctionId_SubMenu,  
--FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
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
 right join FunctionMaster FM  
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
where MU.LoginId = @LoginId  ;


select Distinct 
SM.SubMenuId,MM.MenuId, SM.SubMenuName,SM.SubMenuOrder,SM.SubMenuIcon


--SELECT FM.FunctionId as FunctionId_Menu


--select Distinct MU.UserId,FirstName,LastName,LoginId,Password,MobileNo,Email,UserType,GlobalId, PM.ProjectId, PM.ProjectName,RM.RoleId,RM.RoleName,  
--FM.FunctionId as FunctionId_Menu, (Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,   
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,SM.SubMenuOrder,SM.SubMenuIcon, FMS.FunctionId as FunctionId_SubMenu,  
--FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
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
 right join  SubMenuMaster SM  
 on SM.MenuId=MM.MenuId  
 left join L_SubMenu_Function LSF  
 on LSF.SubMenuId= SM.SubMenuId  
 left join FunctionMaster FMS  
 on FMS.FunctionId= LSF.FunctionId  
 left join SavedRoleMenuSubMenuFunctions SRMS  
 on  
 SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId  
and SRMS.FunctionId_Menu = FMS.FunctionId and SRMS.FunctionId_SubMenu = FMS.FunctionId  
where MU.LoginId = @LoginId  ;


select Distinct 
SM.SubMenuId,FMS.FunctionName as SubMenuPermission,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction 


--SELECT FM.FunctionId as FunctionId_Menu


--select Distinct MU.UserId,FirstName,LastName,LoginId,Password,MobileNo,Email,UserType,GlobalId, PM.ProjectId, PM.ProjectName,RM.RoleId,RM.RoleName,  
--FM.FunctionId as FunctionId_Menu, (Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,   
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,SM.SubMenuOrder,SM.SubMenuIcon, FMS.FunctionId as FunctionId_SubMenu,  
--FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
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
 right join  SubMenuMaster SM  
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