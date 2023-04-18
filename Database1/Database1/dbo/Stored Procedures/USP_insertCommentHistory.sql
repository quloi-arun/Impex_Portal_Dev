CREATE PROCEDURE [dbo].[USP_insertCommentHistory] (@FormName VARCHAR(20),@Id INT,@Comment VARCHAR(500),@UserId INT)
AS
BEGIN
INSERT INTO CommentHistory (FormName,ID,Comment,CommentedBy,CommetedDate)
SELECT @FormName,@Id,@Comment,@UserId,GETDATE()

INSERT INTO ImpexPortalActionLog (ModuleName,Header,Description,Action,ViewBy,CreatedBy,CreatedDate,DescriptionHeader)
SELECT 'Purchase Order',(SELECT PONumber FROM PurchaseOrdersSync WHERE POID=@Id),'PO Comment : '+@Comment,'Insert',(SELECT SupplierID FROM PurchaseOrdersSync WHERE POID=@Id),@UserId,GETDATE(),'You have new PO Comment'

SELECT 'Comment Inserted Successfully.' Message ,200 SuccessCode
END