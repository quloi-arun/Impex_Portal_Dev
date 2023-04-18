CREATE  PROCEDURE USP_GetMapping_Menu_FunctionDetailById(@_Menu_FunctionId int)
AS
BEGIN
SELECT
LMF.Menu_FunctionId, LMF.MenuId,MM.MenuName, LMF.FunctionId,FM.FunctionName
FROM L_Menu_Function LMF 
left join MenuMaster MM
on LMF.MenuId = MM.MenuId
Left Join FunctionMaster FM
on LMF.FunctionId=FM.FunctionId
WHERE LMF.IsActive = 1 and  LMF.IsDeleted=0 And Menu_FunctionId =@_Menu_FunctionId;
END
