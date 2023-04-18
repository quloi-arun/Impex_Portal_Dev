CREATE PROCEDURE [dbo].[USP_InsertUserMaster]   
(@_FirstName VARCHAR(255),   
@_LastName VARCHAR(255),  
@_LoginId VARCHAR(255),  
@_Password VARCHAR(400),  
@_MobileNo VARCHAR(15),  
@_DateOfBirth DATE,  
@_Email VARCHAR(100),   
@_GenderId INT,  
@_CountryId INT,  
@_StateId INT,  
@_CityId INT,   
@UserType VARCHAR(100) null,   
@GlobalId INT=0,  
@CompanyName VARCHAR(100) null,   
@HomeTownAddress VARCHAR(300) NULL,  
@_CreatedBy INT,
@IsMfA bit,
@MFADays INT

)  
AS  
BEGIN  
 DECLARE @_message VARCHAR(200) = '';  
 DECLARE @_successCode INT = 0;  
 DECLARE @_UserId INT = 0;  
 IF EXISTS (SELECT  
    LoginId  
      ,Email  
   FROM MasterUser  
   WHERE LoginId = @_LoginId  
   AND Email = @_Email)  
 BEGIN  
  SET  
  @_message = 'User LoginId OR EmailId already exists';  
  SET @_successCode = 400;  
  SELECT  
   @_message Message  
     ,@_successCode SuccessCode;  
 END  
 ELSE  
 BEGIN  
  SET NOCOUNT ON;  
  DECLARE @trancount INT;  
  SET @trancount = @@trancount;  
 BEGIN TRY  
  IF @trancount = 0  
   BEGIN TRANSACTION  
  ELSE  
   SAVE TRANSACTION USP_InsertUserMaster  
  INSERT INTO MasterUser (FirstName, LastName, LoginId, Password, MobileNo, DateOfBirth, Email, 
  GenderId, CountryId, StateId, CityId,UserType,GlobalId,CompanyName,HomeTownAddress,
  CreatedBy,IsMfA,MFADays,
  IsActive, CreateDate, IsDeleted,MFADate)  
   VALUES (@_FirstName, @_LastName, @_LoginId, @_Password, @_MobileNo, @_DateOfBirth, @_Email,
   @_GenderId, @_CountryId, @_StateId, @_CityId,@UserType,@GlobalId,@CompanyName, @HomeTownAddress,
   @_CreatedBy,@IsMfA,@MFADays, 1, GETDATE(), 0,GETUTCDATE());  
  SET @_UserId = SCOPE_IDENTITY();  
 lbexit:  
  IF @trancount = 0  
   COMMIT;  
  SET @_message = 'User added Successfully';  
  SET @_successCode = 200;  
  SELECT  
   @_message Message  
     ,@_successCode SuccessCode  
     ,@_UserId UserId;  
 END TRY  
 BEGIN CATCH  
  DECLARE @error INT  
      ,@message VARCHAR(4000)  
      ,@xstate INT;  
  SELECT  
   @error = ERROR_NUMBER()  
     ,@message = ERROR_MESSAGE()  
     ,@xstate = XACT_STATE();  
  IF @xstate = -1  
   ROLLBACK;  
  IF @xstate = 1  
   AND @trancount = 0  
   ROLLBACK  
  IF @xstate = 1  
   AND @trancount > 0  
   ROLLBACK TRANSACTION USP_InsertUserMaster;  
  
  RAISERROR ('USP_InsertUserMaster: %d: %s', 16, 1, @error, @message);  
  RETURN;  
 END CATCH   /*begin catch  ROLLBACK;  SET _message = 'There are some issue while adding User.';      SET _successCode = 400; SELECT _message Message, _successCode SuccessCode;   end catch*/  
 END  
END