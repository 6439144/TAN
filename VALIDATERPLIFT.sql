


create or replace PROCEDURE VALIDATERPLIFT(INPUT_VAL IN XMLTYPE, STATUS_VAL OUT VARCHAR2) AS 
rrn VARCHAR2(100 CHAR);
pid VARCHAR2(100 CHAR);
status VARCHAR2(100 CHAR);
BEGIN

STATUS_VAL:='VALID';

DBMS_OUTPUT.PUT_LINE('VALIDATERPLIFT Starts');

/*
<ValidatePrevRPLift>
	<pid> </pid>
	<srn> </srn>
	<rrn> </rrn>
	<status> </status>
</ValidatePrevRPLift>
*/



FOR r IN
      (SELECT ExtractValue(Value(p),'/ValidatePrevRPLift/pid/text()') AS  PID,
      ExtractValue(Value(p),'/ValidatePrevRPLift/srn/text()') As SRN,
      ExtractValue(Value(p),'/ValidatePrevRPLift/rrn/text()')  As RRN,
      ExtractValue(Value(p),'/ValidatePrevRPLift/status/text()')  As STATUS
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/ValidatePrevRPLift'))) p)

   LOOP
   begin

SELECT RRN  , STATUS,REQSTR_CD into rrn,status,pid
FROM EXEC_SUMMARY
WHERE EXEC_SUMMARY.SRVC_REQST_SRN = r.srn;

IF (rrn !=  r.rrn)
THEN

STATUS_VAL:= 'INVALID_RRN';

ELSIF (pid !=  r.pid)
THEN
STATUS_VAL:= 'INVALID_Requester_CD';


ELSif (status !=  r.status)
THEN
STATUS_VAL:= 'INVALID_Lift_Status';
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