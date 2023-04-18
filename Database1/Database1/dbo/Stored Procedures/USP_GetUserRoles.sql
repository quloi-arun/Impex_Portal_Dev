

CREATE Procedure [dbo].[USP_GetUserRoles]
(
@UserID int
)
AS
Begin
select UserId,RoleName from RoleMaster RM
JOIN RoletoUserMapping RUM
On RUM.RoleId = RM.RoleId
where UserId = @UserID
End
