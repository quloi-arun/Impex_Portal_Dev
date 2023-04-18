
CREATE PROCEDURE USP_GetClientMasterDetail
AS
BEGIN
SELECT
CM.ClientId,CM.ClientName,PM.ProjectId,PM.ProjectName,CM.Address,CM.StartDate,CM.EndDate,CM.ContactPersonName,CM.ContactEmail,CM.ContactPersonMobile,CM.RegistrationDate,
CM.CreateDate,CM.ModifyDate,CM.IsActive
FROM ClientMaster CM
inner join ProjectMaster PM
ON CM.ProjectId=PM.ProjectId
WHERE CM.IsActive = 1 and CM.IsDeleted=0;
END
