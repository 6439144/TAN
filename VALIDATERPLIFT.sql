create or replace PROCEDURE VALIDATERPLIFT(INPUT_VAL IN XMLTYPE, STATUS_VAL OUT VARCHAR2) AS 
rrn VARCHAR2(100 CHAR);
pid VARCHAR2(100 CHAR);
status VARCHAR2(100 CHAR);
srvcCode VARCHAR2(100 CHAR);
amt float;
execSumID  number;
runTotCount number;
agcySrvcID number;
idNO  VARCHAR2(100 CHAR);
idType   VARCHAR2(100 CHAR);
NatCD  VARCHAR2(100 CHAR);
BEGIN

STATUS_VAL:='VALID';

DBMS_OUTPUT.PUT_LINE('VALIDATERPLIFT Starts');

/*
<ValidatePrevRPLift>
	<pid> </pid>
	<srn> </srn>
	<rrn> </rrn>
	<status> </status>
  	<invId> </invId>

	<idType> </idType>

	<nalty> </nalty>

</ValidatePrevRPLift>
*/



FOR r IN
      (SELECT ExtractValue(Value(p),'/ValidatePrevRPLift/pid/text()') AS  PID,
      ExtractValue(Value(p),'/ValidatePrevRPLift/srn/text()') As SRN,
      ExtractValue(Value(p),'/ValidatePrevRPLift/rrn/text()')  As RRN,
      ExtractValue(Value(p),'/ValidatePrevRPLift/status/text()')  As STATUS,
        ExtractValue(Value(p),'/ValidatePrevRPLift/amt/text()')  As AMT,
         ExtractValue(Value(p),'/ValidatePrevRPLift/invId/text()')  As INVID,
          ExtractValue(Value(p),'/ValidatePrevRPLift/idType/text()')  As IDTYPE,
           ExtractValue(Value(p),'/ValidatePrevRPLift/nalty/text()')  As NALTY
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/ValidatePrevRPLift'))) p)

   LOOP
   begin

SELECT  AGCY_SRVC_REQST_ID,RRN  , STATUS,REQSTR_CD,SRVC_TYPE_CD,CAST(AVAILABLE_AMT AS float) avail_amt,EXEC_SUMMARY_ID into agcySrvcID,rrn,status,pid,srvcCode,amt,execSumID
FROM EXEC_SUMMARY
WHERE EXEC_SUMMARY.SRVC_REQST_SRN = r.srn;
DBMS_OUTPUT.PUT_LINE('amt = ' ||  r.AMT);
IF (pid !=  r.pid)
THEN

STATUS_VAL:= 'INVALID_Requester_CD';


ELSif (status !=  r.status)
THEN
STATUS_VAL:= 'INVALID_Lift_Status';




ELSif ( r.AMT is not null )
then
DBMS_OUTPUT.PUT_LINE('amt cond');
if(r.AMT>amt)
then
STATUS_VAL:= 'INVALID_AMOUNT';
end if;


ELSif ( r.INVID is not null )
then
DBMS_OUTPUT.PUT_LINE('inv Party cond');

select ID_NO,ID_TYPE_CD,NAT_CD into idNO,idType,NatCD from INVOLVED_PARTY where INVOLVED_PARTY.AGCY_SRVC_REQST_ID=agcySrvcID;
if(r.INVID!=idNO)
then
STATUS_VAL:= 'INVALID_INV_ID';
elsif (r.IDTYPE!=idType)
then
STATUS_VAL:= 'INVALID_INV_IDTYPE';

elsif (r.NALTY is not NULL)
then
  if(r.NALTY!=NatCD)
  then
  STATUS_VAL:= 'INVALID_Nat';
  end if;

end if;


END IF;


if (STATUS_VAL =  'VALID')
then
DBMS_OUTPUT.PUT_LINE('Valid case return select ' || execSumID);
STATUS_VAL:='VALID,'||srvcCode||','||execSumID;
/*SELECT count(*) into runTotCount
FROM EXEC_RUNNING_TOTALS exTot
WHERE exTot.EXEC_SUMMARY_ID = execSumID;

if (runTotCount=1)
then
SELECT XMLELEMENT("exec_running_totals",XMLELEMENT("exec_running_totals_id",exTot.EXEC_RUNNING_TOTALS_ID),
XMLELEMENT("exec_summary_id",exTot.EXEC_SUMMARY_ID),
XMLELEMENT("fin_inst_cd",exTot.FIN_INST_CD),
XMLELEMENT("acc_num",exTot.ACC_NUM),
XMLELEMENT("acc_currency",exTot.ACC_CURRENCY),
XMLELEMENT("available_amt",exTot.AVAILABLE_AMT),
XMLELEMENT("available_amt",exTot.AVAILABLE_AMT),
XMLELEMENT("srvcCode",srvcCode)) .GETCLOBVAL()
into STATUS_VAL
FROM EXEC_RUNNING_TOTALS exTot
WHERE exTot.EXEC_SUMMARY_ID = execSumID;
elsif(runTotCount>1)
then
STATUS_VAL:=srvcCode;
end if;*/
END IF;



DBMS_OUTPUT.PUT_LINE('STATUS_VAL: ' || STATUS_VAL);

end;
END LOOP;

IF (STATUS_VAL = 'VALID')
THEN
DBMS_OUTPUT.PUT_LINE('Valid Record Deleted successfully');
END IF;



DBMS_OUTPUT.PUT_LINE('VALIDATERPLIFT Ends');

 EXCEPTION
 when no_data_found then
  STATUS_VAL:='INVALID_SRN';
	WHEN OTHERs THEN
		Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM); 
END VALIDATERPLIFT;