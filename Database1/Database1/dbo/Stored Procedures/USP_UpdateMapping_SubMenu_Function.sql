
CREATE PROCEDURE USP_UpdateMapping_SubMenu_Function(
@_SubMenu_FunctionId int,
@_SubMenuId int ,
@_FunctionId int ,
@_IsActive tinyint ,
@_Modified_By int )
AS
BEGIN
/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
    #For raising an error use RESIGNAL
    #RESIGNAL SET MESSAGE_TEXT = 'An error occurred while inserting records.';
END; */
IF EXISTS(SELECT SubMenuId,FunctionId,SubMenu_FunctionId FROM L_SubMenu_Function WHERE SubMenuId=@_SubMenuId and FunctionId=@_FunctionId and SubMenu_FunctionId = @_SubMenu_FunctionId ) 
BEGIN
	 SELECT 'Allredy Exit this Mapping.' Message,400 SuccessCode;
END    
ELSE
BEGIN
set nocount on;                          
  declare @trancount int;                          
  set @trancount = @@trancount;                          
  begin try                          
   if @trancount = 0                          
    begin transaction  
UPDATE L_SubMenu_Function set 
SubMenuId=@_SubMenuId ,
FunctionId=@_FunctionId,
IsActive=@_IsActive,
Modified_By=@_Modified_By,
ModifyDate= GETDATE()
WHERE SubMenu_FunctionId = @_SubMenu_FunctionId;	
lbexit:                          
   if @trancount = 0                           
    commit;             
	SELECT 'Records Updated Successfully' Message,200 SuccessCode;
  end try                          
  begin catch 
	ROLLBACK;
    SELECT 'There are some issue while updating records.' Message,400 SuccessCode;
  END CATCH
END
END
