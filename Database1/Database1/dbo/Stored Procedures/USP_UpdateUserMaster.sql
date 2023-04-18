  
 CREATE PROCEDURE [dbo].[USP_UpdateUserMaster]( @_UserId int, @_FirstName varchar(255),   
 @_LastName varchar(255), @_LoginId varchar(255),  @_Age INT=0, @_MobileNo VARCHAR(15),  
 @_Email varchar(100), @_DateOfBirth datetime, @_GenderId int, @_HomeTownAddress   
varchar(455), @_CountryId int, @_StateId int, @_CityId int, @UserType VARCHAR(100) null,     
@GlobalId INT=0, @CompanyName VARCHAR(100) null, @_Modified_By int ,@IsMfA bit,  
@MFADays INT  
) AS BEGIN /*DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN     ROLLBACK;     SELECT 'There are some issue while updating records.' Message,400 SuccessCode;     #For raising an error use RES  
IGNAL     #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.'; END; START TRANSACTION; */
SET NOCOUNT ON;
                              
  declare @trancount int;
SET @trancount = @@trancount;
                              
  begin try                              
   if @trancount = 0
BEGIN TRANSACTION
ELSE
SAVE TRANSACTION USP_UpdateUserMaster
UPDATE MasterUser
SET FirstName = @_FirstName
   ,LastName = @_LastName
   ,LoginId = @_LoginId
   ,Age = @_Age
   ,MobileNo = @_MobileNo
   ,Email = @_Email
   ,DateOfBirth = @_DateOfBirth
   ,GenderId = @_GenderId
   ,HomeTownAddress = @_HomeTownAddress
   ,CountryId = @_CountryId
   ,StateId = @_StateId
   ,CityId = @_CityId
   , --UserType=@UserType, --GlobalId=@GlobalId, --CompanyName=@CompanyName,  
	Modified_By = @_Modified_By
   ,IsMfA=@IsMfA
   , MFADays=@MFADays 
   ,ModifyDate = GETDATE()
   ,MFADate = GETUTCDATE()
WHERE UserId = @_UserId;
lbexit:
IF @trancount = 0
COMMIT;
SELECT
	'Records Updated Successfully' Message
   ,200 SuccessCode;
END TRY
/*begin catch   ROLLBACK;     SELECT 'There are some issue while updating records.' Message,400 SuccessCode;   end catch*/ BEGIN CATCH
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
ROLLBACK TRANSACTION USP_UpdateUserMaster;

RAISERROR ('USP_UpdateUserMaster: %d: %s', 16, 1, @error, @message);
RETURN;
END CATCH
END