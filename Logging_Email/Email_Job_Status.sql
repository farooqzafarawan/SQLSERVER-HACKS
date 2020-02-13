DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000),
	@vXML_String AS NVARCHAR(MAX),
	@vSubject AS    NVARCHAR(max),
	@vBody AS    NVARCHAR(max),
	@exists AS      BIT,
    @SuccessStatus AS NVARCHAR(MAX),
    @FailStatus AS NVARCHAR(MAX);

		Select @SuccessStatus=count(*) 
		from 
		 EIJobHeader H
		, EIJobsDetail D
		where H.EntityNumber = D.EntityNumber and H.EntityName = D.EntityName
		and D.ExecutionDate = (select max(ExecutionDate) from EIJobsDetail)
		and D.Status in ('Succeeded') and H.JobType = 'Ingestion' and H.IsActive = 1 AND D.TargetRowCount IS NOT NULL;

		select @FailStatus=count(*) 
		from 
		 EIJobHeader H
		, EIJobDetail D
		where H.EntityNumber = D.EntityNumber and H.EntityName = D.EntityName
		and D.ExecutionDate = (select max(ExecutionDate) from EIJobsDetail)
		and D.Status in ('Failed') and H.JobType = 'Ingestion' and H.IsActive = 1 AND D.TargetRowCount IS NOT NULL;

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body> <b> <center>' + 'Report generated on : '
    + CONVERT(VARCHAR(50), GETDATE(), 106) 
	+ '</style>' + '</head>' + '<body> <b>' + 'CWC Daily Ingestion Job Status;  Success : ' + @SuccessStatus + ' Failure : ' + @FailStatus
	+ '</style>' + '</head>' + '<body> <b>' 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<td bgcolor=#E6E6FA><b>EntityName</b></td>'
    + '<td bgcolor=#E6E6FA><b>ExecutionMode Ref</b></td>'
    + '<td bgcolor=#E6E6FA><b>ExecutionDate</b></td>'
    + '<td bgcolor=#E6E6FA><b>StartDateTime</b></td>'
    + '<td bgcolor=#E6E6FA><b>EndDateTime Name</b></td>'
	+ '<td bgcolor=#E6E6FA><b>ExecutionTime</b></td>'
    + '<td bgcolor=#E6E6FA><b>Status</b></td>'
    + '<td bgcolor=#E6E6FA><b>TargetRowCount Name</b></td>'
    + '<td bgcolor=#E6E6FA><b>Message</b></td></tr>' ;





SET @vXML_String =  CONVERT( NVARCHAR(MAX),
                        (
                          SELECT DISTINCT             '',
                              td=   H.EntityName,     '',
                              td=   H.ExecutionMode,   '',
                              td=   D.ExecutionDate,   '',
                              td =  D.StartDateTime,								'',
			      td =  D.EndDateTime, '',
                              td =  DATEDIFF(MINUTE,D.StartDateTime,D.EndDateTime)  ,                                '',
                              td =  D.Status,                                 '',
                              td =  D.TargetRowCount,						      '',
                              td =  D.ErrorMsg, ''
                          FROM EIJobHeader H
				, EntityIngestionJobsDetail D
			where H.EntityNumber = D.EntityNumber and H.EntityName = D.EntityName
			and D.ExecutionDate = (select max(ExecutionDate) from EntityIngestionJobsDetail)
			and D.Status in ('Succeeded','Failed') and H.JobType = 'Ingestion' 
			and H.IsActive = 1 AND D.TargetRowCount IS NOT NULL
                          FOR XML PATH( 'tr' )
                        ) );


IF ISNULL( @vXML_String, '''' )<>''''
BEGIN
SET @exists=1;
END;

--SET @vXML_String=REPLACE( @vXML_String, ''<td>'', ''<td style="font-family:Calibri;color:black;font-size:12px;border:1px solid black;">'' );

SET @Body=@vXML_String;

SET @vSubject= 'Server Name: localhost; Job Name: Ingest_To_ADL; Status: Success : ' + @SuccessStatus + ', Failure : ' + @FailStatus  + '; Exec Time: ' + CONVERT( nvarchar, GETDATE( ) );


--SET @vXML_String=REPLACE( @vXML_String, ''<td>'', ''<td style="font-family:Calibri;color:black;font-size:12px;border:1px solid black;">'' );

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC msdb.dbo.sp_send_dbmail
     @recipients='ahmad@yahoo.com',
     @subject=@vSubject,
     @body=@Body,
	 --@body=@vBody,
     @body_format='HTML',
     @profile_name='Monitoring';
