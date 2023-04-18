

CREATE PROCEDURE USP_InsertClientMaster(
@_ProjectId  int
,@_ClientName  VARCHAR(200) 
,@_Address  VARCHAR(50) 
,@_StartDate datetime
,@_EndDate datetime
,@_ContactPersonName VARCHAR(200)
,@_ContactEmail VARCHAR(200)
,@_ContactPersonMobile VARCHAR(15)
,@_RegistrationDate datetime 
,@_IsApproved BIT
,@_CreatedBy int 
)
AS
BEGIN
DECLARE @_message VARCHAR(200) = '' --DEFAULT ''; 
DECLARE @_successCode INT = 0 --DEFAULT 0;
DECLARE @_ClientId  INT = 0 --DEFAULT 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Client.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END;*/
  IF EXISTS(SELECT ContactEmail FROM ClientMaster WHERE ContactEmail=@_ContactEmail)
	BEGIN
	SET @_message = 'Email already exists'; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;
	END
ELSE
BEGIN
set nocount on;  
  declare @trancount int;  
  set @trancount = @@trancount;  
  begin try  
   if @trancount = 0  
   begin transaction 
   else
   save transaction USP_InsertClientMaster
--START TRANSACTION;
INSERT INTO ClientMaster(ProjectId ,ClientName ,Address,StartDate,EndDate ,ContactPersonName,ContactEmail,ContactPersonMobile,
RegistrationDate,IsApproved,CreatedBy,IsActive,CreateDate,IsDeleted  ) 

VALUES (@_ProjectId ,@_ClientName ,@_Address,@_StartDate,@_EndDate ,@_ContactPersonName,@_ContactEmail,@_ContactPersonMobile,
@_RegistrationDate,@_IsApproved,@_CreatedBy,1,GETDATE(),0
);
SET @_ClientId = SCOPE_IDENTITY();
lbexit:  
   if @trancount = 0   
    commit;
	SET @_message = 'Client added Successfully'; 
	SET @_successCode = 200; 
	SELECT @_message Message,@_successCode SuccessCode,@_ClientId ClientId;
  end try
begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertClientMaster;            
                        
   raiserror ('USP_InsertClientMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
/*
SET _message = 'Client added Successfully'; 
SET _successCode = 200; 
SELECT _message Message,_successCode SuccessCode,_ClientId ClientId;

END IF;*/


END
END
