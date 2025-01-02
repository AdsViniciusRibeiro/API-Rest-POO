unit uConexao;
interface
uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Phys.PG,
  System.SysUtils;
type
  TConexaoPG = class
  private
    FConexao: TFDConnection;
    FDriverLink : TFDPhysPgDriverLink;

    procedure ConfigurarConexao;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConexao: TFDConnection;
    function CriarQuery: TFDQuery;
  end;
implementation
{ TConexao }

procedure TConexaoPG.ConfigurarConexao;
begin
  FConexao.Params.DriverID := 'PG';
  FConexao.Params.Database := 'Teste';
  FConexao.Params.UserName := 'postgres';
  FConexao.Params.Password := 'postgres';
  FConexao.LoginPrompt     := False;
  FDriverLink.VendorLib := ExtractFilePath(ParamStr(0)) + '\DLL\dll32\libpq.dll';
end;

constructor TConexaoPG.Create;
begin
  FConexao := TFDConnection.Create(nil);
  FDriverLink := TFDPhysPgDriverLink.Create(nil);
  Self.ConfigurarConexao();
  FConexao.Connected := True;
end;

function TConexaoPG.CriarQuery: TFDQuery;
var
  VQuery: TFDQuery;
begin
  VQuery := TFDQuery.Create(nil);
  VQuery.Connection:= GetConexao;
  Result := VQuery;
end;

destructor TConexaoPG.Destroy;
begin
  FConexao.Free;
  FDriverLink.Free;
  inherited;
end;

function TConexaoPG.GetConexao: TFDConnection;
begin
  FConexao.Create(nil);
  Result := FConexao;
end;

end.
