unit uControlerPessoa;

interface

uses
  uPessoa;

type
  TControlePessoa = class

  public
    // procedimento para salvar o cliente
    procedure Salvar(const ObjPessoa: TPessoa);
  end;

implementation

uses
  SysUtils, REST.Types, System.StrUtils;

{ TControleCliente }

procedure TControlePessoa.Salvar(const ObjPessoa: TPessoa);
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

  if ObjPessoa.CEP = '' then
    raise Exception.Create('Preencha o CEP.');

  // se o objeto for válido, o método Salvar é invocado
  ObjPessoa.Salvar(ObjPessoa);
end;

end.
