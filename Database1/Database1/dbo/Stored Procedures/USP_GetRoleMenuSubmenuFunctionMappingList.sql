CREATE Procedure [dbo].[USP_GetRoleMenuSubmenuFunctionMappingList]    
(    
@ProjectId int,    
@RoleId int =Null    
)    
AS    
BEGIN    
IF(Coalesce(@RoleId,0) = 0)    
Begin    
-- select SRM.RMSF_Id, PM.ProjectId, PM.ProjectName,RM.RoleId,RM.RoleName, MM.MenuId,   
-- MM.MenuName,FM.FunctionId as FunctionId_Menu,0 IsAssigneMenuFunction ,     
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,  
--FMS.FunctionId as FunctionId_SubMenu,  
--FMS.FunctionName as SubMennuOperation,0 IsAssigneSubMenuFunction    
-- from ProjectMaster PM    
-- left join RoleMaster RM    
-- on PM.ProjectId=RM.ProjectId    
-- left join MenuMaster MM    
-- on pm.ProjectId=MM.ProjectId    
-- left join L_Menu_Function LMF    
-- on LMF.MenuId=MM.MenuId    
-- left join FunctionMaster FM    
-- on FM.FunctionId= LMF.FunctionId     
-- Right join SavedRoleMenuSubMenuFunctions SRM    
-- on SRM.ProjectId=PM.ProjectId and RM.RoleId=SRM.RoleId and  MM.MenuId=SRM.MenuId and SRM.FunctionId_Menu=FM.FunctionId    
-- left join  SubMenuMaster SM    
-- on SM.MenuId=MM.MenuId    
-- left join L_SubMenu_Function LSF    
-- on LSF.SubMenuId= SM.SubMenuId    
-- left join FunctionMaster FMS    
-- on FMS.FunctionId= LSF.FunctionId    
-- left join SavedRoleMenuSubMenuFunctions SRMS    
-- on    
-- SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  
--MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId 
select PM.ProjectId, PM.ProjectName,RM.RoleId,RM.RoleName, MM.MenuId,   
 MM.MenuName,FM.FunctionId as FunctionId_Menu,0 IsAssigneMenuFunction ,     
FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,  
FMS.FunctionId as FunctionId_SubMenu,  
FMS.FunctionName as SubMennuOperation,0 IsAssigneSubMenuFunction    
 from ProjectMaster PM    
 left join RoleMaster RM    
 on PM.ProjectId=RM.ProjectId    
 right join MenuMaster MM    
 on pm.ProjectId=MM.ProjectId    
 right join L_Menu_Function LMF    
 on LMF.MenuId=MM.MenuId    
 left join FunctionMaster FM    
 on FM.FunctionId= LMF.FunctionId     
   
 left join  SubMenuMaster SM    
 on SM.MenuId=MM.MenuId    
 left join L_SubMenu_Function LSF    
 on LSF.SubMenuId= SM.SubMenuId    
 left join FunctionMaster FMS    
 on FMS.FunctionId= LSF.FunctionId    
 left join SavedRoleMenuSubMenuFunctions SRMS    
 on    
 SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  
MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId  
where PM.ProjectId=@ProjectId
End    
Else    
Begin    
 select SRM.RMSF_Id, PM.ProjectId, PM.ProjectName,RM.RoleId,RM.RoleName, MM.MenuId,   
 MM.MenuName,FM.FunctionId as FunctionId_Menu,(Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,     
FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,  
FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction    
 from ProjectMaster PM    
 left join RoleMaster RM    
 on PM.ProjectId=RM.ProjectId    
 left join MenuMaster MM    
 on pm.ProjectId=MM.ProjectId    
 left join L_Menu_Function LMF    
 on LMF.MenuId=MM.MenuId    
 left join FunctionMaster FM    
 on FM.FunctionId= LMF.FunctionId     
 right join SavedRoleMenuSubMenuFunctions SRM    
 on SRM.ProjectId=PM.ProjectId and RM.RoleId=SRM.RoleId and    
MM.MenuId=SRM.MenuId and SRM.FunctionId_Menu=FM.FunctionId    
 left join  SubMenuMaster SM    
 on SM.MenuId=MM.MenuId    
 left join L_SubMenu_Function LSF    
 on LSF.SubMenuId= SM.SubMenuId    
 left join FunctionMaster FMS    
 on FMS.FunctionId= LSF.FunctionId    
 left join SavedRoleMenuSubMenuFunctions SRMS    
 on    
 SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  
MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId    
 where PM.ProjectId=@ProjectId and RM.RoleId =@RoleId    
  
End    
END 