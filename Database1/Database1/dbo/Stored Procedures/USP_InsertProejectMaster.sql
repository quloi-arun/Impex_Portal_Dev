

CREATE PROCEDURE USP_InsertProejectMaster(
@_ProjectName varchar(205)
,@_WebSiteUrl varchar(100)
,@_ProjectDescription varchar(200)
,@_Short_Description varchar(101)
,@_Status varchar(70)
,@_Budget_Hour varchar(70)
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
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
DECLARE @_ProjectId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Project.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END; */
  IF EXISTS(SELECT ProjectName FROM ProjectMaster WHERE ProjectName=@_ProjectName) 
  BEGIN
	SET @_message = 'Project Name already exists'; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;
  END
ELSE
BEGIN
SET NOCOUNT ON;
	DECLARE @trancount INT;
	SET @trancount = @@trancount;
	BEGIN TRY
		IF @trancount = 0
			BEGIN TRANSACTION
			else
			save transaction USP_InsertProejectMaster
INSERT INTO ProjectMaster(ProjectName,WebSiteUrl ,ProjectDescription ,Short_Description,Status,
                          Budget_Hour,StartDate,EndDate,ContactPersonName ,ContactEmail ,ContactPersonMobile,
						   RegistrationDate ,IsApproved ,CreatedBy,IsActive,CreateDate,IsDeleted  ) 

VALUES (@_ProjectName,@_WebSiteUrl ,@_ProjectDescription ,@_Short_Description,@_Status ,@_Budget_Hour ,@_StartDate,
@_EndDate,@_ContactPersonName ,@_ContactEmail ,@_ContactPersonMobile,@_RegistrationDate , @_IsApproved ,@_CreatedBy,1,GETDATE(),0
);
SET @_ProjectId = SCOPE_IDENTITY();
	lbexit:
		IF @trancount = 0
			COMMIT;
			SET @_message = 'Project added Successfully'; 
			SET @_successCode = 200; 
			SELECT @_message Message,@_successCode SuccessCode,@_ProjectId ProjectId;
	END TRY
	/*BEGIN CATCH
		ROLLBACK;
	SET @_message = 'There are some issue while adding Project.'; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;	
	END CATCH */
	begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_InsertProejectMaster;            
                        
   raiserror ('USP_InsertProejectMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
END
