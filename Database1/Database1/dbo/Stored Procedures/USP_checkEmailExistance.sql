

CREATE PROCEDURE USP_checkEmailExistance(@_email VARCHAR(100))
as
BEGIN
IF EXISTS(SELECT 1 FROM MasterUser WHERE Email=@_email)
BEGIN
SELECT 'true' Status;
END
ELSE
BEGIN
SELECT 'false' Status;
END
END

