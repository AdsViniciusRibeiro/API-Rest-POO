program Server;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uPrincipal in 'uPrincipal.pas' {Servidor},
  ServerMethods in 'ServerMethods.pas',
  ServerContainer in 'ServerContainer.pas' {ServerContainer1: TDataModule},
  WebModule in 'WebModule.pas' {WebModule1: TWebModule},
  uPessoa in 'uPessoa.pas',
  uEndereco in 'uEndereco.pas',
  uConexao in 'Model\uConexao.pas',
  uConveterDataSet in 'Model\uConveterDataSet.pas',
  DataSetConverter4D.Helper in 'src\DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in 'src\DataSetConverter4D.Impl.pas',
  DataSetConverter4D in 'src\DataSetConverter4D.pas',
  DataSetConverter4D.Util in 'src\DataSetConverter4D.Util.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TServidor, Servidor);
  Application.Run;
end.
