

CREATE PROCEDURE USP_getUserTokens(@_UserId  int
)
AS
BEGIN
 select HashId,PasswordSalt,UserId  from UserTokens where UserId=@_UserId;
END
