program Server;

uses
  Vcl.Forms,
  Main.Form in 'src\Main.Form.pas' {FrmVCL},
  uEndereco in 'src\uEndereco.pas',
  uPessoa in 'src\uPessoa.pas',
  uConexao in 'Model\uConexao.pas',
  uConveterDataSet in 'Model\uConveterDataSet.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmVCL, FrmVCL);
  Application.Run;
end.
