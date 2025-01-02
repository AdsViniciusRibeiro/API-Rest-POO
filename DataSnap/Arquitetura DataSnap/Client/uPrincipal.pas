unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Data.DB, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, DataSetConverter4D, DataSetConverter4D.Impl, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON, System.StrUtils,
  IdHTTP;

type
  TPesquisa = (pTodos, pPorID, pMaiorIDPessoa, pMaiorIDEndereco, pInsert);
  TControleBotoes = (cInicial, cInsersao, cEdicao);

  TPerson = record
    Name: string;
    Age: Integer;
  end;

  TfrmPessoa = class(TForm)
    pnlCampos: TPanel;
    edtCodigo: TLabeledEdit;
    edtDocumento: TLabeledEdit;
    edtNome: TLabeledEdit;
    edtSobrenome: TLabeledEdit;
    CBTipoDocumento: TComboBox;
    Label1: TLabel;
    pnlBotoes: TPanel;
    pnlGrid: TPanel;
    dgbPessoa: TDBGrid;
    btnNovaPessoa: TBitBtn;
    btnEditarPessoa: TBitBtn;
    btnGravarPessoa: TBitBtn;
    btnExcluirPessoa: TBitBtn;
    btnCancelarPessoa: TBitBtn;
    MTBPessoa: TFDMemTable;
    dsrPessoa: TDataSource;
    MTBPessoaidpessoa: TIntegerField;
    MTBPessoaflnatureza: TIntegerField;
    MTBPessoadsdocumento: TStringField;
    MTBPessoanmprimeiro: TStringField;
    MTBPessoanmsegundo: TStringField;
    MTBPessoadtregistro: TDateField;
    MTBPessoadscep: TStringField;
    edtCEP: TLabeledEdit;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnGravarPessoaClick(Sender: TObject);
    procedure btnCancelarPessoaClick(Sender: TObject);
    procedure btnNovaPessoaClick(Sender: TObject);
    procedure btnEditarPessoaClick(Sender: TObject);
    procedure btnExcluirPessoaClick(Sender: TObject);
    procedure dgbPessoaCellClick(Column: TColumn);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    function APIJson(TipoRetorno : TPesquisa; Metodo : TRESTRequestMethod) : WideString;
    procedure ControlaBotoes(Controle : TControleBotoes);
    function MontaURL(TipoRetorno : TPesquisa; Metodo : TRESTRequestMethod; CodPessoa : String = '') : String;
    procedure ListarTodasPessoas(sjSon : WideString);
  public
    { Public declarations }
  end;

var
  frmPessoa: TfrmPessoa;

implementation

uses
  System.SysUtils, uClassePessoa, uControlerPessoa;

{$R *.dfm}

procedure TfrmPessoa.ListarTodasPessoas(sjSon : WideString);
var
  JsonObj : TJSONArray;
begin
  try
    if sjSon <> '' then
    begin
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(sjSon), 0) as TJSONArray;
      TConverter.New.JSON.Source(jsonObj).ToDataSet(MTBPessoa);
    end;
  except on E: Exception do
    ShowMessage('Erro ao converter Json.')
  end;
end;

function TfrmPessoa.MontaURL(TipoRetorno : TPesquisa; Metodo : TRESTRequestMethod; CodPessoa : String = '') : String;
var
  CompletaURL : String;
begin
 CompletaURL := 'http://localhost:8080/datasnap/rest/TServerMethods/';

 case TipoRetorno of
   pTodos: CompletaURL := CompletaURL + 'ListarPessoa';
   pPorID: ;
   pMaiorIDPessoa: CompletaURL := CompletaURL + 'RetornaMaiorID';
   pMaiorIDEndereco: ;
   pInsert: CompletaURL := CompletaURL + 'acceptInsertPessoa';
 end;

 Result := CompletaURL;

 { case Metodo of
    rmPOST   : CompletaURL := ifThen(CodPesquisa = '', '', '/' + CodPesquisa + ifThen(Serie <> '', '/' + Serie));
    rmPUT    : CompletaURL := ifThen(CodPesquisa = '', '', '/' + CodPesquisa + ifThen(Serie <> '', '/' + Serie));
    rmGET    : CompletaURL := ifThen(CodPesquisa = '', 's', '/' + CodPesquisa + ifThen(Serie <> '', '/' + Serie));
    rmDELETE : CompletaURL := ifThen(CodPesquisa = '', 's', '/' + CodPesquisa + ifThen(Serie <> '', '/' + Serie));
    rmPATCH  : ;
  end;  }
end;

procedure TfrmPessoa.ControlaBotoes(Controle : TControleBotoes);
begin
  case Controle of
    cInicial: begin
                btnNovaPessoa.Enabled     := True;
                btnEditarPessoa.Enabled   := False;
                btnExcluirPessoa.Enabled  := True;
                btnGravarPessoa.Enabled   := False;
                btnCancelarPessoa.Enabled := False;
                dgbPessoa.Enabled         := True;

                edtCodigo.Clear;
                edtCodigo.Clear;
                edtDocumento.Clear;
                edtNome.Clear;
                edtSobrenome.Clear;
                CBTipoDocumento.ItemIndex := -1;
              end;

    cInsersao: begin
                btnNovaPessoa.Enabled     := False;
                btnEditarPessoa.Enabled   := False;
                btnExcluirPessoa.Enabled  := False;
                btnGravarPessoa.Enabled   := True;
                btnCancelarPessoa.Enabled := True;
                dgbPessoa.Enabled         := False;

                edtCodigo.Clear;
                edtCodigo.Clear;
                edtDocumento.Clear;
                edtNome.Clear;
                edtSobrenome.Clear;
                CBTipoDocumento.ItemIndex := -1;
              end;

    cEdicao: begin
               btnNovaPessoa.Enabled     := False;
               btnEditarPessoa.Enabled   := False;
               btnExcluirPessoa.Enabled  := False;
               btnGravarPessoa.Enabled   := True;
               btnCancelarPessoa.Enabled := True;
               dgbPessoa.Enabled         := False;
             end;
  end;
