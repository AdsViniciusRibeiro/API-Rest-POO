unit uClasseCEP;

interface
uses
  uPessoa, System.JSON, REST.Types, System.SysUtils;

type
  TCEP = class(TPessoa)
    private
    FIDEndereco: integer;
    FCEP: string;

    procedure SetIDEndereco(const Value: integer);
    procedure SetCEP(const Value: string);
    function GerarID : integer;

    const
      URLCEP    = 'http://localhost:8080/datasnap/rest/TServerMethods/CEP';
      URLPessoa = 'http://localhost:8080/datasnap/rest/TServerMethods/Pessoa';
      URLIDCEP  = 'http://localhost:8080/datasnap/rest/TServerMethods/RetornaMaiorIDCEP';

    public
      constructor Create(pIDEndereco : integer);
      destructor Destroy;
      function ObjetoToJson : WideString;
      procedure Salvar(const ObjCEP: TCEP);
      procedure Editar(const ObjCEP: TCEP);
      procedure Deletar(const ObjCEP: TCEP);
      procedure DeletarCliente(const ObjCEP: TCEP);
      procedure EnviaAPI(const ObjCEP: TCEP; Metodo : TRESTRequestMethod; URL : String; Parametro : WideString = '');

    published
      property IDEndereco : integer read FIDEndereco write SetIDEndereco;
      property CEP : string read FCEP write SetCEP;

  end;

implementation

{ TCEP }

uses uClasseAPI;

function TCEP.GerarID : integer;
var
  API : TAPI;
  JsonObj : TJSONObject;
begin
  API := TAPI.Create;
  API.ConfigurarRestClient(URLIDCEP);
  API.ConfigurarRestRequest(rmGET);
  API.ConfigurarRestResponse('application/json');
  API.ExecutarAPI;

  JsonObj := TJSONObject.Create;
  JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(API.JsonRetorno), 0) as TJSONObject;

  Result := JsonObj.GetValue<Integer>('maiorid');

  JsonObj.Free;
  API.Free;
end;

constructor TCEP.Create(pIDEndereco : integer);
begin
  if pIDEndereco = 0 then
   IDEndereco := GerarID
  else
    IDEndereco := pIDEndereco;
end;

procedure TCEP.Deletar(const ObjCEP: TCEP);
begin
  EnviaAPI(ObjCEP, rmDELETE, URLCEP, Concat(IntToStr(IDEndereco), '/', IntToStr(IDPessoa)));
end;

procedure TCEP.DeletarCliente(const ObjCEP: TCEP);
begin
  EnviaAPI(ObjCEP, rmDELETE, URLPessoa, IntToStr(ObjCEP.IDPessoa));
end;

destructor TCEP.Destroy;
begin
  Self.Free;
end;

function TCEP.ObjetoToJson: WideString;
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create;
  JSON.AddPair('IDEndereco', IntToStr(IDEndereco));
  JSON.AddPair('IDPessoa', IntToStr(IDPessoa));
  JSON.AddPair('CEP', CEP);

  Result := JSON.ToString;
  JSON.Free;
end;

procedure TCEP.Editar(const ObjCEP: TCEP);
begin
  EnviaAPI(ObjCEP, rmPUT, URLCEP, ObjetoToJson);
end;

procedure TCEP.EnviaAPI(const ObjCEP: TCEP; Metodo : TRESTRequestMethod; URL : String; Parametro : WideString = '');
var
  API : TAPI;
begin
  API := TAPI.Create;

  API.ConfigurarRestClient(URL);
  API.ConfigurarRestRequest(Metodo);
  API.ConfigurarRestResponse('application/json');
  API.ParametrosJson(Parametro);
  API.ExecutarAPI;

  API.Free;
end;

procedure TCEP.Salvar(const ObjCEP: TCEP);
begin
  EnviaAPI(ObjCEP, rmPOST, URLCEP, ObjetoToJson);
end;

procedure TCEP.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TCEP.SetIDEndereco(const Value: integer);
begin
  FIDEndereco := Value;
end;

end.
