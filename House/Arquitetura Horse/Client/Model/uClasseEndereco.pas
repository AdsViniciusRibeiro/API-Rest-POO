unit uClasseEndereco;

interface
uses
  uClasseCEP, System.JSON, REST.Types, System.SysUtils;

type
  TEndereco = class(TCEP)
  private
    FLogradouro: string;
    FBairro: string;
    FUF: string;
    FComplemento: string;
    FCidade: string;

    procedure SetBairro(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetComplemento(const Value: string);
    procedure SetLogradouro(const Value: string);
    procedure SetUF(const Value: string);

    public
      constructor Create;
      destructor Destroy;
      function ObjetoToJson : WideString;
      procedure Salvar(const ObjEndereco: TEndereco);
      procedure ValidarCEP(const ObjEndereco : TEndereco);
      procedure EnviaAPI(const ObjCEP: TEndereco; Metodo : TRESTRequestMethod; Parametro : WideString);

    published
      //property IDEndereco : integer read FIDEndereco write SetIDEndereco;
      property UF : string read FUF write SetUF;
      property Cidade : string read FCidade write SetCidade;
      property Bairro : string read FBairro write SetBairro;
      property Logradouro : string read FLogradouro write SetLogradouro;
      property Complemento : string read FComplemento write SetComplemento;
  end;


implementation

{ TEndereco }

uses uClasseAPI;

constructor TEndereco.Create;
var
  API : TAPI;
  JsonObj : TJSONObject;
begin
 { API := TAPI.Create;

  API.ConfigurarRestClient(Format('http://viacep.com.br/ws/%s/json/', [CEP]));
  API.ConfigurarRestRequest(rmGET);
  API.ConfigurarRestResponse('application/json');
  API.ExecutarAPI;

  JsonObj := TJSONObject.Create;
  JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(API.JsonRetorno), 0) as TJSONObject;

  if JsonObj.Count > 1 then
  begin
    TEndereco.
    FLogradouro  := JsonObj.GetValue<string>('logradouro');
    FBairro      := JsonObj.GetValue<string>('bairro');
    FUF          := JsonObj.GetValue<string>('uf');
    FComplemento := JsonObj.GetValue<string>('complemento');
    FCidade      := JsonObj.GetValue<string>('localidade');
  end;

  JsonObj.Free;
  API.Free; }
end;

destructor TEndereco.Destroy;
begin
  Self.Free;
end;

procedure TEndereco.EnviaAPI(const ObjCEP: TEndereco;
  Metodo: TRESTRequestMethod; Parametro: WideString);
var
  API : TAPI;
begin
  API := TAPI.Create;

  API.ConfigurarRestClient('http://localhost:8080/datasnap/rest/TServerMethods/Endereco');
  API.ConfigurarRestRequest(Metodo);
  API.ConfigurarRestResponse('application/json');
  API.ParametrosJson(Parametro);
  API.ExecutarAPI;

  API.Free;
end;

function TEndereco.ObjetoToJson: WideString;
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create;
  JSON.AddPair('IDEndereco', IntToStr(IDEndereco));
  JSON.AddPair('Logradouro', Logradouro);
  JSON.AddPair('Bairro', Bairro);
  JSON.AddPair('UF', UF);
  JSON.AddPair('Complemento', Complemento);
  JSON.AddPair('Cidade', Cidade);

  Result := JSON.ToString;
  JSON.Free;
end;

procedure TEndereco.Salvar(const ObjEndereco: TEndereco);
begin
  EnviaAPI(ObjEndereco, rmPOST, ObjetoToJson);
end;

procedure TEndereco.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TEndereco.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TEndereco.SetComplemento(const Value: string);
begin
  FComplemento := Value;
end;

procedure TEndereco.SetLogradouro(const Value: string);
begin
  FLogradouro := Value;
end;

procedure TEndereco.SetUF(const Value: string);
begin
  FUF := Value;
end;

procedure TEndereco.ValidarCEP(const ObjEndereco: TEndereco);
begin
  EnviaAPI(ObjEndereco, rmGET, ObjetoToJson);
end;

end.
