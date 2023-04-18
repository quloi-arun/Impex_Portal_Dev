
CREATE  PROCEDURE USP_GetRoleWiseProjectMapping_060522
(
@_projectId INT
,@_roleMasterId INT 
)
AS
BEGIN
DECLARE @_count INT;
  /*DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SELECT 'There are some issue while fetching records.' Message,400 SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END;
  START TRANSACTION; */
  set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction
SET @_count=0;
SELECT @_count = COUNT(*) FROM (
SELECT @_roleMasterId RoleMasterId,PM.ProjectId,MM.MenuId,SMM.SubMenuId,FM.FunctionId,0 IsChecked FROM ProjectMaster PM
LEFT JOIN MenuMaster MM
ON PM.ProjectId = MM.ProjectId
LEFT JOIN SubMenuMaster SMM
ON MM.MenuId = SMM.MenuId
LEFT JOIN L_SubMenu_Function LF
ON SMM.SubMenuId = LF.SubMenuId
LEFT JOIN FunctionMaster FM
ON LF.FunctionId = FM.FunctionId
WHERE PM.ProjectId=@_projectId)M
LEFT JOIN RoletoProjectMapping RPM
ON M.ProjectId = RPM.ProjectId AND M.RoleMasterId=RPM.RoleMasterId
AND M.MenuId = RPM.MenuId AND M.SubMenuId = RPM.SubMenuId AND M.FunctionId = RPM.FunctionId
WHERE   RPM.ProjectId IS NULL AND   M.MenuId IS NOT NULL AND M.SubMenuId IS NOT NULL  AND M.FunctionId IS NOT NULL;

IF (@_count>0)
BEGIN
INSERT INTO RoletoProjectMapping (RoleMasterId,ProjectId,MenuId,SubMenuId,FunctionId,IsChecked)
SELECT M.* FROM (
SELECT @_roleMasterId RoleMasterId,PM.ProjectId,MM.MenuId,SMM.SubMenuId,FM.FunctionId,0 IsChecked
FROM ProjectMaster PM
LEFT JOIN MenuMaster MM
ON PM.ProjectId = MM.ProjectId
LEFT JOIN SubMenuMaster SMM
ON MM.MenuId = SMM.MenuId
LEFT JOIN L_SubMenu_Function LF
ON SMM.SubMenuId = LF.SubMenuId
LEFT JOIN FunctionMaster FM
ON LF.FunctionId = FM.FunctionId
WHERE PM.ProjectId=@_projectId AND LF.IsDeleted=0)M
LEFT JOIN RoletoProjectMapping RPM
ON M.ProjectId = RPM.ProjectId AND M.RoleMasterId=RPM.RoleMasterId
AND M.MenuId = RPM.MenuId AND M.SubMenuId = RPM.SubMenuId AND M.FunctionId = RPM.FunctionId
WHERE  RPM.ProjectId IS NULL AND M.MenuId IS NOT NULL AND M.SubMenuId IS NOT NULL AND M.FunctionId IS NOT NULL;
END


SELECT RPM.RoletoProjectMappingId,PM.ProjectName,MM.MenuName,SMM.SubMenuName,FunctionName,IsChecked 
 FROM RoletoProjectMapping RPM
LEFT JOIN ProjectMaster PM
ON RPM.ProjectId = PM.ProjectId 
LEFT JOIN MenuMaster MM
ON RPM.MenuId = MM.MenuId
LEFT JOIN SubMenuMaster SMM
ON RPM.SubMenuId = SMM.SubMenuId
LEFT JOIN FunctionMaster FM
ON RPM.FunctionId = FM.FunctionId
LEFT JOIN L_SubMenu_Function LF
ON SMM.SubMenuId = LF.SubMenuId AND FM.FunctionId = LF.FunctionId
WHERE RPM.ProjectId=@_projectId AND RoleMasterId=@_roleMasterId AND LF.IsDeleted=0;
lbexit:                          
   if @trancount = 0                           
    commit;
	--SELECT 'Records Deleted Successfully' Message,200 SuccessCode;
  end try                          
  begin catch 
	ROLLBACK;
    SELECT 'There are some issue while deleting records.' Message,400 SuccessCode;
  end catch


END
