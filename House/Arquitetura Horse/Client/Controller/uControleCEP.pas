unit uControleCEP;

interface

uses
  uClasseCEP, IdHTTP, Winapi.WinInet, System.JSON, StrUtils, System.SysUtils, REST.Types;

type
  TControleCEP = class

  public
    procedure Salvar(const ObjCEP: TCEP);
    procedure Editar(const ObjCEP: TCEP);
    procedure Excluir(const ObjCEP : TCEP);
    procedure ValidarCEP(const ObjCEP : TCEP);
    function CEPValido(const ObjCEP : TCEP) : boolean;
  end;

implementation

uses uClasseAPI;

function TControleCEP.CEPValido(const ObjCEP : TCEP): boolean;
var
  API : TAPI;
  JsonObj : TJSONObject;
begin
  API := TAPI.Create;
  API.ConfigurarRestClient('viacep.com.br/ws/' + ObjCEP.CEP + '/json/');
  API.ConfigurarRestRequest(rmGET);
  API.ConfigurarRestResponse('application/json');
  API.ExecutarAPI;

  JsonObj := TJSONObject.Create;
  JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(API.JsonRetorno), 0) as TJSONObject;

  Result := (API.CodigoRetonoJson = 200) and (JsonObj.Count > 1);

  JsonObj.Free;
  API.Free;
end;

procedure TControleCEP.Editar(const ObjCEP: TCEP);
begin
  ValidarCEP(ObjCEP);
  ObjCEP.Editar(ObjCEP);
end;

procedure TControleCEP.Excluir(const ObjCEP: TCEP);
begin
  ValidarCEP(ObjCEP);
  ObjCEP.Deletar(ObjCEP);
end;

procedure TControleCEP.Salvar(const ObjCEP: TCEP);
begin
  ValidarCEP(ObjCEP);
  ObjCEP.Salvar(ObjCEP);
end;

procedure TControleCEP.ValidarCEP(const ObjCEP: TCEP);
begin
  if ObjCEP.IDPessoa = 0 then
    raise Exception.Create('Preencha o código da Pessoa.');

  if not CEPValido(ObjCEP) then
  begin
    ObjCEP.DeletarCliente(ObjCEP);
    raise Exception.Create('CEP invalido.');
  end;
end;

end.
