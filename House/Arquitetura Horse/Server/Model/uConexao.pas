unit uConexao;
interface
uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Phys.PG,
  System.SysUtils, System.JSON, DataSetConverter4D.Impl;
type
  TConexaoPG = class
  private
    FConexao: TFDConnection;
    FDriverLink : TFDPhysPgDriverLink;
    Qry : TFDQuery;

    procedure ConfigurarConexao;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConexao: TFDConnection;
    function CriarQuery: TFDQuery;
    function ExecutarScript(Script : string; Parametros : array of Variant; MsgErro : string = 'Erro ao gravar Script.') : Boolean;
    function DataSetToJson(Script: string; Parametros: array of Variant; MsgErro : string = 'Erro ao gravar Script.'): TJSONArray;
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
  FDriverLink.VendorLib    := '..\..\..\DLL\dll32\libpq.dll';
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

function TConexaoPG.ExecutarScript(Script: string; Parametros: array of Variant; MsgErro : string = 'Erro ao gravar Script.'): Boolean;
begin
  Qry := TFDQuery.Create(nil);
  Qry.Connection := GetConexao;

  Result := False;
  try
    Qry.ExecSQL(Script, Parametros);
  except on E: Exception do
    raise Exception.Create('Erro ao gravar Script.');
  end;

  Result := True;
  Qry.Free;
end;

function TConexaoPG.DataSetToJson(Script: string; Parametros: array of Variant; MsgErro : string = 'Erro ao gravar Script.'): TJSONArray;
begin
  Qry := TFDQuery.Create(nil);
  Qry.Connection := GetConexao;

  try
    Qry.Open(Script, Parametros);

    Result :=  TConverter.New.DataSet(Qry).AsJSONArray
  except on E: Exception do
    raise Exception.Create('Erro ao gravar Script.');
  end;

  Qry.Free;
end;

function TConexaoPG.GetConexao: TFDConnection;
begin
  FConexao.Create(nil);
  Result := FConexao;
end;

end.
