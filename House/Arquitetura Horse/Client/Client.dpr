program Client;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {Form10},
  uPessoa in 'Model\uPessoa.pas',
  uClasseAPI in 'Model\uClasseAPI.pas',
  uClasseCEP in 'Model\uClasseCEP.pas',
  uClasseEndereco in 'Model\uClasseEndereco.pas',
  uControleCEP in 'Controller\uControleCEP.pas',
  uControlePessoa in 'Controller\uControlePessoa.pas',
  uControleEndereco in 'Controller\uControleEndereco.pas',
  uClasseThreadEndereco in 'Model\uClasseThreadEndereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPessoa, frmPessoa);
  Application.Run;
end.
