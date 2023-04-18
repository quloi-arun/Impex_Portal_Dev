CREATE PROCEDURE [dbo].[USP_getToMailCCMail_SplitToCC] @UserId INT, @AllImpexUsers BIT=0, @AllSupplierRoles BIT=0,@GlobalId INT=0
AS
BEGIN
DECLARE @RoleName VARCHAR(50) = '',@SupplierId INT, @Mail1 NVARCHAR(2000) = '', @Mail2 NVARCHAR(2000) = ''
SET @RoleName = (SELECT TOP 1 RM.RoleName FROM RoleMaster RM
JOIN RoletoUserMapping RUM
ON RM.RoleId = RUM.RoleId
WHERE RM.ProjectId = 1 AND UserId=@UserId)

SET @SupplierId = (SELECT TOP 1 GlobalId FROM MasterUser WHERE UserId=@UserId)

SET @Mail1 = (SELECT
	STUFF((SELECT DISTINCT
			',' + MU.Email
FROM MasterUser MU
LEFT JOIN RoletoUserMapping RTUM
ON MU.UserId = RTUM.UserId
JOIN RoleMaster RM
ON RTUM.ProjectId = RM.ProjectId AND RTUM.RoleId = RM.RoleId
WHERE RTUM.ProjectId = 1
AND ((MU.UserType = 'ImpexOperationAdmin' AND RM.RoleName = @RoleName) OR (MU.UserType = 'ImpexOperationAdmin' AND @AllImpexUsers = 1)
OR (ISNULL(@SupplierId,0)>0 AND MU.UserType = 'ImpexOperationAdmin'))
AND MU.Email IS NOT NULL
		FOR XML PATH (''))
	, 1, 1, '') ImpexMail)

SET @Mail2 = (SELECT
	STUFF((SELECT DISTINCT
			',' + MU.Email
FROM MasterUser MU
LEFT JOIN RoletoUserMapping RTUM
ON MU.UserId = RTUM.UserId
JOIN RoleMaster RM
ON RTUM.ProjectId = RM.ProjectId AND RTUM.RoleId = RM.RoleId
WHERE RTUM.ProjectId = 1
AND ((MU.GlobalId = @SupplierId AND RM.RoleName = @RoleName) OR (@AllSupplierRoles=1 AND MU.GlobalId = @SupplierId)
OR (@SupplierId IS NULL AND MU.GlobalId = @GlobalId))
AND MU.Email IS NOT NULL
		FOR XML PATH (''))
	, 1, 1, '') SupplierMail)

SELECT 
CASE WHEN @SupplierId>0 THEN @Mail1 WHEN @SupplierId IS NULL THEN @Mail2 END ToMail,
CASE WHEN @SupplierId>0 THEN @Mail2 WHEN @SupplierId IS NULL THEN @Mail1 END CCMail,
'' BCCMail


END