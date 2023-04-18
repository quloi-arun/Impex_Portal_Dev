
create PROCEDURE [dbo].[USP_checkRoleBaseAuthorization]
(

@UserId int,
@projectId int,
@RoleId int 
)
as
BEGIN
IF EXISTS(SELECT 1 FROM RoletoUserMapping 

WHERE UserId=@UserId and RoleId=@RoleId and ProjectId=@projectId)
BEGIN
SELECT 'true' Status;
END
ELSE
BEGIN
SELECT 'false' Status;
END
END

