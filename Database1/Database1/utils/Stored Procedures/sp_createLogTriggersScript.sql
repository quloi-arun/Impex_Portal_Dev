 
--SELECT SCHEMA_ID(@Schema) @Schema      
      
--USE ATAVCS_27032014_MUM          
--GO          
            
--DECLARE @ColExpir varchar(100), @SCHEMANAME VARCHAR(100)
            
----------------------------------------------------------            
--DECLARE @MyCursor CURSOR            
--SET @MyCursor = CURSOR FAST_FORWARD            
--FOR            
--SELECT O.name, SCHEMANAME = SCHEMA_NAME(O.schema_id) FROM ATAVCS_CT_REPL.sys.tables t
--JOIN sys.objects O ON O.name = SUBSTRING(t.name,7,LEN(t.name))
--WHERE t.name LIKE 'AUDIT_%'            
--AND t.name NOT LIKE '%20%'            
            
            
--OPEN @MyCursor            
--FETCH NEXT FROM @MyCursor
--INTO @ColExpir,@SCHEMANAME            
--WHILE @@FETCH_STATUS = 0            
--BEGIN            
--  --PRINT '--'+@ColExpir            
--  PRINT 'EXEC utils.sp_createLogTriggersScript ' + @ColExpir + ',1,'''+ @SCHEMANAME  +'''
--  GO'
  
--  --EXEC utils.sp_createLogTriggersScript @ColExpir,1            
             
--FETCH NEXT FROM @MyCursor            
--INTO @ColExpir,@SCHEMANAME
--END            
--CLOSE @MyCursor            
--DEALLOCATE @MyCursor           
            
            
            
--utils.sp_createLogTriggersScript 'tempManoj',1            
            
--EXEC .utils.sp_createLogTriggersScript 'tempManoj',1            
          
          
CREATE PROCEDURE [utils].[sp_createLogTriggersScript](@table_name varchar(100),@delScript bit = 0, @Schema varchar(20) = 'dbo', @CreateTable bit = 1, @CreateProc bit = 1, @CreateTrg bit = 1)            
AS            
DECLARE @Cols VARCHAR(MAX), @ColVar VARCHAR(MAX), @ColVarAssign VARCHAR(MAX), @ColsTbl VARCHAR(MAX),@ColNames VARCHAR(MAX)            
DECLARE @DB_NAME sysname,@DB_NAME_LOG sysname            
SET @DB_NAME = DB_NAME()            
SET @DB_NAME_LOG = DB_NAME() + '_CT_REPL'            
SET @Cols = ''            
SET @ColVar = ''            
SET @ColVarAssign = ''            
SET @ColsTbl = ''            
SET @ColNames = ''            
--SET @table_name = 'tempManoj'            
            
PRINT '--' + QUOTENAME(@table_name)             
            
IF @delScript = 1            
BEGIN            
PRINT '            
USE ' + @DB_NAME + '            
GO            
IF EXISTS (SELECT * FROM ' + @DB_NAME + '.sys.objects WHERE name = ''usp_trg_AUDIT_'+ @table_name +''' AND schema_id = SCHEMA_ID(''' + @Schema + ''')  AND type = ''P'')            
BEGIN            
 DROP PROCEDURE ['+ @Schema + '].usp_trg_AUDIT_' + @table_name + '            
END            
GO            
IF EXISTS (SELECT * FROM ' + @DB_NAME + '.sys.objects WHERE name = ''TRG_LOG_'+ @table_name +''' AND schema_id = SCHEMA_ID(''' + @Schema + ''')  AND type = ''TR'')            
BEGIN            
 DROP TRIGGER ['+ @Schema + '].TRG_LOG_' + @table_name + '            
END            
GO            
USE ' + @DB_NAME_LOG + '            
GO            
IF EXISTS (SELECT * FROM ' + @DB_NAME_LOG + '.sys.objects WHERE name = ''AUDIT_'+ @table_name +''' AND schema_id = SCHEMA_ID(''' + @Schema + ''')  AND type = ''U'')            
BEGIN            
 SELECT * INTO ['+ @Schema + '].AUDIT_' + @table_name + '_' + REPLACE(CONVERT(VARCHAR(10),GETDATE(),103),'/','') + ' FROM ' + '['+ @Schema + '].AUDIT_' + @table_name + '            
 DROP TABLE ['+ @Schema + '].AUDIT_' + @table_name + '            
