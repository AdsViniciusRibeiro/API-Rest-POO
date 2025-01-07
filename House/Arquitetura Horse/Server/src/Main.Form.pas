unit Main.Form;

interface

uses Winapi.Windows, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Buttons, System.SysUtils, FireDAC.Comp.Client, uConexao, DataSetConverter4D, DataSetConverter4D.Impl,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet;

type
  TFrmVCL = class(TForm)
    btnStop: TBitBtn;
    btnStart: TBitBtn;
    Label1: TLabel;
    edtPort: TEdit;
    qryExecJson: TFDQuery;
    procedure btnStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Status;
    procedure Start;
    procedure Stop;
    procedure Pessoa;
    procedure CEP;
    procedure Endereco;

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

   Pessoa;
   CEP;
   Endereco;
end;

procedure TFrmVCL.Pessoa;
var
  JsonObj: TJSONObject;
  ObjArray : TJSONArray;
begin
  //Pessoa
  THorse.Get('datasnap/rest/TServerMethods/RetornaMaiorIDPessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
       Res.Send<TJSONObject>(TConexao.DataSetToJsonObject('Select COALESCE(MAX(idpessoa), 0) + 1 MaiorID from pessoa', []));
    end);

  THorse.Delete('datasnap/rest/TServerMethods/Pessoa/:IDPesssoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      try
        TConexao.ExecutarScript('Delete from pessoa where idpessoa =:ID', [Req.Params.Items['IDPesssoa'].ToInteger]);
      except on E: Exception do
         Res.Send(TJSONObject.Create.AddPair('Mensagem', E.Message));
      end;
    end);

  THorse.Get('datasnap/rest/TServerMethods/Pessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      try
        Res.Send<TJSONArray>(TConexao.DataSetToJsonArray('Select P.*, E.dscep, idendereco ' +
                                                         'from pessoa P ' +
                                                         'inner join endereco E on E.idpessoa = P.idpessoa', []));
      except on E: Exception do
         Res.Send(TJSONObject.Create.AddPair('Mensagem', E.Message));
      end;
    end);

  THorse.Put('datasnap/rest/TServerMethods/Pessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Req.Body), 0) as TJSONObject;

      if JsonObj.Count > 1 then
        TConexao.ExecutarScript('update pessoa set flnatureza =:NATUREZA, dsdocumento =:DOCUMENTO, ' +
                                                   'nmprimeiro =:NOME, nmsegundo =:SOBRENOME, dtregistro =:DATA ' +
                                'where idpessoa =:ID',
                                [JsonObj.GetValue<Integer>('Natureza'),
                                JsonObj.GetValue<string>('Documento'),
                                JsonObj.GetValue<string>('PrimeiroNome'),
                                JsonObj.GetValue<string>('SegundoNome'),
                                StrToDate(JsonObj.GetValue<string>('DataRegistro')),
                                JsonObj.GetValue<Integer>('IDPessoa')],
                                'Erro ao alterar Pessoa.');
    end);

  THorse.Post('datasnap/rest/TServerMethods/Pessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      i : Integer;
      sJsonString : WideString;
    begin
      sJsonString := Req.Body;

      if LeftStr(Req.Body, 1) <> '[' then
        sJsonString := '[' + sJsonString;

      if RightStr(Req.Body, 1) <> ']' then
        sJsonString := sJsonString + ']';

      ObjArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(sJsonString), 0) as TJSONArray;

      qryExecJson.Connection := TConexao.GetConexao;
      qryExecJson.SQL.Text := 'insert into pessoa values ' +
                            '(:Codigo, :Natureza, :Documento, :Nome, :Sobrenome, :Data)';

      qryExecJson.Params.ArraySize := ObjArray.Count;

      for I := 0 to Pred(ObjArray.Count) do
      begin
        //Converter JsonArray para JsonObject
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(ObjArray.Items[i].ToString), 0) as TJSONObject;

        //Passa os parametros
        if JsonObj.Count > 1 then
        begin
          qryExecJson.ParamByName('CODIGO').AsIntegers[i]   := JsonObj.GetValue<Integer>('IDPessoa');
          qryExecJson.ParamByName('NATUREZA').AsIntegers[i] := JsonObj.GetValue<Integer>('Natureza');
          qryExecJson.ParamByName('DOCUMENTO').AsStrings[i] := JsonObj.GetValue<string>('Documento');
          qryExecJson.ParamByName('NOME').AsStrings[i]      := JsonObj.GetValue<string>('PrimeiroNome');
          qryExecJson.ParamByName('SOBRENOME').AsStrings[i] := JsonObj.GetValue<string>('SegundoNome');
          qryExecJson.ParamByName('DATA').AsDateTimes[i]    := StrToDate(JsonObj.GetValue<string>('DataRegistro'));
        end;
      end;

      JsonObj.Free;
      qryExecJson.Execute(ObjArray.Count, 0);
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

