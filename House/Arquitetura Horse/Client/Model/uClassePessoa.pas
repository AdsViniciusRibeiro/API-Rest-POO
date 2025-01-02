unit uClassePessoa;

interface

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

    procedure SetPrimeiroNome(const Value: string);
    procedure SetCEP(const Value: string);
    procedure SetDataRegistro(const Value: TDateTime);
    procedure SetDocumento(const Value: string);
    procedure SetIDPessoa(const Value: Integer);
    procedure SetNatureza(const Value: Integer);
    procedure SetSegundoNome(const Value: string);

  public
    property IDPessoa: Integer read FIDPessoa write SetIDPessoa;
    property Natureza: Integer read FNatureza write SetNatureza;
    property Documento: string read FDocumento write SetDocumento;
    property PrimeiroNome: string read FPrimeiroNome write SetPrimeiroNome;
    property SegundoNome: string read FSegundoNome write SetSegundoNome;
    property DataRegistro: TDateTime read FDataRegistro write SetDataRegistro;
    property CEP: string read FCEP write SetCEP;

    constructor Create;
    procedure Salvar(const ObjPessoa: TPessoa);

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

procedure TPessoa.Salvar(const ObjPessoa: TPessoa);//(const ObjPessoa : TPessoa);
{var
  jsonObject: TJSONObject;}
begin
  // a rotina para salvar o cliente no banco de dados deve ser escrita aqui
  {jsonObject := TJSONObject.Create;
  jsonObject.AddPair('Name', TJSONValue.CreateString(person.Name));
  jsonObject.AddPair('Age', TJSONValue.CreateNumber(person.Age));}
end;

end.
