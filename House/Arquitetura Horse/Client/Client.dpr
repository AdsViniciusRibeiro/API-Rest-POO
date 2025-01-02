program Client;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {Form10},
  uClassePessoa in 'Model\uClassePessoa.pas',
  uControlerPessoa in 'Controller\uControlerPessoa.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPessoa, frmPessoa);
  Application.Run;
end.
