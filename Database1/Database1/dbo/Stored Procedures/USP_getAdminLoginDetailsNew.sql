CREATE PROCEDURE [dbo].[USP_getAdminLoginDetailsNew] (@_LoginId VARCHAR(50))          
AS          
BEGIN          
 SELECT          
  MS.UserId          
    ,MS.FirstName          
    ,MS.LastName          
    ,MS.LoginId          
    ,MS.Password          
    ,MS.MobileNo          
    ,MS.Email          
    ,MS.UserType          
    ,MS.GlobalId       
 ,MS.UserImagepath      
 ,MS.CompanyName,MS.IsMFA,MS.MFADays,MS.MFADate ,RMS.RoleId, RMS.RoleName ,RM.ProjectId  
 ,IIF(TermsAcceptedDate IS NULL,0,1) TermsConditionFlag
 ,SSN.SupplierShortName
 FROM MasterUser  MS     
 join RoletoUserMapping RM    
 on MS.UserId=RM.UserId    
 join RoleMaster RMS    
 on RM.RoleId=RMS.RoleId    
 join ProjectMaster PM    
 on RM.ProjectId=PM.ProjectId  
 OUTER APPLY(SELECT TOP 1 SS.SupplierShortName FROM SupplierListWithShortName SS
 WHERE MS.CompanyName = SS.Supplier)SSN
 WHERE MS.IsActive = 1 AND MS.IsDeleted=0 and RM.ProjectId=1         
 AND LoginId = @_LoginId;          
END