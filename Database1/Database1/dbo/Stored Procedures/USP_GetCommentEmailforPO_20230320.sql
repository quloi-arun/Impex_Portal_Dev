
CREATE PROCEDURE [dbo].[USP_GetCommentEmailforPO_20230320] @POID INT
AS  
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Link VARCHAR(50) = '',@BCCMail VARCHAR(500) = ''
SET @Link = (SELECT TOP 1 FieldValue FROM DefaultValues WHERE FieldName='Link')
SET @BCCMail = (SELECT TOP 1 FieldValue FROM DefaultValues WHERE FieldName='BCCMail')

DECLARE @Mail1 VARCHAR(1000) = '',@Mail2 VARCHAR(1000) = '', @Type INT = 0

SELECT DISTINCT
	C2.CompanyId INTO #Supplier
FROM PurchaseOrdersSync PO
JOIN Companies C1
ON PO.SupplierID = C1.CompanyID
LEFT JOIN Companies C2
	ON C1.ParentCompanyID = C2.ParentCompanyID
WHERE PO.POID = @POID

SET @Mail1 = (SELECT
STUFF((SELECT DISTINCT
			',' + ISNULL(MUI.Email,'')
		FROM MasterUser MUI
		WHERE MUI.UserType = 'ImpexOperationAdmin'
		FOR XML PATH (''))
	, 1, 1, ''))

