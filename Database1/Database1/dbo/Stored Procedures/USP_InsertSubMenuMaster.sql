CREATE PROCEDURE USP_InsertSubMenuMaster(
@_SubMenuName varchar(200),
@_SubMenuDescription varchar(200),
@_SubMenuOrder varchar(100),
@_SubMenuIcon varchar(100),
@_ProjectId int,
@_MenuId int ,
@_CreatedBy int)
AS
BEGIN
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
DECLARE @_SubMenuId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding SubMenu.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END; */
  IF EXISTS(SELECT SubMenuName,ProjectId,MenuId FROM SubMenuMaster WHERE SubMenuName=@_SubMenuName and ProjectId=@_ProjectId and MenuId=@_MenuId) 
  BEGIN
	SET @_message = 'Can not Bind Same Project and Same Menu to SubMenu '; 
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
    save transaction USP_InsertSubMenuMaster     
INSERT INTO SubMenuMaster(SubMenuName,
SubMenuDescription ,SubMenuOrder,SubMenuIcon,
ProjectId  ,
MenuId,
CreatedBy,IsActive,CreateDate,IsDeleted ) 

VALUES (@_SubMenuName,
@_SubMenuDescription ,@_SubMenuOrder,@_SubMenuIcon ,@_ProjectId,@_MenuId,
@_CreatedBy,
1
,getdate(),0
);
SET @_SubMenuId = scope_identity();
	lbexit:                          
   if @trancount = 0                           
    commit;
	SET @_message = 'SubMenu added Successfully'; 
	SET @_successCode = 200; 
	SELECT @_message Message,@_successCode SuccessCode,@_SubMenuId SubMenuId;
  end try                          
  /*begin catch 
	ROLLBACK;
	SET @_message = 'There are some issue while adding SubMenu.'; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;
  end catch*/
  begin catch                          
   declare @error int, @message varchar(4000), @xstate int;                          
   select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();                          
   if @xstate = -1                          
    rollback;                          
   if @xstate = 1 and @trancount = 0                          
    rollback                          
   if @xstate = 1 and @trancount > 0                          
    rollback transaction USP_InsertSubMenuMaster;                          
                          
   raiserror ('USP_InsertSubMenuMaster: %d: %s', 16, 1, @error, @message) ;                          
   return;               
  end catch
END
END
