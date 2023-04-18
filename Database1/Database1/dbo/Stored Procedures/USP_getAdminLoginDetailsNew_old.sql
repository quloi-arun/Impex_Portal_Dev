﻿

CREATE PROCEDURE [USP_getAdminLoginDetailsNew_old](@_LoginId VARCHAR(50))
AS
BEGIN

SELECT UserId,FirstName,LastName,LoginId,Password,MobileNo,Email,UserType,GlobalId
 FROM MasterUser
WHERE IsActive=1 AND LoginId=@_LoginId;

SELECT MU.UserId,FirstName,LastName,LoginId,Password,MobileNo,Email,
PM.ProjectId,ProjectName,RM.RoleId,RoleName,RoleDescription,MM.MenuId,MenuName,MenuDescription,MenuOrder,MenuIcon,
SMM.SubMenuId, SubMenuName,SubMenuDescription,SubMenuOrder,SubMenuIcon,FM.FunctionId,FunctionName


FROM MasterUser MU
JOIN RoletoUserMapping RUM
ON MU.UserId = RUM.UserId
JOIN RoletoProjectMapping RPM
ON RUM.ProjectId = RPM.ProjectId AND RUM.RoleId = RPM.RoleMasterId
JOIN ProjectMaster PM
ON RPM.ProjectId = PM.ProjectId
JOIN RoleMaster RM
ON RPM.RoleMasterId = RM.RoleId
JOIN MenuMaster MM
ON RPM.MenuId = MM.MenuId
JOIN SubMenuMaster SMM
ON RPM.SubMenuId = SMM.SubMenuId
JOIN L_SubMenu_Function SMF
ON SMM.SubMenuId = SMF.SubMenuId AND RPM.FunctionId = SMF.FunctionId
JOIN FunctionMaster FM
ON SMF.FunctionId = FM.FunctionId
WHERE MU.LoginId = @_LoginId and MU.IsActive=1
ORDER BY MM.MenuId,SMM.SubMenuId,FM.FunctionId;
END