end;

procedure TfrmPessoa.dgbPessoaCellClick(Column: TColumn);
begin
  edtCodigo.Text    := MTBPessoaidpessoa.AsString;
  edtDocumento.Text := MTBPessoadsdocumento.AsString;
  edtNome.Text      := MTBPessoanmprimeiro.AsString;
  edtSobrenome.Text := MTBPessoanmsegundo.AsString;
  edtCEP.Text       := MTBPessoadscep.AsString;
  CBTipoDocumento.ItemIndex := MTBPessoaflnatureza.AsInteger - 1;
end;

function TfrmPessoa.APIJson(TipoRetorno : TPesquisa; Metodo : TRESTRequestMethod) : WideString;
var
  CodRetorno   : Integer;
  RESTClient   : TRESTClient;
  RESTRequest  : TRESTRequest;
  RESTResponse : TRESTResponse;
  myThread : TThread;
begin
  try
    try
      RESTClient   := TRESTClient.Create(nil);
      RESTRequest  := TRESTRequest.Create(nil);
      RESTResponse := TRESTResponse.Create(nil);

      //CLIENT
      RESTClient.Accept        := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
      RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
      RESTClient.BaseURL       := MontaURL(TipoRetorno, rmGET);

      //RESPONSE
      RESTResponse.ContentType := 'application/json';

      //REQUEST
      RESTRequest.Client   := RESTClient;
      RESTRequest.Response := RESTResponse;
      RESTRequest.Method   := Metodo;

      //API Key
      {RESTRequest.Params.Add;
      RESTRequest.Params[0].Name  := 'Quantidade';
      RESTRequest.Params[0].Value := '3';}

      RESTRequest.Execute;

      Result     := RESTResponse.Content;
      CodRetorno := RESTResponse.StatusCode;

      //Clipboard.AsText := XML;
    finally
      FreeAndNil(RESTClient);
      FreeAndNil(RESTRequest);
      FreeAndNil(RESTResponse);
    end;
  except on E: Exception do
    ShowMessage('Erro na conexão com API.');
  end;
end;

procedure TfrmPessoa.BitBtn1Click(Sender: TObject);
var
  HTTP: TIdHTTP;
  JSON: TJSONObject;
  Person: TPerson;
begin
  // Criar um objeto HTTP
  HTTP := TIdHTTP.Create(nil);
  try
    // Configurar o objeto HTTP
    HTTP.Request.ContentType := 'application/json';
    HTTP.HandleRedirects := True;

    // Criar um objeto JSON com os dados
    JSON := TJSONObject.Create;
    Person.Name := 'João Silva';
    Person.Age := 30;
    JSON.AddPair('Name', Person.Name);
    JSON.AddPair('Age', IntToStr(Person.Age));

    // Enviar a requisição POST
    HTTP.Post('http://localhost:8080/datasnap/rest/TServerMethods/InsertPessoa', JSON.ToString);

    // Processar a resposta (opcional)
    // ...
  finally
    HTTP.Free;
  end;
end;

procedure TfrmPessoa.btnCancelarPessoaClick(Sender: TObject);
begin
  ControlaBotoes(cInicial);
end;

procedure TfrmPessoa.btnEditarPessoaClick(Sender: TObject);
begin
  ControlaBotoes(cEdicao);
end;

procedure TfrmPessoa.btnExcluirPessoaClick(Sender: TObject);
begin
  ControlaBotoes(cInicial);
end;

procedure TfrmPessoa.btnGravarPessoaClick(Sender: TObject);
var
  objPessoa: TPessoa;
  objControle: TControlePessoa;
begin
  // instanciação dos objetos
  objPessoa  := TPessoa.Create; // classe Modelo
  objControle := TControlePessoa.Create; // classe Controle
  try
    // preenchimento dos dados
    objPessoa.IDPessoa     := StrToInt(edtCodigo.Text);
    objPessoa.Natureza     := StrToInt(LeftStr(CBTipoDocumento.Text, 1));
    objPessoa.Documento    := edtDocumento.Text;
    objPessoa.PrimeiroNome := edtNome.Text;
    objPessoa.SegundoNome  := edtSobrenome.Text;
    objPessoa.DataRegistro := Date;
    objPessoa.CEP          := edtCEP.Text;

    // chamada da rotina para gravação
    objControle.Salvar(objPessoa);
  finally
    // liberação dos objetos da memória
    FreeAndNil(objPessoa);
    FreeAndNil(objControle);
  end;

  ControlaBotoes(cInicial);
end;

procedure TfrmPessoa.btnNovaPessoaClick(Sender: TObject);
var
  JsonObj : TJSONObject;
  sJson : WideString;
begin
  sJson := APIJson(pMaiorIDPessoa, rmGET);
  //sJson := Copy(sJson, 2, Length(sJson) - 2);
  JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(sjSon), 0) as TJSONObject;

  ControlaBotoes(cInsersao);
  edtCodigo.Text := JsonObj.GetValue<string>('maiorid');
  CBTipoDocumento.SetFocus;
end;

procedure TfrmPessoa.FormShow(Sender: TObject);
begin
  MTBPessoa.CreateDataSet;
  ListarTodasPessoas(APIJson(pTodos, rmGET));

  ControlaBotoes(cInicial);
end;

end.
