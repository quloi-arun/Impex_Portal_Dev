

CREATE PROCEDURE USP_GetModuleMasterDetailBYId(@_ModuleId int)
AS
BEGIN
SELECT
ModuleId,ProjectId,ModuleName,ModuleDescription,
CreateDate,ModifyDate
FROM Modules 
WHERE IsActive = 1 and IsDeleted=0 and ModuleId =@_ModuleId   ;
END
