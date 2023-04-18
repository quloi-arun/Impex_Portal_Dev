
CREATE PROCEDURE USP_UpdateSubMenuMaster(
 @_SubMenuId int ,
@_SubMenuName varchar(255),
@_SUbMenuDescription varchar(255) ,
@_SubMenuOrder varchar(255),
@_SubMenuIcon varchar(255),
@_ProjectId int,
@_MenuId int,
@_IsActive tinyint ,
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
END;
START TRANSACTION; */
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction 
	else
	save transaction USP_UpdateSubMenuMaster
UPDATE SubMenuMaster set 
SubMenuName =@_SubMenuName ,
SUbMenuDescription =@_SUbMenuDescription,
SubMenuOrder =@_SubMenuOrder ,
SubMenuIcon =@_SubMenuIcon,
ProjectId =@_ProjectId,
MenuId=@_MenuId ,
IsActive =@_IsActive,
Modified_By=@_Modified_By,
ModifyDate= GETDATE()
WHERE SubMenuId = @_SubMenuId;
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
    rollback transaction USP_UpdateSubMenuMaster;            
                        
   raiserror ('USP_UpdateSubMenuMaster: %d: %s', 16, 1, @error, @message) ;                        
   return;                     
  end catch
END
