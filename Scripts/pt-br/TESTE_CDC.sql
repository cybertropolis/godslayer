DECLARE
  P_ESQUEMA     IN VARCHAR2, P_TABELA IN VARCHAR2, P_OPERACAO IN NUMBER, P_ID IN NUMBER, P_CONTEUDO IN VARCHAR2) IS V_REQUEST UTL_HTTP.REQ;
  V_RESPONSE    UTL_HTTP.RESP;
  V_BROKER_ID   REPLICACAO.BROKER.ID%TYPE;
  V_BROKER_HOST REPLICACAO.BROKER.HOST%TYPE;
  V_CONTEUDO    VARCHAR2(4000);
  V_HTTP_METHOD VARCHAR2(10);
BEGIN
  V_CONTEUDO := '{ "Schema": "' || P_ESQUEMA || '", "Table": "' || P_TABELA ||
                '", "Id": "' || TO_CHAR(P_ID) || '", "Value": "' ||
                P_CONTEUDO || '" }';

  BEGIN
    SELECT ID, HOST
      INTO V_BROKER_ID, V_BROKER_HOST
      FROM REPLICACAO.BROKER
     ORDER BY DATA_ESCALONAMENTO DESC FETCH FIRST ROW ONLY;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('');
  END;

  IF P_OPERACAO = 1 THEN
    V_HTTP_METHOD := 'POST';
  ELSIF P_OPERACAO = 2 THEN
    V_HTTP_METHOD := 'PUT';
  ELSIF P_OPERACAO = 3 THEN
    V_HTTP_METHOD := 'DELETE';
    V_BROKER_HOST := V_BROKER_HOST || '/' || P_ESQUEMA || '/' || P_TABELA || '/' || P_ID;
  END IF;

  V_REQUEST := UTL_HTTP.BEGIN_REQUEST(V_BROKER_HOST,
                                      V_HTTP_METHOD,
                                      UTL_HTTP.HTTP_VERSION_1_1);

  IF P_OPERACAO != 3 THEN
    UTL_HTTP.SET_BODY_CHARSET('UTF-8');
    UTL_HTTP.SET_HEADER(V_REQUEST,
                        'Content-Type',
                        'application/json;charset=UTF-8');
    UTL_HTTP.SET_HEADER(V_REQUEST, 'Content-Length', LENGTH(V_CONTEUDO));
    UTL_HTTP.WRITE_TEXT(V_REQUEST, V_CONTEUDO);
  END IF;

  V_RESPONSE := UTL_HTTP.GET_RESPONSE(V_REQUEST);

  UTL_HTTP.END_RESPONSE(V_RESPONSE);

  UPDATE REPLICACAO.BROKER
     SET DATA_ESCALONAMENTO = SYSTIMESTAMP
   WHERE ID = V_BROKER_ID;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('');
  
    UTL_HTTP.END_RESPONSE(V_RESPONSE);
END;