END            
GO            
'            
END            
            
EXEC('USE ' + @DB_NAME)            
            
SET @Cols = (SELECT              
' @' + REPLACE(c.name,' ','') + ' ' + t.name + CASE WHEN t.name IN('nvarchar','varchar','char','nchar')           
THEN '(' + CASE c.max_length WHEN -1 THEN 'MAX' ELSE CAST(c.max_length as varchar(10)) END + ')' WHEN t.name IN('decimal') THEN '(' + CAST(c.precision as varchar(10))           
+ ',' + CAST(c.scale as varchar(10)) + ')' ELSE '' END + ',' + CHAR(10)            
--c.name + ' ' + t.name --+ '(' + CAST(c.max_length as varchar(10)) + ',' + CAST(c.precision as varchar(10)) + ')' + ','             
--+ CHAR(10)            
FROM sys.columns c            
JOIN sys.types t ON c.user_type_id = t.user_type_id            
JOIN sys.objects o ON c.object_id = o.object_id      
WHERE OBJECT_NAME(c.object_id) = @table_name            
AND o.schema_id = SCHEMA_ID(@Schema)       
AND t.name NOT IN ('text','NTEXT','image')             
ORDER BY c.column_id FOR XML PATH('') )            
            
SELECT @Cols = @Cols +             
' @TRG_ACTION char(6),            
 @TRG_DATE datetime,            
 @TRG_DATE_UTC datetime,            
 @TRG_DATE_OFFSET datetimeoffset(7),            
 @TRANSACTION_APP varchar(200),            
 @COMPUTER_NAME varchar(200),            
 @IP_ADDR varchar(50),           
 @SERVER_NAME varchar(50)            
'            
            
            
SELECT @ColsTbl = @ColsTbl +             
' ' + QUOTENAME(c.name) + ' ' + t.name + CASE WHEN t.name IN('nvarchar','varchar','char','nchar')           
THEN '(' + CASE c.max_length WHEN -1 THEN 'MAX' ELSE CAST(c.max_length as varchar(10)) END + ')' WHEN t.name IN('decimal') THEN '(' + CAST(c.precision as varchar(10)) + ',' + CAST(c.scale as varchar(10)) + ')' ELSE '' END + ',' + CHAR(10)            
--c.name + ' ' + t.name --+ '(' + CAST(c.max_length as varchar(10)) + ',' + CAST(c.precision as varchar(10)) + ')' + ','             
--+ CHAR(10)            
FROM sys.columns c            
JOIN sys.types t ON c.user_type_id = t.user_type_id            
JOIN sys.objects o ON c.object_id = o.object_id      
WHERE OBJECT_NAME(c.object_id) = @table_name            
AND o.schema_id = SCHEMA_ID(@Schema)      
AND t.name NOT IN ('text','NTEXT','image')             
ORDER BY c.column_id             
            
SELECT @ColsTbl = @ColsTbl +             
' TRG_ACTION char(6),            
 TRG_DATE datetime,            
 TRG_DATE_UTC datetime,            
 TRG_DATE_OFFSET datetimeoffset(7),            
 TRANSACTION_APP varchar(200),            
 COMPUTER_NAME varchar(200),            
 IP_ADDR varchar(50),            
 SERVER_NAME varchar(50)            
'            
            
            
SELECT @ColVar = @ColVar +             
' @' + REPLACE(c.name,' ','') + ',' + CHAR(10)            
--c.name + ' ' + t.name --+ '(' + CAST(c.max_length as varchar(10)) + ',' + CAST(c.precision as varchar(10)) + ')' + ','             
--+ CHAR(10)            
FROM sys.columns c            
JOIN sys.types t ON c.user_type_id = t.user_type_id            
JOIN sys.objects o ON c.object_id = o.object_id      
WHERE OBJECT_NAME(c.object_id) = @table_name            
AND o.schema_id = SCHEMA_ID(@Schema)      
AND t.name NOT IN ('text','NTEXT','image')             
ORDER BY c.column_id            
            
            
SELECT @ColVarAssign = @ColVarAssign +             
'  @' + REPLACE(c.name,' ','') + ' = ' + QUOTENAME(c.name) + ',' + CHAR(10)            
--c.name + ' ' + t.name --+ '(' + CAST(c.max_length as varchar(10)) + ',' + CAST(c.precision as varchar(10)) + ')' + ','             
--+ CHAR(10)            
FROM sys.columns c            
JOIN sys.types t ON c.user_type_id = t.user_type_id            
JOIN sys.objects o ON c.object_id = o.object_id      
WHERE OBJECT_NAME(c.object_id) = @table_name            
AND o.schema_id = SCHEMA_ID(@Schema)      
AND t.name NOT IN ('text','NTEXT','image')             
ORDER BY c.column_id             
            
