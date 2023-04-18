
CREATE PROCEDURE USP_GetFunctionMasterDetailById(@_FunctionId int)
AS
BEGIN
SELECT
FunctionId,FunctionName,
CreateDate,ModifyDate,IsActive
FROM FunctionMaster 
WHERE IsActive = 1 and IsDeleted=0 and FunctionId = @_FunctionId;
END

