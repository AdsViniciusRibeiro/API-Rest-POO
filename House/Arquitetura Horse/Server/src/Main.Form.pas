unit Main.Form;

interface

uses Winapi.Windows, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Buttons, System.SysUtils, FireDAC.Comp.Client, uConexao, DataSetConverter4D, DataSetConverter4D.Impl;

type
  TFrmVCL = class(TForm)
    btnStop: TBitBtn;
    btnStart: TBitBtn;
    Label1: TLabel;
    edtPort: TEdit;
    procedure btnStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Status;
    procedure Start;
    procedure Stop;

    var
      TConexao : TConexaoPG;
  end;

var
  FrmVCL: TFrmVCL;

implementation

uses
  Horse, Horse.Jhonson, System.JSON, System.StrUtils, Rest.JSON, uPessoa, uEndereco;

{$R *.dfm}

procedure TFrmVCL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if THorse.IsRunning then
    Stop;

  TConexao.free;
end;

procedure TFrmVCL.FormCreate(Sender: TObject);
var
  //Qry : TFDQuery;
  JsonObj: TJSONObject;
begin
  TConexao := TConexaoPG.Create;

  THorse.Get('datasnap/rest/TServerMethods/EchoString/:param',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(Req.Params.Items['param']);
    end);

  THorse.Get('datasnap/rest/TServerMethods/ReverseString/:param',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(ReverseString(Req.Params.Items['param']));
    end);

  THorse.Get('datasnap/rest/TServerMethods/Pessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      QryPessoa: TFDQuery;
    begin
      try
        QryPessoa := TConexao.CriarQuery();
        try
          QryPessoa.Open('Select P.*, E.dscep ' +
                         'from pessoa P ' +
                         'inner join endereco E on E.idpessoa = P.idpessoa');
          try
            Res.Send<TJSONArray>(TConverter.New.DataSet(QryPessoa).AsJSONArray);
          finally
            QryPessoa.Close;
          end;
        finally
          QryPessoa.Free;
        end;
      except on E: Exception do
         Res.Send(TJSONObject.Create.AddPair('Mensagem', E.Message))
      end;
    end);

  THorse.Post('datasnap/rest/TServerMethods/Pessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Req.Body), 0) as TJSONObject;

      if JsonObj.Count > 1 then
        TConexao.Executar('insert into pessoa values ' +
                         '(:Codigo, :Natureza, :Documento, :Nome, :Sobrenome, :Data)',
                         [JsonObj.GetValue<Integer>('IDPessoa'),
                          JsonObj.GetValue<Integer>('Natureza'),
                          JsonObj.GetValue<string>('Documento'),
                          JsonObj.GetValue<string>('PrimeiroNome'),
                          JsonObj.GetValue<string>('SegundoNome'),
                          StrToDate(JsonObj.GetValue<string>('DataRegistro'))],
                          'Erro ao inserir Pessoa.');
      JsonObj.Free;

      //Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{"IDPessoa":1,"Natureza":1,"Documento":"123","PrimeiroNome":"Vinicius","SegundoNome":"Ribeiro","DataRegistro":"2024-12-30","CEP":"36880246"}'), 0) as TJSONObject;
    end);
end;

procedure TFrmVCL.Start;
begin
  // Need to set "HORSE_VCL" compilation directive
  THorse.Use(Jhonson);
  THorse.Listen(StrToInt(edtPort.Text));
end;

procedure TFrmVCL.Status;
begin
  btnStop.Enabled := THorse.IsRunning;
  btnStart.Enabled := not THorse.IsRunning;
  edtPort.Enabled := not THorse.IsRunning;
end;

procedure TFrmVCL.Stop;
begin
  THorse.StopListen;
end;

procedure TFrmVCL.btnStartClick(Sender: TObject);
begin
  Start;
  Status;
end;

procedure TFrmVCL.btnStopClick(Sender: TObject);
begin
  Stop;
  Status;
end;

end.
