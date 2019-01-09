create or replace PACKAGE GLOBAL_CONSTANTS AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
  INSERT_DENY_RQST_SP VARCHAR2(20) := '007';
  INSERT_BAN_RQST_SP VARCHAR2(20) := '008';
  INSERT_LIFT_RQST_SP VARCHAR2(20) := '009';
  INSERT_BLOCK_RQST_SP VARCHAR2(20) := '010';
  INSERT_GARNISH_RQST_SP VARCHAR2(20) := '011';
  INSERT_GI_RQST_SP VARCHAR2(20) := '001';

  INSERT_DENY_RESP_SP VARCHAR2(20) := '007-01';
  INSERT_BAN_RESP_SP VARCHAR2(20) := '008-01';
  INSERT_LIFT_RESP_SP VARCHAR2(20) := '009-01';
  INSERT_BLOCK_RESP_SP VARCHAR2(20) := '010-01';
  INSERT_GARNISH_RESP_SP VARCHAR2(20) := '011-01';
  INSERT_GI_RESP_SP VARCHAR2(20) := '001-01';

  UPDATE_COMMON_RQST_DETAILS_SP VARCHAR(20) := '000-01';
  INSERT_EXEC_SUMMARY_SP VARCHAR(20) := '000-02';
  INSERT_EXEC_RUNNING_TOTAL_SP VARCHAR(20) := '000-03';


   VALIDATE_DENY_DISPATCH_SP VARCHAR(20) := '007-02';
   VALIDATE_BAN_DISPATCH_SP VARCHAR(20) := '008-02';
   VALIDATE_LIFT_DISPATCH_SP VARCHAR(20) := '009-02';
  VALIDATE_BLOCK_DISPATCH_SP VARCHAR(20) := '010-02';
  VALIDATE_GARNISH_DISPATCH_SP VARCHAR(20) := '011-02';
  VALIDATE_GI_DISPATCH_SP VARCHAR(20) := '012-02';
 

  INSERT_FI_DENY_SUM_VALID_SP VARCHAR(20) := '007-03';
   INSERT_FI_BAN_SUM_VALID_SP VARCHAR(20) := '008-03';
  INSERT_FI_LIFT_SUM_VALID_SP VARCHAR(20) := '009-03';
  INSERT_FI_BLOCK_SUM_VALID_SP VARCHAR(20) := '010-03';
   INSERT_FI_GARNISH_SUM_VALID_SP VARCHAR(20) := '010-03';
   
   INSERT_FI_GI_SUM_VALID_SP VARCHAR(20) := '001-03';

  VALIDATERPLIFT varchar(20):='009-04';

  PERSON_PARTY_CD VARCHAR2(20) := 'IND';
  COMPANY_PARTY_CD VARCHAR2(20) := 'CES';
  CHARITY_PARTY_CD VARCHAR2(20) := 'CAP';
  GOV_PARTY_CD VARCHAR2(20) := 'GOV';
  CHAMBER_PARTY_CD VARCHAR2(20) := 'COC';

END GLOBAL_CONSTANTS;