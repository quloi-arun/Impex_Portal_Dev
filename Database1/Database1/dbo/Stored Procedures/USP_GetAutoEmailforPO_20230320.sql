
CREATE PROCEDURE [dbo].[USP_GetAutoEmailforPO_20230320]  
AS  
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Link VARCHAR(50) = '',@BCCMail VARCHAR(500) = ''
SET @Link = (SELECT TOP 1 FieldValue FROM DefaultValues WHERE FieldName='Link')
SET @BCCMail = (SELECT TOP 1 FieldValue FROM DefaultValues WHERE FieldName='BCCMail')

DECLARE @CCMail VARCHAR(1000) = ''
SET @CCMail = (SELECT
STUFF((SELECT DISTINCT
			',' + ISNULL(MUI.Email,'')
		FROM MasterUser MUI
		WHERE MUI.UserType = 'ImpexOperationAdmin'
		FOR XML PATH (''))
	, 1, 1, ''))

SELECT
	M.PONumber
   ,M.LatestAction
   ,M.TOMail
   ,@CCMail CCMail
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
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> Dear ' + M.Supplier + ', </p>
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> 
												<table style="border-collapse: collapse; width: 100%">
													<thead style="background-color: #eff4ff !important">
														<th style="border: 1px solid #dddddd; text-align: left; padding: 8px; color: #3366ff;">PART NUMBER</th>
														<th style="border: 1px solid #dddddd; text-align: left; padding: 8px; color: #3366ff;">QUANTITY</th>
														<th style="border: 1px solid #dddddd; text-align: left; padding: 8px; color: #3366ff;">DUE DATE</th>
													</thead>
													<tbody>
														<tr>
															', REPLACE(REPLACE(PartNo, '&lt;', '<'), '&gt;', '>'), '
														</tr>
													</tbody>
												</table>
												</p> 
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 20px;"> <a href="',@Link,'impex/purchase-orders/', M.POID, '">',@Link,'impex/purchase-orders/', M.POID, '</a> </p> 
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;">Please Accept it, by using the action button in Impex Portal</p>
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;">If you have any queries, please contact the Impex Team</p>
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> Thanks </p>
												<p style=" font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 6px;"> Impex </p>
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
   ,'PO NO-' + M.PONumber+'/'+left(DAtename(Month,M.PODate),3)+''+Right(Year(M.PODate),2)+' - '+M.Supplier+' Is waiting for your response' [Subject]
   ,M.ActionHistoryId
FROM (SELECT
		PO.PONumber
	   ,PO.DueDate
	   ,PO.LatestAction
	   ,IIF(PO.LatestAction = 'Viewed', AH.CreatedDate, PO.CreatedDate) CreatedDate
	   ,CASE
			WHEN PO.LatestAction = 'Viewed' AND
				DATEADD(hh, 24, COALESCE(AH.EmailSentDate, AH.CreatedDate)) < GETDATE() AND
				AH.CreatedDate >= '2022-07-01' THEN 1
			WHEN PO.LatestAction IN ('New', 'Updated') AND
				DATEADD(hh, 24, COALESCE(AH.EmailSentDate, PO.CreatedDate)) < GETDATE() AND
				PO.CreatedDate >= '2022-07-01' THEN 1
			ELSE 0
		END Trg
	   ,Part.PartNo
	   ,EM.TOMail
	   ,PO.Supplier
	   ,PO.POID
	   ,AH.ActionHistoryId
	   ,PO.PODate
	FROM PurchaseOrdersSync PO
	LEFT JOIN (SELECT
			M.Supplier
		   ,M.SupplierID
		   ,M.POID
		   ,STUFF((SELECT
					',' + MU.Email
				FROM MasterUser MU
				--WHERE MU.GlobalId = M.SupplierId
				WHERE MU.GlobalId IN (SELECT DISTINCT C2.CompanyID FROM Companies C1
					LEFT JOIN Companies C2
						ON C1.ParentCompanyID = C2.ParentCompanyID
					WHERE C1.CompanyID = M.SupplierID)
				FOR XML PATH (''))
			, 1, 1, '') TOMail
		FROM (SELECT POID,Supplier,SupplierID
			FROM PurchaseOrdersSync) M) EM
		ON PO.POID = EM.POID
	OUTER APPLY (SELECT
			STUFF((SELECT
					CONCAT(' <tr>
				<td style="border: 1px solid #dddddd;text-align: left;padding: 8px;">', POS.PartNo, '</td>
				<td style="border: 1px solid #dddddd;text-align: left;padding: 8px;">', POS.Qty, '</td>', '
				<td style="border: 1px solid #dddddd;text-align: left;padding: 8px;">', POS.DueDate, '</td>
			  </tr>')
				FROM PurchaseOrderLineItemsSync POS
				WHERE PO.POID = POS.POID
				FOR XML PATH (''))
			, 1, 1, '') PartNo) Part
	LEFT JOIN ActionHistory AH
		ON PO.POID = AH.ID
		AND AH.FormName = 'PO'
		AND PO.LatestAction = AH.ActionTaken
	WHERE PO.LatestAction IN ('New', 'Updated', 'Viewed')) M
WHERE M.Trg = 1
END
