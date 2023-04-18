
CREATE Procedure [dbo].[Usp_GetAllMasterUserDetails] @GlobalId INT = NULL
As
Begin
Select * from MasterUser
where IsActive = 1 and IsDeleted = 0
AND (@GlobalId IS NULL OR GlobalId=@GlobalId)
end
