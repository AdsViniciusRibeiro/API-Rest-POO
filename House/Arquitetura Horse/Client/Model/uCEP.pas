unit uCEP;

interface
type
  TCEP = class
    private
    FIDEndereco: integer;
    FCEP: integer;
    FIDPessoa: integer;

    procedure SetIDEndereco(const Value: integer);
    procedure SetIDPessoa(const Value: integer);
    procedure SetCEP(const Value: integer);

    public
      property IDEndereco : integer read FIDEndereco write SetIDEndereco;
      property IDPessoa : integer read FIDPessoa write SetIDPessoa;
      property CEP : integer read FCEP write SetCEP;

      constructor Create;
  end;

implementation

{ TCEP }

constructor TCEP.Create;
begin

end;

procedure TCEP.SetCEP(const Value: integer);
begin
  FCEP := Value;
end;

procedure TCEP.SetIDEndereco(const Value: integer);
begin
  FIDEndereco := Value;
end;

procedure TCEP.SetIDPessoa(const Value: integer);
begin
  FIDPessoa := Value;
end;

end.