procedure TFrmVCL.CEP;
var
  JsonObj: TJSONObject;
  ObjArray : TJSONArray;
begin
  THorse.Post('datasnap/rest/TServerMethods/CEP',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      i : Integer;
      sJsonString : WideString;
    begin
      sJsonString := Req.Body;

      if LeftStr(Req.Body, 1) <> '[' then
        sJsonString := '[' + sJsonString;

      if RightStr(Req.Body, 1) <> ']' then
        sJsonString := sJsonString + ']';

      ObjArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(sJsonString), 0) as TJSONArray;

      qryExecJson.Connection := TConexao.GetConexao;
      qryExecJson.SQL.Text := 'insert into endereco (idendereco, idpessoa, dscep) values ' +
                            '(:IDENREDECO, :IDPESSOA, :CEP)';
      qryExecJson.Params.ArraySize := ObjArray.Count;

      for I := 0 to Pred(ObjArray.Count) do
      begin
        //Converter JsonArray para JsonObject
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(ObjArray.Items[i].ToString), 0) as TJSONObject;

        //Passa os parametros
        if JsonObj.Count > 1 then
        begin
          qryExecJson.ParamByName('IDENREDECO').AsIntegers[i]   := JsonObj.GetValue<Integer>('IDEndereco');
          qryExecJson.ParamByName('IDPESSOA').AsIntegers[i] := JsonObj.GetValue<Integer>('IDPessoa');
          qryExecJson.ParamByName('CEP').AsStrings[i]      := JsonObj.GetValue<string>('CEP');
        end;
      end;

      qryExecJson.Execute(ObjArray.Count, 0);
      JsonObj.Free;
    end);

  THorse.Put('datasnap/rest/TServerMethods/CEP',
  procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Req.Body), 0) as TJSONObject;

    if JsonObj.Count > 1 then
    begin
      if TConexao.ExecutarScript('update endereco set dscep =:CEP where idendereco =:IDENDERECO and idpessoa =:IDPESSOA ',
                                [JsonObj.GetValue<Integer>('CEP'),
                                JsonObj.GetValue<Integer>('IDEndereco'),
                                JsonObj.GetValue<Integer>('IDPessoa')],
                                'Erro ao alterar CEP.') then

    end;
    JsonObj.Free;
  end);

  THorse.Get('datasnap/rest/TServerMethods/RetornaMaiorIDCEP',
  procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    try
      Res.Send<TJSONObject>(TConexao.DataSetToJsonObject('Select COALESCE(MAX(IDEndereco), 0) + 1 MaiorID from endereco', []));
    except on E: Exception do
       Res.Send(TJSONObject.Create.AddPair('Mensagem', E.Message));
    end;
  end);

  THorse.Get('datasnap/rest/TServerMethods/CEP/:IDEndereco/:IDPessoa',
  procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    try
      Res.Send<TJSONObject>(TConexao.DataSetToJsonObject('Select * from endereco where idendereco =:ID and idpessoa =:IDPESSOA',
                                                         [Req.Params.Items['IDEndereco'].ToInteger,
                                                          Req.Params.Items['IDPessoa'].ToInteger])).Status(THTTPStatus.OK);
    except on E: Exception do
       Res.Send(TJSONObject.Create.AddPair('Mensagem', E.Message));
    end;
  end);

  THorse.Delete('datasnap/rest/TServerMethods/CEP/:IDEndereco/:IDPessoa',
  procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    try
      TConexao.ExecutarScript('Delete from endereco where idendereco =:ID and idpessoa =:IDPESSOA',
                              [Req.Params.Items['IDEndereco'].ToInteger,
                               Req.Params.Items['IDPessoa'].ToInteger]);
    except on E: Exception do
       Res.Send(TJSONObject.Create.AddPair('Mensagem', E.Message));
    end;
  end);
