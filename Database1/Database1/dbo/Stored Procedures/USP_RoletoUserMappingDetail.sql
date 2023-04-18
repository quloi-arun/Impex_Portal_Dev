CREATE PROCEDURE [dbo].[USP_RoletoUserMappingDetail] @GlobalId INT = NULL
AS BEGIN
SELECT RUM.RoletoUserMappingId, 
RUM.ProjectId,PM.ProjectName,RUM.RoleId,
RM.RoleName,RUM.UserId,MU.FirstName,MU.LastName 
FROM RoletoUserMapping RUM 
Inner Join ProjectMaster PM on RUM.ProjectId=PM.ProjectId 
Inner join RoleMaster RM ON RUM.RoleId=RM.RoleId 
Inner Join MasterUser MU ON RUM.UserId= MU.UserId WHERE RUM.IsDeleted=0
AND (@GlobalId IS NULL OR GlobalId=@GlobalId)
END