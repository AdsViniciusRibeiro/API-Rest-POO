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
  IdHTTP, uClasseEndereco, uControleEndereco, uClasseCEP, uControleCEP,
  uPessoa, uControlePessoa;

type
  TPesquisa = (pTodos, pPorID, pMaiorIDPessoa, pMaiorIDEndereco, pInsert);
  TControleBotoes = (cInicial, cInsersao, cEdicao);
  TCrud = (cInsert, cEditar, cExcluir);

  TfrmPrincipal = class(TForm)
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
    MTBPessoaidendereco: TIntegerField;
    procedure FormShow(Sender: TObject);
    procedure btnGravarPessoaClick(Sender: TObject);
    procedure btnCancelarPessoaClick(Sender: TObject);
    procedure btnNovaPessoaClick(Sender: TObject);
    procedure btnEditarPessoaClick(Sender: TObject);
    procedure btnExcluirPessoaClick(Sender: TObject);
    procedure dgbPessoaCellClick(Column: TColumn);
  private
    { Private declarations }
    procedure ControlaBotoes(Controle : TControleBotoes);
    procedure ListarTodasPessoas;
    procedure CRUD;

    var
      AcaoCrud : TCrud;

  public
    { Public declarations }
    IDEndereco : Integer;
  end;

var
  frmPrincipal : TfrmPrincipal;

implementation

uses
  System.SysUtils, uThreadEndereco, uClasseAPI;

{$R *.dfm}

procedure TfrmPrincipal.ListarTodasPessoas;
var
  API : TAPI;
  JsonObj : TJSONArray;
  ObJPessoa : TPessoa;
  sjSon : WideString;
begin
  try
    if not MTBPessoa.Active then
       MTBPessoa.CreateDataSet
    else
      MTBPessoa.EmptyDataSet;

    ObJPessoa := TPessoa.Create;
    sjSon := ObJPessoa.EnviaAPI(ObJPessoa, rmGET, ObJPessoa.URL, '');

    if sjSon <> '' then
    begin
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(sjSon), 0) as TJSONArray;
      TConverter.New.JSON.Source(jsonObj).ToDataSet(MTBPessoa);
    end;
  except on E: Exception do
    ShowMessage('Erro ao converter Json.')
  end;

  FreeAndNil(ObJPessoa);
end;

procedure TfrmPrincipal.ControlaBotoes(Controle : TControleBotoes);
begin
  case Controle of
    cInicial: begin
                btnNovaPessoa.Enabled     := True;
                btnEditarPessoa.Enabled   := True;
                btnExcluirPessoa.Enabled  := True;
                btnGravarPessoa.Enabled   := False;
                btnCancelarPessoa.Enabled := False;
                dgbPessoa.Enabled         := True;

                edtDocumento.Enabled    := False;
                edtNome.Enabled         := False;
                edtSobrenome.Enabled    := False;
                edtCEP.Enabled          := False;
                CBTipoDocumento.Enabled := False;

                edtCodigo.Clear;
                edtDocumento.Clear;
                edtNome.Clear;
                edtSobrenome.Clear;
                edtCEP.Clear;
                CBTipoDocumento.ItemIndex := -1;
              end;

    cInsersao: begin
                btnNovaPessoa.Enabled     := False;
                btnEditarPessoa.Enabled   := False;
                btnExcluirPessoa.Enabled  := False;
                btnGravarPessoa.Enabled   := True;
                btnCancelarPessoa.Enabled := True;
                dgbPessoa.Enabled         := False;

                edtDocumento.Enabled    := True;
                edtNome.Enabled         := True;
                edtSobrenome.Enabled    := True;
                edtCEP.Enabled          := True;
                CBTipoDocumento.Enabled := True;

                edtCodigo.Clear;
                edtDocumento.Clear;
                edtNome.Clear;
                edtSobrenome.Clear;
                edtCEP.Clear;
                CBTipoDocumento.ItemIndex := -1;
              end;

    cEdicao: begin
               btnNovaPessoa.Enabled     := False;
               btnEditarPessoa.Enabled   := False;
               btnExcluirPessoa.Enabled  := False;
               btnGravarPessoa.Enabled   := True;
               btnCancelarPessoa.Enabled := True;
               dgbPessoa.Enabled         := False;

               edtDocumento.Enabled     := True;
               edtNome.Enabled          := True;
               edtSobrenome.Enabled     := True;
               edtCEP.Enabled           := True;
               CBTipoDocumento.Enabled  := True;
             end;
  end;
