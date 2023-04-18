

CREATE PROCEDURE USP_InsertMapping_SubMenu_Function(
@_SubMenuId int,
@_FunctionId int,
@_CreatedBy int
)
AS
BEGIN
DECLARE @_message VARCHAR(200) = ''; 
DECLARE @_successCode INT = 0;
DECLARE @_SubMenu_FunctionId  INT = 0;	
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
    ROLLBACK;
	SET _message = 'There are some issue while adding Function.'; 
    SET _successCode = 400; 
    SELECT _message Message,_successCode SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
 END;*/
 IF EXISTS(SELECT SubMenuId,FunctionId FROM L_SubMenu_Function WHERE SubMenuId=@_SubMenuId and FunctionId=@_FunctionId )
 BEGIN
	SET @_message = 'Allredy Exit this Mapping '; 
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
 INSERT INTO L_SubMenu_Function(SubMenuId,FunctionId,CreatedBy,CreateDate,IsDeleted,IsActive ) 
 VALUES (
@_SubMenuId,@_FunctionId,@_CreatedBy,
 getdate(),0,1
);
SET @_SubMenu_FunctionId = SCOPE_IDENTITY();
SET @_message = 'Mapping  Successfully'; 
SET @_successCode = 200; 
SELECT @_message Message,@_successCode SuccessCode, @_SubMenu_FunctionId  SubMenu_FunctionId;
 lbexit:  
   if @trancount = 0   
    commit;  
  end try  
  begin catch
	ROLLBACK;
	SET @_message = 'There are some issue while adding Function.'; 
    SET @_successCode = 400; 
    SELECT @_message Message,@_successCode SuccessCode;
  end Catch 
 END
END
