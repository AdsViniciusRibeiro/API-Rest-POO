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
    FURLID: string;
    FURL: string;

    procedure SetPrimeiroNome(const Value: string);
    procedure SetDataRegistro(const Value: TDateTime);
    procedure SetDocumento(const Value: string);
    procedure SetIDPessoa(const Value: Integer);
    procedure SetNatureza(const Value: Integer);
    procedure SetSegundoNome(const Value: string);
    procedure SetURL(const Value: string);
    procedure SetURLID(const Value: string);

    const
      sURL   = 'http://localhost:8080/datasnap/rest/TServerMethods/Pessoa';
      sURLID = 'http://localhost:8080/datasnap/rest/TServerMethods/RetornaMaiorIDPessoa';

  public
    constructor Create;
    destructor Destroy;
    function ObjetoToJson : WideString;
    procedure Salvar(const ObjPessoa: TPessoa);
    procedure Editar(const ObjPessoa: TPessoa);
    procedure Deletar(const ObjPessoa: TPessoa);
    function EnviaAPI(const ObjPessoa: TPessoa; Metodo : TRESTRequestMethod; pURL : String; Parametro : WideString = '') : WideString;

  published
    property IDPessoa: Integer read FIDPessoa write SetIDPessoa;
    property Natureza: Integer read FNatureza write SetNatureza;
    property Documento: string read FDocumento write SetDocumento;
    property PrimeiroNome: string read FPrimeiroNome write SetPrimeiroNome;
    property SegundoNome: string read FSegundoNome write SetSegundoNome;
    property DataRegistro: TDateTime read FDataRegistro write SetDataRegistro;
    property URL : string read FURL write SetURL;
    property URLID : string read FURLID write SetURLID;

  end;

implementation

{ TPessoa }

uses uClasseAPI;

function TPessoa.EnviaAPI(const ObjPessoa: TPessoa; Metodo : TRESTRequestMethod; pURL : String; Parametro : WideString = '') : WideString;
var
  API : TAPI;
begin
  API := TAPI.Create;

  API.ConfigurarRestClient(pURL);
  API.ConfigurarRestRequest(Metodo);
  API.ConfigurarRestResponse('application/json');
  API.ParametrosJson(Parametro);
  API.ExecutarAPI;

  Result := API.JsonRetorno;

  API.Free;
end;

constructor TPessoa.Create;
begin
  URL := sURL;
  URLID := sURLID;
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

procedure TPessoa.SetURL(const Value: string);
begin
  FURL := Value;
end;

procedure TPessoa.SetURLID(const Value: string);
begin
  FURLID := Value;
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
  EnviaAPI(ObjPessoa, rmDELETE, sURL, IntToStr(FIDPessoa));
end;

procedure TPessoa.Editar(const ObjPessoa: TPessoa);
begin
  EnviaAPI(ObjPessoa, rmPUT, sURL,ObjetoToJson);
end;

procedure TPessoa.Salvar(const ObjPessoa: TPessoa);
begin
  EnviaAPI(ObjPessoa, rmPOST, sURL, ObjetoToJson);
end;

end.
