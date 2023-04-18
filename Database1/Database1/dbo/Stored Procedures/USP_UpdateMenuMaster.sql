

CREATE PROCEDURE USP_UpdateMenuMaster(
@_MenuId int,
@_MenuName varchar(255),
@_MenuDescription varchar(255),
@_MenuOrder varchar(255),
@_MenuIcon varchar(255),
@_ProjectId int,
@_IsActive tinyint,
@_Modified_By int
)
AS
BEGIN
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END;  */
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction
	else
	save transaction USP_UpdateMenuMaster
UPDATE MenuMaster set 
MenuName=@_MenuName ,
MenuDescription=@_MenuDescription ,
MenuOrder =@_MenuOrder ,
MenuIcon=@_MenuIcon ,
ProjectId=@_ProjectId ,
IsActive=@_IsActive,
Modified_By=@_Modified_By,
ModifyDate= GETDATE()
WHERE MenuId = @_MenuId;	
lbexit:                          
   if @trancount = 0                           
    commit;
	SELECT 'Records Updated Successfully' Message,200 SuccessCode;
  end try                          
  begin catch                          
   declare @error int, @message varchar(4000), @xstate int;                          
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                          
   if @xstate = -1                          
    rollback;                          
   if @xstate = 1 and @trancount = 0                          
    rollback                          
   if @xstate = 1 and @trancount > 0                          
    rollback transaction USP_UpdateMenuMaster;                          
                          
   raiserror ('USP_UpdateMenuMaster: %d: %s', 16, 1, @error, @message) ;                          
   return;    
  end catch
END
