  
CREATE Procedure [dbo].[USP_GetRoleWiseMenuSubmenuFunctionMappingList]  
(  
@ProjectId int,  
@RoleId int =Null  
)  
AS  
BEGIN  
IF(Coalesce(@RoleId,0) = 0)  
Begin  
 SELECT DISTINCT SRM.RMSF_Id, PM.ProjectId, PM.ProjectName  
   
 --RM.RoleId,RM.RoleName, MM.MenuId, MM.MenuName,FM.FunctionId as FunctionId_Menu,0 IsAssigneMenuFunction ,   
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,0 as IsAssigneSubMenuFunction  
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
 on SRM.ProjectId=PM.ProjectId and RM.RoleId=SRM.RoleId and  MM.MenuId=SRM.MenuId and SRM.FunctionId_Menu=FM.FunctionId  
 left join  SubMenuMaster SM  
 on SM.MenuId=MM.MenuId  
 left join L_SubMenu_Function LSF  
 on LSF.SubMenuId= SM.SubMenuId  
 left join FunctionMaster FMS  
 on FMS.FunctionId= LSF.FunctionId  
 left join SavedRoleMenuSubMenuFunctions SRMS  
 on  
 SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId;  
  
select   
  DISTINCT PM.ProjectId, RM.RoleId,RM.RoleName    
 --MM.MenuId, MM.MenuName,FM.FunctionId as FunctionId_Menu,0 IsAssigneMenuFunction ,   
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,0 as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
  
  
select   
  DISTINCT   
 RM.RoleId,MM.MenuId, MM.MenuName  
 --,FM.FunctionId as FunctionId_Menu,0 IsAssigneMenuFunction,   
    --FM.FunctionName as MenuPermission  
--SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,0 as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
 SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId;  
  
select   
  DISTINCT   
 MM.MenuId,MM.MenuName,FM.FunctionId as FunctionId_Menu,  0 IsAssigneMenuFunction,   
    FM.FunctionName as MenuPermission  
--SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,0 as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
 --SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId  
SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId  
 where PM.ProjectId=@ProjectId   
  
  
  
  
select   
  DISTINCT   
 MM.MenuId,MM.MenuName,SM.SubMenuId, SM.SubMenuName  
 --FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,0 as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
   
  
select   
  DISTINCT   
 SM.SubMenuId, SM.SubMenuName,  
FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMenuPermission,0 as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
 right join FunctionMaster FMS  
 on FMS.FunctionId= LSF.FunctionId  
 left join SavedRoleMenuSubMenuFunctions SRMS  
 on  
 --SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId  
SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId  
 where PM.ProjectId=@ProjectId   
END  
  
  
  
Else  
Begin  
 SELECT DISTINCT SRM.RMSF_Id, PM.ProjectId, PM.ProjectName  
   
 --RM.RoleId,RM.RoleName, MM.MenuId, MM.MenuName,FM.FunctionId as FunctionId_Menu,(Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,   
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
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
 where PM.ProjectId=@ProjectId and RM.RoleId =@RoleId;  
  
  
select  
   
DISTINCT  PM.ProjectId,RM.RoleId,RM.RoleName  
--MM.MenuId, MM.MenuName,FM.FunctionId as FunctionId_Menu,(Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,   
--FM.FunctionName as MenuOperation, SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
 where PM.ProjectId=@ProjectId and RM.RoleId =@RoleId  
  
  
select  
   
DISTINCT   
RM.RoleId,MM.MenuId, MM.MenuName  
--,FM.FunctionId as FunctionId_Menu,  
--(Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,   
--FM.FunctionName as Menu  
--SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
 where PM.ProjectId=@ProjectId and RM.RoleId =@RoleId;  
  
select  
   
DISTINCT   
MM.MenuId,MM.MenuName,FM.FunctionId as FunctionId_Menu,  
(Coalesce(SRM.IsAssigneMenuFunction,0))as IsAssigneMenuFunction ,   
FM.FunctionName as MenuPermission  
--SM.SubMenuId, SM.SubMenuName,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
 where PM.ProjectId=@ProjectId and RM.RoleId =@RoleId  
  
  
select  
   
DISTINCT   
MM.MenuId,MM.MenuName,SM.SubMenuId, SM.SubMenuName  
--,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMennuOperation,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
 where PM.ProjectId=@ProjectId and RM.RoleId =@RoleId  
  
  
select  
   
DISTINCT   
SM.SubMenuId, SM.SubMenuName  
,FMS.FunctionId as FunctionId_SubMenu,FMS.FunctionName as SubMenuPermission,(Coalesce(SRM.IsAssigneSubMenuFunction,0))as IsAssigneSubMenuFunction  
 from ProjectMaster PM  
 left join RoleMaster RM  
 on PM.ProjectId=RM.ProjectId  
 left join MenuMaster MM  
 on pm.ProjectId=MM.ProjectId  
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
 right join FunctionMaster FMS  
 on FMS.FunctionId= LSF.FunctionId  
 left join SavedRoleMenuSubMenuFunctions SRMS  
 on  
 SRMS.ProjectId=PM.ProjectId and RM.RoleId=SRMS.RoleId and  MM.MenuId=SRMS.MenuId and SM.SubMenuId=SRMS.SubMenuId  
 where PM.ProjectId=@ProjectId and RM.RoleId =@RoleId  
End  
END  