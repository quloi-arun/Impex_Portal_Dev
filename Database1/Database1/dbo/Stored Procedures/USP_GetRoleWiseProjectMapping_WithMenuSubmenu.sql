


CREATE Procedure [dbo].[USP_GetRoleWiseProjectMapping_WithMenuSubmenu]
AS
Begin
select 
ProjectName,
MMR.MenuName
,Menu_FunctionName = coalesce(FM_MM.FunctionName,'')
,SubMenuName
,SubMenu_FunctionName = coalesce(FM_SM.FunctionName,'')
from ProjectMaster PMR
JOIN MenuMaster MMR
On MMR.ProjectId = PMR.ProjectId
LEFT JOIN L_Menu_Function LMF
on LMF.MenuId = MMR.MenuId
LEFT JOIN FunctionMaster FM_MM
On FM_MM.FunctionId = LMF.FunctionId
LEFT JOIN SubMenuMaster SMM
ON SMM.MenuId = MMR.MenuId
LEFT JOIN L_SubMenu_Function LSMF
on LSMF.SubMenuId = SMM.SubMenuId
LEFT JOIN FunctionMaster FM_SM
On FM_SM.FunctionId = LSMF.FunctionId
end
