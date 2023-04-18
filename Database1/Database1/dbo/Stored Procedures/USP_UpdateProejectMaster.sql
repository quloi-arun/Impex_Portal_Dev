
CREATE PROCEDURE USP_UpdateProejectMaster(
@_ProjectId int,
@_ProjectName varchar(205),
@_WebSiteUrl varchar(100),
@_ProjectDescription varchar(200),
@_Short_Description varchar(101),
@_Status varchar(20),
@_Budget_Hour varchar(20),
@_StartDate datetime,
@_EndDate datetime,
@_ContactPersonName VARCHAR(200),
@_ContactEmail VARCHAR(200),
@_ContactPersonMobile VARCHAR(15),
@_RegistrationDate datetime, 
@_IsApproved bit,
@_Modified_By int,
@_IsActive Bit
)
AS
BEGIN

/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END; */
 set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction
	else
	save transaction USP_UpdateProejectMaster
UPDATE ProjectMaster set 
ProjectName=@_ProjectName,
WebSiteUrl =@_WebSiteUrl,
ProjectDescription= @_ProjectDescription,
Short_Description=@_Short_Description,
Status=@_Status,
Budget_Hour=@_Budget_Hour,
StartDate=@_StartDate,
EndDate=@_EndDate,
ContactPersonName=@_ContactPersonName ,
ContactEmail =@_ContactEmail,
ContactPersonMobile=@_ContactPersonMobile,
RegistrationDate =@_RegistrationDate,
IsApproved =@_IsApproved,
Modified_By=@_Modified_By,
IsActive=@_IsActive,
ModifyDate= GETDATE()
WHERE ProjectId = @_ProjectId;	
   lbexit:                          
   if @trancount = 0                           
    commit; 
	SELECT 'Records Updated Successfully' Message,200 SuccessCode;
  end try                          
  /*begin catch 
	 ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
  end catch*/
  begin catch                        
   declare @error int, @message varchar(4000), @xstate int;                        
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                        
   if @xstate = -1                        
    rollback;                        
   if @xstate = 1 and @trancount = 0                        
    rollback                   
   if @xstate = 1 and @trancount > 0                        
    rollback transaction USP_UpdateProejectMaster;            
                        
   raiserror ('USP_UpdateProejectMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch

END
