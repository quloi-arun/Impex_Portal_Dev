
CREATE  PROCEDURE USP_GetMappingMenuFunctionDetail
AS
BEGIN
SELECT
LMF.Menu_FunctionId,LMF.MenuId,MM.MenuName, LMF.FunctionId,FM.FunctionName
FROM L_Menu_Function LMF 
left join MenuMaster MM
on LMF.MenuId = MM.MenuId
Left Join FunctionMaster FM
on LMF.FunctionId=FM.FunctionId
WHERE LMF.IsActive = 1 and  LMF.IsDeleted=0;
END
