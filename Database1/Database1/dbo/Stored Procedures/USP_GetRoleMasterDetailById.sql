
CREATE  PROCEDURE USP_GetRoleMasterDetailById(@_RoleId int)
AS
BEGIN
SELECT
RM.RoleId,RM.ProjectId,RM.RoleName,PM.ProjectName,RM.IsActive
FROM RoleMaster RM
left  JOIN  ProjectMaster PM
ON RM.ProjectId = PM.ProjectId
WHERE RM.IsActive = 1 and RM.IsDeleted=0 and RoleId=@_RoleId;
END
