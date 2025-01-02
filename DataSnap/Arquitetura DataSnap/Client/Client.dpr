program Client;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPessoa},
  DataSetConverter4D.Helper in 'src\DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in 'src\DataSetConverter4D.Impl.pas',
  DataSetConverter4D in 'src\DataSetConverter4D.pas',
  DataSetConverter4D.Util in 'src\DataSetConverter4D.Util.pas',
  uControlerPessoa in 'Controller\uControlerPessoa.pas',
  uClassePessoa in 'Model\uClassePessoa.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPessoa, frmPessoa);
  Application.Run;
end.
