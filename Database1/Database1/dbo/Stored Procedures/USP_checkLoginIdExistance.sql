﻿

CREATE PROCEDURE USP_checkLoginIdExistance(@_LoginId VARCHAR(100))
AS
BEGIN
IF EXISTS(SELECT 1 FROM MasterUser WHERE LoginId=@_LoginId)
BEGIN
SELECT 'true' Status;
END
ELSE
BEGIN
SELECT 'false' Status;
END
END