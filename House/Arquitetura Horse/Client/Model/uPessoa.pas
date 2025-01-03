unit uPessoa;

interface
uses
  System.JSON, IdHTTP, System.SysUtils;

type
  TPessoa = class
  private
    FIDPessoa : Integer;
    FNatureza : Integer;
    FDocumento : string;
    FPrimeiroNome : string;
    FSegundoNome : string;
    FDataRegistro : TDateTime;
    FCEP : string;
    FURL: string;

    const
      URLBase : string = 'http://localhost:8080/datasnap/rest/TServerMethods/Pessoa';

    procedure SetPrimeiroNome(const Value: string);
    procedure SetCEP(const Value: string);
    procedure SetDataRegistro(const Value: TDateTime);
    procedure SetDocumento(const Value: string);
    procedure SetIDPessoa(const Value: Integer);
    procedure SetNatureza(const Value: Integer);
    procedure SetSegundoNome(const Value: string);
    procedure SetURL(const Value: string);

  public
    property IDPessoa: Integer read FIDPessoa write SetIDPessoa;
    property Natureza: Integer read FNatureza write SetNatureza;
    property Documento: string read FDocumento write SetDocumento;
    property PrimeiroNome: string read FPrimeiroNome write SetPrimeiroNome;
    property SegundoNome: string read FSegundoNome write SetSegundoNome;
    property DataRegistro: TDateTime read FDataRegistro write SetDataRegistro;
    property CEP: string read FCEP write SetCEP;
    property URL : string read FURL write SetURL;

    constructor Create;
    destructor Destroy;
    function EnviaAPI(Metodo : string) : boolean;
    procedure Salvar(const ObjPessoa: TPessoa);
    procedure Editar(const ObjPessoa: TPessoa);
    procedure Deletar(const ObjPessoa: TPessoa);

  end;

implementation

{ TPessoa }

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

procedure TPessoa.SetCEP(const Value: string);
begin
  FCEP := Value;
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

procedure TPessoa.Deletar(const ObjPessoa: TPessoa);
begin

end;

destructor TPessoa.Destroy;
begin
  Self.Free;
end;

procedure TPessoa.Editar(const ObjPessoa: TPessoa);
begin

end;

function TPessoa.EnviaAPI(Metodo : string): boolean;
var
  HTTP: TIdHTTP;
  JSON: TJSONObject;
begin
  // Criar um objeto HTTP
  HTTP := TIdHTTP.Create(nil);
  try
    // Configurar o objeto HTTP
    HTTP.Request.ContentType := 'application/json';
    HTTP.HandleRedirects := True;

    JSON.AddPair('IDPessoa', IntToStr(IDPessoa));
    JSON.AddPair('Natureza', IntToStr(Natureza));
    JSON.AddPair('Documento', Documento);
    JSON.AddPair('PrimeiroNome', PrimeiroNome);
    JSON.AddPair('SegundoNome', SegundoNome);
    JSON.AddPair('DataRegistro', DateToStr(DataRegistro));

    // Enviar a requisição POST
    HTTP.Post('http://localhost:8080/datasnap/rest/TServerMethods/Pessoa', JSON.ToString);

    // Processar a resposta (opcional)
    // ...
  finally
    HTTP.Free;
  end;
end;

procedure TPessoa.Salvar(const ObjPessoa: TPessoa);
{var
  jsonObject: TJSONObject;}
begin
  EnviaAPI('Post');
  // a rotina para salvar o cliente no banco de dados deve ser escrita aqui
  {jsonObject := TJSONObject.Create;
  jsonObject.AddPair('Name', TJSONValue.CreateString(person.Name));
  jsonObject.AddPair('Age', TJSONValue.CreateNumber(person.Age));}
end;

end.
