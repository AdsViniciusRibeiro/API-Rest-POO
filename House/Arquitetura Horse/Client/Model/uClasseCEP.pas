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

    const
      URLCEP    = 'http://localhost:8080/datasnap/rest/TServerMethods/CEP';
      URLPessoa = 'http://localhost:8080/datasnap/rest/TServerMethods/Pessoa';

    public
      constructor Create;
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

constructor TCEP.Create;
begin

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
