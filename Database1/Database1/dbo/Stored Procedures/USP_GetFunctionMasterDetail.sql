

CREATE  PROCEDURE USP_GetFunctionMasterDetail
AS
BEGIN
SELECT
FunctionId,FunctionName,
CreateDate,ModifyDate,IsActive
FROM FunctionMaster 
WHERE IsActive = 1 and IsDeleted=0;
END
