unit uClasseThreadEndereco;

interface

uses
  System.Classes,
  Windows, StrUtils, System.SysUtils, System.JSON, uPrincipal, uControleEndereco,
  uClasseEndereco, uClasseCEP, uControleCEP, REST.Types;

type
  TThreadEndereco = class(TThread)
  private
    var
      objControleEndereco: TControleEndereco;
      ObjControleCEP : TControleCEP;
      ObjEndereco : TEndereco;
      ObjCEP : TCEP;
  protected
    procedure Execute; override;
    procedure CargaEndereco;
  public
    constructor Create;
    destructor Destroy;
  end;

implementation

//uses uPrincipal, uControleEndereco, uClasseEndereco, uClasseCEP, uControleCEP;


uses uClasseAPI;

procedure TThreadEndereco.CargaEndereco;
var
  API : TAPI;
  JsonObj : TJSONObject;
begin
  API := TAPI.Create;

  API.ConfigurarRestClient(Format('http://viacep.com.br/ws/%s/json/', [ObjCEP.CEP]));
  API.ConfigurarRestRequest(rmGET);
  API.ConfigurarRestResponse('application/json');
  API.ExecutarAPI;

  JsonObj := TJSONObject.Create;
  JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(API.JsonRetorno), 0) as TJSONObject;

  if JsonObj.Count > 1 then
  begin
    ObjEndereco.IDEndereco  := ObjCEP.IDEndereco;
    ObjEndereco.Logradouro  := JsonObj.GetValue<string>('logradouro');
    ObjEndereco.Bairro      := JsonObj.GetValue<string>('bairro');
    ObjEndereco.UF          := JsonObj.GetValue<string>('uf');
    ObjEndereco.Complemento := JsonObj.GetValue<string>('complemento');
    ObjEndereco.Cidade      := JsonObj.GetValue<string>('localidade');
  end;

  JsonObj.Free;
  API.Free;
end;

constructor TThreadEndereco.Create;
begin
  inherited;
  ObjCEP              := TCEP.Create;
  ObjEndereco         := TEndereco.Create;
  ObjControleCEP      := TControleCEP.Create;
  objControleEndereco := TControleEndereco.Create;

  FreeOnTerminate := True; // Libera a thread automaticamente quando terminar
end;

destructor TThreadEndereco.Destroy;
begin
  ObjCEP.Free;
  ObjEndereco.Free;
  ObjControleCEP.Free;
  objControleEndereco.Free;
end;

procedure TThreadEndereco.Execute;
begin
  Synchronize(
      procedure
      begin
        ObjCEP.IDPessoa  := StrToInt(frmPessoa.edtCodigo.Text);
        ObjCEP.CEP       := frmPessoa.edtCEP.Text;
        CargaEndereco;

        ObjControleCEP.Salvar(ObjCEP);
        objControleEndereco.Salvar(ObjEndereco);
      end
    );

end;

end.