SELECT @ColVarAssign = @ColVarAssign +             
'  @TRG_ACTION = @ACT_TRG,            
  @TRG_DATE = GETDATE(),            
  @TRG_DATE_UTC = SYSUTCDATETIME(),            
  @TRG_DATE_OFFSET = SYSDATETIMEOFFSET(),            
  @TRANSACTION_APP = APP_NAME(),            
  @COMPUTER_NAME = HOST_NAME(),            
  @IP_ADDR = CAST(CONNECTIONPROPERTY(''client_net_address'') AS VARCHAR(50)),            
  @SERVER_NAME = CAST(@@SERVERNAME AS VARCHAR(50))    
'            
            
SELECT @ColVar = @ColVar +             
' @TRG_ACTION,            
 @TRG_DATE,            
 @TRG_DATE_UTC,            
 @TRG_DATE_OFFSET,            
 @TRANSACTION_APP,            
 @COMPUTER_NAME,            
 @IP_ADDR,            
 @SERVER_NAME'            
            
            
SELECT @ColNames = @ColNames +             
'  ' + QUOTENAME(c.name) + ',' + CHAR(10)            
--c.name + ' ' + t.name --+ '(' + CAST(c.max_length as varchar(10)) + ',' + CAST(c.precision as varchar(10)) + ')' + ','       
--+ CHAR(10)            
FROM sys.columns c            
JOIN sys.types t ON c.user_type_id = t.user_type_id            
JOIN sys.objects o ON c.object_id = o.object_id      
WHERE OBJECT_NAME(c.object_id) = @table_name            
AND o.schema_id = SCHEMA_ID(@Schema)      
AND t.name NOT IN ('text','NTEXT','image')             
ORDER BY c.column_id             
            
-----------------------------Variables Assigned Above-----------------            
            
IF @CreateTrg = 1          
BEGIN          
          
PRINT '            
IF NOT EXISTS(SELECT * FROM sys.servers WHERE name = N''localTrg'')            
BEGIN            
-- Add a localTrg linked server            
EXEC sp_addlinkedserver @server = N''localTrg'', @srvproduct = N'' '', @provider = N''SQLNCLI'',             
               @datasrc = @@SERVERNAME            
            
--By default, a linked server participates in a distributed transaction, but you need independent transactions, so you have to set remote proc transaction promotion to false:             
EXEC sp_serveroption localTrg, N''remote proc transaction promotion'', ''false''             
            
-- Also enable RPC to call stored procedures            
EXEC sp_serveroption localTrg, N''rpc out'', ''true''            
END            
GO            
'            
END          
          
            
--PRINT 'USE ' + @DB_NAME + '            
--GO'            
IF @CreateTable = 1             
BEGIN            
            