end;

procedure TfrmPrincipal.CRUD;
var
  objPessoa: TPessoa;
  objControlePessoa: TControlePessoa;
  ObjThreadEndereco : TThreadEndereco;
begin
  try
    objPessoa         := TPessoa.Create;
    objControlePessoa := TControlePessoa.Create;

    try
      objPessoa.IDPessoa     := StrToInt(edtCodigo.Text);
      objPessoa.Natureza     := StrToInt(LeftStr(CBTipoDocumento.Text, 1));
      objPessoa.Documento    := edtDocumento.Text;
      objPessoa.PrimeiroNome := edtNome.Text;
      objPessoa.SegundoNome  := edtSobrenome.Text;
      objPessoa.DataRegistro := Date;

      case AcaoCrud of
        cInsert: begin
                    objControlePessoa.Salvar(objPessoa);
                    ObjThreadEndereco := TThreadEndereco.Create(rmPOST);
                 end;

        cEditar: begin
                   objControlePessoa.Editar(objPessoa);
                   ObjThreadEndereco := TThreadEndereco.Create(rmPUT);
                 end;

        cExcluir: objControlePessoa.Excluir(objPessoa);
      end;

    finally
      FreeAndNil(objPessoa);
      FreeAndNil(objControlePessoa);
      ListarTodasPessoas;
    end;
  except on E: Exception do
    begin
      FreeAndNil(objPessoa);
      FreeAndNil(objControlePessoa);
    end;
  end;

  ControlaBotoes(cInicial);
end;

procedure TfrmPrincipal.dgbPessoaCellClick(Column: TColumn);
begin
  edtCodigo.Text    := MTBPessoaidpessoa.AsString;
  edtDocumento.Text := MTBPessoadsdocumento.AsString;
  edtNome.Text      := MTBPessoanmprimeiro.AsString;
  edtSobrenome.Text := MTBPessoanmsegundo.AsString;
  edtCEP.Text       := MTBPessoadscep.AsString;
  CBTipoDocumento.ItemIndex := MTBPessoaflnatureza.AsInteger - 1;
end;

procedure TfrmPrincipal.btnCancelarPessoaClick(Sender: TObject);
begin
  ControlaBotoes(cInicial);
end;

procedure TfrmPrincipal.btnEditarPessoaClick(Sender: TObject);
begin
  ControlaBotoes(cEdicao);
  AcaoCrud := cEditar;
  IDEndereco := MTBPessoa.FieldByName('IDEndereco').AsInteger;
end;

procedure TfrmPrincipal.btnExcluirPessoaClick(Sender: TObject);
begin
  AcaoCrud := cExcluir;
  CRUD;
end;

procedure TfrmPrincipal.btnGravarPessoaClick(Sender: TObject);
begin
  CRUD;
end;

procedure TfrmPrincipal.btnNovaPessoaClick(Sender: TObject);
var
  JsonObj : TJSONObject;
  sJson : WideString;
  ObJPessoa : TPessoa;
begin
  ObJPessoa := TPessoa.Create;
  sjSon := ObJPessoa.EnviaAPI(ObJPessoa, rmGET, ObJPessoa.URLID, '');

  JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(sjSon), 0) as TJSONObject;

  ControlaBotoes(cInsersao);
  edtCodigo.Text := JsonObj.GetValue<string>('maiorid');
  CBTipoDocumento.SetFocus;

  AcaoCrud := cInsert;
  IDEndereco := 0;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  ListarTodasPessoas;

  ControlaBotoes(cInicial);
end;

end.
