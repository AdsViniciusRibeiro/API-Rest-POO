program Client;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uPessoa in 'Model\uPessoa.pas',
  uClasseAPI in 'Model\uClasseAPI.pas',
  uClasseCEP in 'Model\uClasseCEP.pas',
  uClasseEndereco in 'Model\uClasseEndereco.pas',
  uControleCEP in 'Controller\uControleCEP.pas',
  uControlePessoa in 'Controller\uControlePessoa.pas',
  uControleEndereco in 'Controller\uControleEndereco.pas',
  uThreadEndereco in 'Model\uThreadEndereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
