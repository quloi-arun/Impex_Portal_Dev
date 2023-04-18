CREATE PROCEDURE [dbo].[USP_updateTermsandConditions] @UserId INT
AS
BEGIN
UPDATE MasterUser SET TermsAcceptedDate=GETDATE() WHERE UserId=@UserId
SELECT 'Terms and Conditions flag updated successfully.' Message ,200 SuccessCode
END