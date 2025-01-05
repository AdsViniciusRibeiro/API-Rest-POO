unit uPessoa;

interface
uses
  System.JSON, REST.Types, System.SysUtils;

type
  TPessoa = class
  private
    FIDPessoa : Integer;
    FNatureza : Integer;
    FDocumento : string;
    FPrimeiroNome : string;
    FSegundoNome : string;
    FDataRegistro : TDateTime;

    procedure SetPrimeiroNome(const Value: string);
    procedure SetDataRegistro(const Value: TDateTime);
    procedure SetDocumento(const Value: string);
    procedure SetIDPessoa(const Value: Integer);
    procedure SetNatureza(const Value: Integer);
    procedure SetSegundoNome(const Value: string);

  public
    constructor Create;
    destructor Destroy;
    function ObjetoToJson : WideString;
    procedure Salvar(const ObjPessoa: TPessoa);
    procedure Editar(const ObjPessoa: TPessoa);
    procedure Deletar(const ObjPessoa: TPessoa);
    procedure EnviaAPI(const ObjPessoa : TPessoa; Metodo : TRESTRequestMethod; Parametro : WideString);

  published
    property IDPessoa: Integer read FIDPessoa write SetIDPessoa;
    property Natureza: Integer read FNatureza write SetNatureza;
    property Documento: string read FDocumento write SetDocumento;
    property PrimeiroNome: string read FPrimeiroNome write SetPrimeiroNome;
    property SegundoNome: string read FSegundoNome write SetSegundoNome;
    property DataRegistro: TDateTime read FDataRegistro write SetDataRegistro;

  end;

implementation

{ TPessoa }

uses uClasseAPI;

procedure TPessoa.EnviaAPI(const ObjPessoa: TPessoa; Metodo : TRESTRequestMethod; Parametro : WideString);
var
  API : TAPI;
begin
  API := TAPI.Create;

  API.ConfigurarRestClient('http://localhost:8080/datasnap/rest/TServerMethods/Pessoa');
  API.ConfigurarRestRequest(Metodo);
  API.ConfigurarRestResponse('application/json');
  API.ParametrosJson(Parametro);
  API.ExecutarAPI;

  API.Free;
end;

constructor TPessoa.Create;
begin
  // inicialização dos valores do objeto
  {FIDPessoa := 0;
  FNatureza := 0;
  FDocumento := '';
  FPrimeiroNome := '';
  FSegundoNome := '';
  FDataRegistro := '';
  FCEP := ''; }
end;

procedure TPessoa.SetDataRegistro(const Value: TDateTime);
begin
  FDataRegistro := Value;
end;

procedure TPessoa.SetDocumento(const Value: string);
begin
  FDocumento := Value;
end;

procedure TPessoa.SetIDPessoa(const Value: Integer);
begin
  FIDPessoa := Value;
end;

procedure TPessoa.SetNatureza(const Value: Integer);
begin
  FNatureza := Value;
end;

procedure TPessoa.SetPrimeiroNome(const Value: string);
begin
  FPrimeiroNome := Value;
end;

procedure TPessoa.SetSegundoNome(const Value: string);
begin
  FSegundoNome := Value;
end;

destructor TPessoa.Destroy;
begin
  Self.Free;
end;

function TPessoa.ObjetoToJson: WideString;
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create;
  JSON.AddPair('IDPessoa', IntToStr(IDPessoa));
  JSON.AddPair('Natureza', IntToStr(Natureza));
  JSON.AddPair('Documento', Documento);
  JSON.AddPair('PrimeiroNome', PrimeiroNome);
  JSON.AddPair('SegundoNome', SegundoNome);
  JSON.AddPair('DataRegistro', DateToStr(DataRegistro));

  Result := JSON.ToString;
  JSON.Free;
end;

procedure TPessoa.Deletar(const ObjPessoa: TPessoa);
begin
  EnviaAPI(ObjPessoa, rmDELETE, IntToStr(FIDPessoa));
end;

procedure TPessoa.Editar(const ObjPessoa: TPessoa);
begin
  EnviaAPI(ObjPessoa, rmPUT, ObjetoToJson);
end;

procedure TPessoa.Salvar(const ObjPessoa: TPessoa);
begin
  EnviaAPI(ObjPessoa, rmPOST, ObjetoToJson);
end;

end.