end;

procedure TFrmVCL.Endereco;
var
  JsonObj: TJSONObject;
begin
  THorse.Post('datasnap/rest/TServerMethods/Endereco',
  procedure(Req: THorseRequest; Res: THorseResponse)
  var
    i : Integer;
    sJsonString : WideString;
    ObjArray : TJSONArray;
  begin
    sJsonString := Req.Body;

    if LeftStr(Req.Body, 1) <> '[' then
      sJsonString := '[' + sJsonString;

    if RightStr(Req.Body, 1) <> ']' then
      sJsonString := sJsonString + ']';

    ObjArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(sJsonString), 0) as TJSONArray;

    qryExecJson.Connection := TConexao.GetConexao;
    qryExecJson.SQL.Text := 'insert into endereco_integracao values ' +
                            '(:IDEENDERECO, :UF, :CIDADE, :BAIRRO, :LOGRADOURO, :COMPLEMENTO)';
    qryExecJson.Params.ArraySize := ObjArray.Count;

    for I := 0 to Pred(ObjArray.Count) do
    begin
      //Converter JsonArray para JsonObject
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(ObjArray.Items[i].ToString), 0) as TJSONObject;

      //Passa os parametros
      if JsonObj.Count > 1 then
      begin
        qryExecJson.ParamByName('IDEENDERECO').AsIntegers[i] := JsonObj.GetValue<Integer>('IDEndereco');
        qryExecJson.ParamByName('UF').AsStrings[i]           := JsonObj.GetValue<string>('UF');
        qryExecJson.ParamByName('CIDADE').AsStrings[i]       := JsonObj.GetValue<string>('Cidade');
        qryExecJson.ParamByName('BAIRRO').AsStrings[i]       := JsonObj.GetValue<string>('Bairro');
        qryExecJson.ParamByName('LOGRADOURO').AsStrings[i]   := JsonObj.GetValue<string>('Logradouro');
        qryExecJson.ParamByName('COMPLEMENTO').AsStrings[i]  := JsonObj.GetValue<string>('Complemento');
      end;
    end;

    qryExecJson.Execute(ObjArray.Count, 0);
    JsonObj.Free;
  end);

  THorse.Put('datasnap/rest/TServerMethods/Endereco',
  procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Req.Body), 0) as TJSONObject;

    if JsonObj.Count > 1 then
    begin
      if TConexao.ExecutarScript('update endereco_integracao set dsuf =:UF , nmcidade =:CIDADE, nmbairro =:BAIRRO, ' +
                                                                 'nmlogradouro =:LOGRADOURO, dscomplemento =:COMPLEMENTO ' +
                                 'where idendereco =:IDENDERECO',
                                  [JsonObj.GetValue<string>('UF'),
                                   JsonObj.GetValue<string>('Cidade'),
                                   JsonObj.GetValue<string>('Bairro'),
                                   JsonObj.GetValue<string>('Logradouro'),
                                   JsonObj.GetValue<string>('Complemento'),
                                   JsonObj.GetValue<Integer>('IDEndereco')],
                                  'Erro ao alterar endereço.') then

    end;
    JsonObj.Free;
  end);
end;

end.
