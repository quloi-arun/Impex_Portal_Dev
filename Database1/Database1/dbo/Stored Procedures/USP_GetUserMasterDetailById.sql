  
CREATE PROCEDURE [dbo].[USP_GetUserMasterDetailById] ( @_UserId int ) AS BEGIN SELECT 
UserId,LoginId, FirstName,LastName,Age,MobileNo,Email, DateOfBirth,HomeTownAddress,
CreateDate,ModifyDate ,UserType    
    ,GlobalId,IsMFA,MFADays,MFADate    
 ,CompanyName FROM MasterUser  WHERE IsActive = 1 and UserId=@_UserId and IsDeleted=0; END 