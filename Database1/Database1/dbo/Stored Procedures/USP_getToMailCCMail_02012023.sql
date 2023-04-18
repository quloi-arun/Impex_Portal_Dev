  
CREATE PROCEDURE [dbo].[USP_getToMailCCMail_02012023] @SupplierId INT,@SendTo VARCHAR(10) --Supplier,Impex,Both  
AS  
BEGIN  
SELECT  
 STUFF((SELECT DISTINCT  
   ',' + MUI.Email  
  FROM MasterUser MUI  
  WHERE (@SendTo = 'Supplier'  
  AND MUI.GlobalId = @SupplierId)  
  OR (@SendTo = 'Impex'  
  AND MUI.UserType = 'ImpexOperationAdmin')  
  OR (@SendTo = 'Both'  
  AND (MUI.GlobalId = @SupplierId  
  OR MUI.UserType = 'ImpexOperationAdmin'))  
  FOR XML PATH (''))  
 , 1, 1, '') TOMail  
   ,'' CCMail  
   ,'mungare@quloi.com,saylid@quloi.com,ddhande@quloi.com' BCCMail  
END