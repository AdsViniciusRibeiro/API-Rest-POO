program Client;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {Form10},
  uControlerPessoa in 'Controller\uControlerPessoa.pas',
  uPessoa in 'Model\uPessoa.pas',
  uCEP in 'Model\uCEP.pas',
  uControlerCEP in 'Controller\uControlerCEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPessoa, frmPessoa);
  Application.Run;
end.
