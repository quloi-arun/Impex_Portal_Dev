

CREATE PROCEDURE USP_DeleteMapping_SubMenu_Function
(
@_SubMenu_FunctionId int,
@_UserId int
)
AS
BEGIN

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
  
  BEGIN
    ROLLBACK;
    SELECT 'There are some issue while deleting records.' Message,400 SuccessCode;
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
	UPDATE L_SubMenu_Function SET IsDeleted=1,DeleteDate=getdate(),DeletedBy=@_UserId  WHERE SubMenu_FunctionId =@_SubMenu_FunctionId;
	lbexit:                          
   if @trancount = 0                           
    commit;      
	SELECT 'Records Deleted Successfully' Message,200 SuccessCode;
  end try                          
  begin catch                          
    ROLLBACK;
    SELECT 'There are some issue while deleting records.' Message,400 SuccessCode;
  end catch 

END
