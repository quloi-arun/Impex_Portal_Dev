

CREATE PROCEDURE USP_GetModuleMasterDetail
AS
BEGIN
SELECT
ModuleId,ProjectId,ModuleName,ModuleDescription,
CreateDate,ModifyDate
FROM Modules 
WHERE IsActive = 1 and IsDeleted=0;
END