SET @Mail2 = (SELECT
	STUFF((SELECT DISTINCT
			',' + ISNULL(MUI.Email,'')
		FROM MasterUser MUI
		WHERE MUI.GlobalId IN (SELECT * FROM #Supplier)
		FOR XML PATH (''))
	, 1, 1, ''))

SET @Type = (SELECT TOP 1 ISNULL(MU.GlobalId,0) FROM MasterUser MU
JOIN CommentHistory CH
ON MU.UserId = CH.CommentedBy
WHERE ID = @POID AND ISNULL(isEmailSent, 0) = 0)

IF EXISTS (SELECT TOP 1 1 FROM CommentHistory WHERE ID = @POID AND ISNULL(isEmailSent, 0) = 0)
BEGIN
SELECT
	M.PONumber
   --,M.TOMail
   ,CASE WHEN @Type>0 THEN @Mail1 WHEN @Type=0 THEN @Mail2 END TOMail
   ,CASE WHEN @Type>0 THEN @Mail2 WHEN @Type=0 THEN @Mail1 END CCMail
   ,@BCCMail BCCMail
   ,CONCAT('<!DOCTYPE html> 
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<style> @media only screen and (max-width: 620px) { table.body h1 { font-size: 28px !important; margin-bottom: 10px !important; } table.body p, table.body ul, table.body ol, table.body td, table.body span, table.body a { font-size: 16px !important; } table.body .wrapper, table.body .article { padding: 10px !important; } table.body .content { padding: 0 !important; } table.body .container { padding: 0 !important; width: 100% !important; } table.body .main { border-left-width: 0 !important; border-radius: 0 !important; border-right-width: 0 !important; } table.body .btn table { width: 100% !important; } table.body .btn a { width: 100% !important; } table.body .img-responsive { height: auto !important; max-width: 100% !important; width: auto !important; } } @media all { .ExternalClass { width: 100%; } .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div { line-height: 100%; } } </style>
	</head>
	<body style=" background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; " >
		<table role="presentation" border="0" cellpadding="0" cellspacing="0" class="body" style=" border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: #f6f6f6; width: 100%; " width="100%" bgcolor="#f6f6f6" >
			<tr>
				<td style="font-family: sans-serif; font-size: 14px; vertical-align: top" valign="top" > &nbsp; </td>
				<td class="container" style=" font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; max-width: 580px; padding: 10px; width: 580px; margin: 0 auto; " width="580" valign="top" >
					<div class="content" style=" box-sizing: border-box; display: block; margin: 0 auto; max-width: 580px; padding: 10px; " >
						<table role="presentation" class="main" style=" border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background: #ffffff; border-radius: 3px; width: 100%; " width="100%" >
							<tr>
								<td class="wrapper" style=" font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 20px; " valign="top" >
									<table role="presentation" border="0" cellpadding="0" cellspacing="0" style=" border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;"width="100%" >
										<tr>
											<td style=" font-family: sans-serif; font-size: 14px; vertical-align: top;"valign="top" >
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> Dear ' + M.Supplier + ' /Impex Team, </p>
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> You have received new comments against purchase order ' + M.PONumber + '. </p>
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> 
												<table style="border-collapse: collapse; width: 100%">
													<thead style="background-color: #eff4ff !important">
														<th style="border: 1px solid #dddddd; text-align: left; padding: 8px; color: #3366ff;">PONumber</th>
														<th style="border: 1px solid #dddddd; text-align: left; padding: 8px; color: #3366ff;">UserId</th>
														<th style="border: 1px solid #dddddd; text-align: left; padding: 8px; color: #3366ff;">Comment</th>
														<th style="border: 1px solid #dddddd; text-align: left; padding: 8px; color: #3366ff;">Comment Date</th>
													</thead>
													<tbody>
														<tr>
															', REPLACE(REPLACE(M.CommentInfo, '&lt;', '<'), '&gt;', '>'), '
														</tr>
													</tbody>
												</table>
												</p> 
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 20px;"> <a href="',@Link,'impex/purchase-orders/', M.POID, '">',@Link,'impex/purchase-orders/', M.POID, '</a> </p> 
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"></p>
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> Thanks </p>
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> </p>
												<img src="',@Link,'logo.jpg" alt="brand" style="margin-top: 6px; width: 150px; height:52px"/> 
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
				</td>
				<td style="font-family: sans-serif; font-size: 14px; vertical-align: top" valign="top" > &nbsp; </td>
			</tr>
		</table>
	</body>
</html>', '') Emailer
   ,M.PONumber+'/'+left(DAtename(Month,M.PODate),3)+''+Right(Year(M.PODate),2)+' - '+M.Supplier+' You have received new comment.' [Subject]
FROM (SELECT
		PO.PONumber
	   ,CO.CommentInfo
	   --,EM.TOMail
	   ,PO.Supplier
	   ,PO.POID
	   ,PO.PODate
	FROM PurchaseOrdersSync PO
	--LEFT JOIN (SELECT
	--		M.Supplier
	--	   ,M.SupplierID
	--	   ,STUFF((SELECT
	--				',' + MU.Email
	--			FROM MasterUser MU
	--			WHERE MU.GlobalId = M.SupplierId OR MU.UserType='ImpexOperationAdmin'
	--			FOR XML PATH (''))
	--		, 1, 1, '') TOMail
	--	FROM (SELECT DISTINCT
	--			Supplier
	--		   ,SupplierID
	--		FROM PurchaseOrdersSync) M) EM
	--	ON PO.SupplierID = EM.SupplierID
	OUTER APPLY (SELECT
			STUFF((SELECT
					CONCAT(' <tr>
				<td style="border: 1px solid #dddddd;text-align: left;padding: 8px;">', POS.PONumber, '</td>
				<td style="border: 1px solid #dddddd;text-align: left;padding: 8px;">', MU.LoginId, '</td>', '
				<td style="border: 1px solid #dddddd;text-align: left;padding: 8px;">', CH.Comment, '</td>
				<td style="border: 1px solid #dddddd;text-align: left;padding: 8px;">', FORMAT(CH.CommetedDate, 'dd-MM-yy'), '</td>
			  </tr>')
				FROM CommentHistory CH
				LEFT JOIN MasterUser MU
					ON CH.CommentedBy = MU.UserId
				LEFT JOIN PurchaseOrdersSync POS
					ON CH.ID = POS.POID
				WHERE CH.FormName = 'PO'
				AND CH.ID = PO.POID
				AND ISNULL(isEmailSent, 0) = 0
				FOR XML PATH (''))
			, 1, 1, '') CommentInfo) CO
			WHERE PO.POID = @POID) M

UPDATE CommentHistory SET isEmailSent=1 WHERE ID = @POID AND ISNULL(isEmailSent, 0) = 0
END
--ELSE
--BEGIN 
--SELECT 400 SuccessCode,'Record Not Found' Message 
--END
END
