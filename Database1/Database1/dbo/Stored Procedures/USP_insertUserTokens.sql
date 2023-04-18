CREATE PROCEDURE USP_insertUserTokens(@_userId INT,@_passwordSalt VARCHAR(200))
AS
BEGIN

INSERT INTO UserTokens(PasswordSalt,UserId,CreatedOn)
SELECT @_passwordSalt,@_userId,getdate();
END
