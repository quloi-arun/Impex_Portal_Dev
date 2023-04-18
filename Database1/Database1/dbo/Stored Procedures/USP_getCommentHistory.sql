
CREATE PROCEDURE USP_getCommentHistory(@FormName VARCHAR(20),@ID INT)
AS
BEGIN
SELECT MU.LoginId,CH.Comment,CH.CommetedDate FROM CommentHistory CH
LEFT JOIN MasterUser MU
ON CH.CommentedBy = MU.UserId
WHERE CH.FormName = @FormName AND CH.ID = @ID
ORDER BY CH.CommetedDate DESC
END