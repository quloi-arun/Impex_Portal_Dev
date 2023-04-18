

CREATE PROCEDURE USP_GetMapping_SubMenu_FunctionDetailById(@_SubMenu_FunctionId int)
AS
BEGIN
SELECT LMF.SubMenu_FunctionId,LMF.SubMenuId,SM.SubMenuName, LMF.FunctionId,FM.FunctionName,
MM.MenuId,MM.MenuName,MM.ProjectId,PM.ProjectName
FROM L_SubMenu_Function LMF 
left join SubMenuMaster SM
on LMF.SubMenuId = SM.SubMenuId
Left Join FunctionMaster FM
on LMF.FunctionId=FM.FunctionId
Inner Join MenuMaster MM
on  MM.MenuId=SM.MenuId
Inner Join ProjectMaster PM
On PM.ProjectId =MM.ProjectId

WHERE LMF.IsActive = 1 and  LMF.IsDeleted=0 And LMF.SubMenu_FunctionId =@_SubMenu_FunctionId;
END
