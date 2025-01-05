unit uControlePessoa;

interface

uses
  uPessoa;

type
  TControlePessoa = class

  public
    procedure Salvar(const ObjPessoa: TPessoa);
    procedure Editar(const ObjPessoa: TPessoa);
    procedure Excluir(const ObjPessoa : TPessoa);
    procedure ValidarPessoa(const ObjPessoa : TPessoa);
  end;

implementation

uses
  SysUtils, REST.Types, System.StrUtils;

{ uControlePessoa }

procedure TControlePessoa.Excluir(const ObjPessoa: TPessoa);
begin
  ValidarPessoa(ObjPessoa);
  ObjPessoa.Deletar(ObjPessoa);
end;

procedure TControlePessoa.Editar(const ObjPessoa: TPessoa);
begin
  ValidarPessoa(ObjPessoa);
  ObjPessoa.Editar(ObjPessoa);
end;

procedure TControlePessoa.Salvar(const ObjPessoa: TPessoa);
begin
  ValidarPessoa(ObjPessoa);
  ObjPessoa.Salvar(ObjPessoa);
end;

procedure TControlePessoa.ValidarPessoa(const ObjPessoa : TPessoa);
begin
  if ObjPessoa.IDPessoa = 0 then
    raise Exception.Create('Preencha o código da Pessoa.');

  if ObjPessoa.Natureza = 0 then
    raise Exception.Create('Preencha a Natureza.');

  if ObjPessoa.Documento = '' then
    raise Exception.Create('Preencha o documento.');

  if ObjPessoa.PrimeiroNome = '' then
    raise Exception.Create('Preencha o primeiro nome.');

  if ObjPessoa.SegundoNome = '' then
    raise Exception.Create('Preencha o segundo nome.');

  if ObjPessoa.DataRegistro = 0 then
    raise Exception.Create('Preencha a data de registro.');
end;

end.