PRINT '            
USE ' + @DB_NAME_LOG + '            
GO            
IF NOT EXISTS (SELECT * FROM ' + @DB_NAME_LOG + '.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=''AUDIT_'+ @table_name +''' AND TABLE_SCHEMA = ''' + @Schema + ''')            
BEGIN            
CREATE TABLE ['+ @Schema + '].AUDIT_' + @table_name + '            
(' + @ColsTbl +            
')            
END            
GO            
'            
END            
            
IF @CreateProc = 1             
BEGIN            
            
PRINT '            
USE ' + @DB_NAME + '            
GO            
CREATE PROCEDURE ['+ @Schema + '].usp_trg_AUDIT_'+ @table_name + '(            
'             
+ @Cols +            
')            
AS'            
            
PRINT '            
INSERT '+ @DB_NAME_LOG +'.['+ @Schema + '].AUDIT_' + @table_name + '(' + @ColNames +          
' TRG_ACTION,            
 TRG_DATE,            
 TRG_DATE_UTC,            
 TRG_DATE_OFFSET,            
 TRANSACTION_APP,            
 COMPUTER_NAME,            
 IP_ADDR,            
 SERVER_NAME)            
SELECT ' + @ColVar + '            
            
GO            
'            
END            
            
--PRINT 'IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = ''TRG_AUDIT_' + @table_name + ''')            
--BEGIN            
-- DROP TRIGGER [dbo].[TRG_AUDIT_' + @table_name + ']            
--END            
--GO            
--'            
IF @CreateTrg = 1             
BEGIN            
            
PRINT '            
USE ' + @DB_NAME + '            
GO            
CREATE TRIGGER ['+ @Schema + '].[TRG_LOG_' + @table_name + '] ON ['+ @Schema + '].' + QUOTENAME(@table_name) + '            
AFTER DELETE, INSERT, UPDATE            
                
AS            
 SET NOCOUNT ON            
    DECLARE @ACT_TRG CHAR(6)            
    DECLARE @DEL_TRG BIT            
    DECLARE @INS_TRG BIT             
    DECLARE @SQLSTRING VARCHAR(2000)            
            
    SET @DEL_TRG = 0            
    SET @INS_TRG = 0            
            
    IF EXISTS ( SELECT TOP 1            
                        1            
                FROM    DELETED )             
        SET @DEL_TRG = 1            
    IF EXISTS ( SELECT TOP 1            
                        1            
                FROM    INSERTED )             
        SET @INS_TRG = 1             
            
    IF @INS_TRG = 1            
        AND @DEL_TRG = 1             
        SET @ACT_TRG = ''UPDATE''            
    IF @INS_TRG = 1            
        AND @DEL_TRG = 0             
        SET @ACT_TRG = ''INSERT''            
    IF @DEL_TRG = 1            
        AND @INS_TRG = 0             
        SET @ACT_TRG = ''DELETE''            
            
    IF @INS_TRG = 0            
        AND @DEL_TRG = 0             
        RETURN            
                    
DECLARE ' + @Cols             
            
PRINT '            
            
DECLARE TrigTempUpdate_Cursor CURSOR FOR            
            
SELECT  ' + @ColNames + '            
  TRG_ACTION = @ACT_TRG,            
  TRG_DATE = GETDATE(),            
  TRG_DATE_UTC = SYSUTCDATETIME(),            
  TRG_DATE_OFFSET = SYSDATETIMEOFFSET(),            
  TRANSACTION_APP = APP_NAME(),            
  COMPUTER_NAME = HOST_NAME(),            
  IP_ADDR = CAST(CONNECTIONPROPERTY(''client_net_address'') AS VARCHAR(50)),            
  SERVER_NAME = CAST(@@SERVERNAME AS VARCHAR(50))            
  FROM INSERTED WHERE @ACT_TRG IN(''INSERT'',''UPDATE'')            
UNION ALL            
SELECT  ' + @ColNames + '            
  TRG_ACTION = @ACT_TRG,            
  TRG_DATE = GETDATE(),            
  TRG_DATE_UTC = SYSUTCDATETIME(),            
  TRG_DATE_OFFSET = SYSDATETIMEOFFSET(),            
  TRANSACTION_APP = APP_NAME(),            
  COMPUTER_NAME = HOST_NAME(),            
  IP_ADDR = CAST(CONNECTIONPROPERTY(''client_net_address'') AS VARCHAR(50)),            
  SERVER_NAME = CAST(@@SERVERNAME AS VARCHAR(50))            
  FROM DELETED WHERE @ACT_TRG IN(''DELETE'')            
'            
            
PRINT '            
OPEN TrigTempUpdate_Cursor;            
            
FETCH NEXT FROM TrigTempUpdate_Cursor INTO ' + @ColVar            
            
--PRINT '            
--IF @ACT_TRG IN(''INSERT'',''UPDATE'')            
-- SELECT             
--' + @ColVarAssign + '            
--FROM INSERTED            
--'            
--PRINT 'IF @ACT_TRG = ''DELETE''            
-- SELECT             
--' + @ColVarAssign + '            
--FROM DELETED            
--'            
            
PRINT '            
WHILE @@FETCH_STATUS = 0            
BEGIN            
'            
            
PRINT '            
EXEC localTrg.' + @DB_NAME + '.['+ @Schema + '].usp_trg_AUDIT_' + @table_name + '            
' + @ColVar + '            
'            
            
PRINT '            
FETCH NEXT FROM TrigTempUpdate_Cursor INTO ' + @ColVar            
            
PRINT '            
END;            
            
CLOSE TrigTempUpdate_Cursor;            
            
DEALLOCATE TrigTempUpdate_Cursor;            
SET NOCOUNT OFF            
GO            
'            
END 