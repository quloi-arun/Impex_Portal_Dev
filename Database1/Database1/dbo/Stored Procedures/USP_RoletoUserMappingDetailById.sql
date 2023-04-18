

CREATE PROCEDURE USP_RoletoUserMappingDetailById(@_RoletoUserMappingId int)
AS
BEGIN
SELECT RUM.RoletoUserMappingId,RUM.ProjectId,RUM.RoleId,RUM.UserId,PM.ProjectName,RM.RoleName,MU.FirstName
FROM RoletoUserMapping RUM
Inner Join ProjectMaster PM
on RUM.ProjectId=PM.ProjectId
Inner join RoleMaster RM
ON RUM.RoleId=RM.RoleId
Inner Join MasterUser MU
ON RUM.UserId= MU.UserId
WHERE RUM.RoletoUserMappingId =@_RoletoUserMappingId and RUM.IsDeleted=0;
END
