unit uThreadEndereco;

interface

uses
  System.Classes,
  Windows, StrUtils, System.SysUtils, System.JSON, uControleEndereco,
  uClasseEndereco, uClasseCEP, uControleCEP, REST.Types;

type
  TThreadEndereco = class(TThread)
  private
    { Private declarations }
    FMetodo : TRESTRequestMethod;
  protected
    procedure Execute; override;
    procedure CargaEndereco(const ObjCep : TCEP; const ObjEndereco : TEndereco);

  public
    constructor Create(Metodo : TRESTRequestMethod);
  end;

implementation

uses uClasseAPI, uPrincipal;

{ ThreadEndereco }

procedure TThreadEndereco.CargaEndereco(const ObjCep : TCEP; const ObjEndereco : TEndereco);
var
  API : TAPI;
  JsonObj : TJSONObject;
  url : string;
begin
  API := TAPI.Create;
  url := 'viacep.com.br/ws/' + ObjCEP.CEP + '/json/';
  API.ConfigurarRestClient(Format('viacep.com.br/ws/%s/json/', [ObjCEP.CEP]));
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

constructor TThreadEndereco.Create(Metodo : TRESTRequestMethod);
begin
  inherited Create(False);
  //FreeOnTerminate := True;
  FMetodo := Metodo;
  Priority := TpLower;
  Execute;
  //Start;
end;

procedure TThreadEndereco.Execute;
var
  ObjCEP : TCEP;
  ObjEndereco : TEndereco;
  ObjControleCEP : TControleCEP;
  objControleEndereco: TControleEndereco;
begin
  ObjCEP              := TCEP.Create(frmPrincipal.IDEndereco);
  ObjEndereco         := TEndereco.Create;
  ObjControleCEP      := TControleCEP.Create;
  objControleEndereco := TControleEndereco.Create;

  ObjCEP.IDPessoa := StrToInt(frmPrincipal.edtCodigo.Text);
  ObjCEP.CEP      := frmPrincipal.edtCEP.Text;

  CargaEndereco(ObjCEP, ObjEndereco);

  case FMetodo of
    rmPOST: begin
              ObjControleCEP.Salvar(ObjCEP);
              objControleEndereco.Salvar(ObjEndereco);
            end;

    rmPUT: begin
             ObjControleCEP.Editar(ObjCEP);
             objControleEndereco.Editar(ObjEndereco);
           end;
  end;

  FreeAndNil(ObjCEP);
  FreeAndNil(ObjEndereco);
  FreeAndNil(ObjControleCEP);
  FreeAndNil(objControleEndereco);
end;

end.
