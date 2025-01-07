unit uControleEndereco;

interface

uses
  uClasseEndereco;

type
  TControleEndereco = class

  public
    procedure Salvar(const ObjEndereco: TEndereco);
    procedure Editar(const ObjEndereco: TEndereco);
    procedure ValidarEndereco(const ObjEndereco : TEndereco);
  end;

implementation

uses
  SysUtils, REST.Types, System.StrUtils;

{ uControlerPessoa }

procedure TControleEndereco.Salvar(const ObjEndereco: TEndereco);
begin
  ValidarEndereco(ObjEndereco);
  ObjEndereco.Salvar(ObjEndereco);
end;

procedure TControleEndereco.Editar(const ObjEndereco: TEndereco);
begin
  ValidarEndereco(ObjEndereco);
  ObjEndereco.Editar(ObjEndereco);
end;

procedure TControleEndereco.ValidarEndereco(const ObjEndereco : TEndereco);
begin
  if ObjEndereco.IDEndereco = 0 then
    raise Exception.Create('Preencha o código do endereço.');

  if ObjEndereco.UF = '' then
    raise Exception.Create('Preencha a UF.');

  if ObjEndereco.Cidade = '' then
    raise Exception.Create('Preencha a Cidade.');

  if ObjEndereco.Bairro = '' then
    raise Exception.Create('Preencha o Bairro.');

  if ObjEndereco.Logradouro = '' then
    raise Exception.Create('Preencha o Logradouro.');
end;

end.
