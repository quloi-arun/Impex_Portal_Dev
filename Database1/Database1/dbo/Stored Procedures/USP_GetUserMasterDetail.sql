    
CREATE PROCEDURE [dbo].[USP_GetUserMasterDetail]  @GlobalId INT = NULL    
AS    
BEGIN    
 SELECT    
  UserId    
    ,FirstName    
    ,LoginId    
    ,LastName    
    ,Age    
    ,MobileNo    
    ,Email    
    ,DateOfBirth    
    ,HomeTownAddress    
    ,CreateDate    
    ,ModifyDate,    
    UserType,    
    GlobalId,    
    CompanyName,IsMFA,MFADays,MFADate    
 FROM MasterUser    
 WHERE IsActive = 1    
 AND IsDeleted = 0  
 AND (@GlobalId IS NULL OR GlobalId=@GlobalId)    
END