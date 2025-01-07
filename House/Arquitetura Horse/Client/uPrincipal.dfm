object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Pessoa'
  ClientHeight = 954
  ClientWidth = 1339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -29
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 250
  TextHeight = 35
  object pnlCampos: TPanel
    Left = 0
    Top = 0
    Width = 1339
    Height = 265
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 283
      Top = 48
      Width = 211
      Height = 35
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Tipo Documento'
    end
    object edtCodigo: TLabeledEdit
      Left = 81
      Top = 89
      Width = 168
      Height = 43
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      EditLabel.Width = 88
      EditLabel.Height = 35
      EditLabel.Margins.Left = 8
      EditLabel.Margins.Top = 8
      EditLabel.Margins.Right = 8
      EditLabel.Margins.Bottom = 8
      EditLabel.Caption = 'C'#243'digo'
      Enabled = False
      TabOrder = 0
    end
    object edtDocumento: TLabeledEdit
      Left = 616
      Top = 89
      Width = 417
      Height = 43
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      EditLabel.Width = 146
      EditLabel.Height = 35
      EditLabel.Margins.Left = 8
      EditLabel.Margins.Top = 8
      EditLabel.Margins.Right = 8
      EditLabel.Margins.Bottom = 8
      EditLabel.Caption = 'Documento'
      TabOrder = 2
    end
    object edtNome: TLabeledEdit
      Left = 81
      Top = 202
      Width = 496
      Height = 43
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      EditLabel.Width = 188
      EditLabel.Height = 35
      EditLabel.Margins.Left = 8
      EditLabel.Margins.Top = 8
      EditLabel.Margins.Right = 8
      EditLabel.Margins.Bottom = 8
      EditLabel.Caption = 'Primeiro Nome'
      TabOrder = 4
    end
    object edtSobrenome: TLabeledEdit
      Left = 616
      Top = 206
      Width = 417
      Height = 43
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      EditLabel.Width = 144
      EditLabel.Height = 35
      EditLabel.Margins.Left = 8
      EditLabel.Margins.Top = 8
      EditLabel.Margins.Right = 8
      EditLabel.Margins.Bottom = 8
      EditLabel.Caption = 'Sobrenome'
      TabOrder = 5
    end
    object CBTipoDocumento: TComboBox
      Left = 283
      Top = 89
      Width = 294
      Height = 43
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      TabOrder = 1
      Items.Strings = (
        '1- CPF'
        '2 - Identidade')
    end
    object edtCEP: TLabeledEdit
      Left = 1072
      Top = 89
      Width = 225
      Height = 43
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      EditLabel.Width = 49
      EditLabel.Height = 35
      EditLabel.Margins.Left = 8
      EditLabel.Margins.Top = 8
      EditLabel.Margins.Right = 8
      EditLabel.Margins.Bottom = 8
      EditLabel.Caption = 'CEP'
      TabOrder = 3
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 265
    Width = 1339
    Height = 88
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    TabOrder = 1
    object btnNovaPessoa: TBitBtn
      Left = 144
      Top = 22
      Width = 200
      Height = 50
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Novo'
      TabOrder = 0
      OnClick = btnNovaPessoaClick
    end
    object btnEditarPessoa: TBitBtn
      Left = 360
      Top = 22
      Width = 200
      Height = 50
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Editar'
      TabOrder = 1
      OnClick = btnEditarPessoaClick
    end
    object btnGravarPessoa: TBitBtn
      Left = 792
      Top = 22
      Width = 200
      Height = 50
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Gravar'
      TabOrder = 2
      OnClick = btnGravarPessoaClick
    end
    object btnExcluirPessoa: TBitBtn
      Left = 576
      Top = 20
      Width = 200
      Height = 50
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Excluir'
      TabOrder = 3
      OnClick = btnExcluirPessoaClick
    end
    object btnCancelarPessoa: TBitBtn
      Left = 1008
      Top = 20
      Width = 198
      Height = 50
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Cancelar'
      TabOrder = 4
      OnClick = btnCancelarPessoaClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 353
    Width = 1339
    Height = 601
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alClient
    TabOrder = 2
    object dgbPessoa: TDBGrid
      Left = 1
      Top = 1
      Width = 1337
      Height = 599
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      DataSource = dsrPessoa
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -29
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dgbPessoaCellClick
    end
  end
  object MTBPessoa: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 283
    Top = 499
    object MTBPessoaidpessoa: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'idpessoa'
    end
    object MTBPessoaflnatureza: TIntegerField
      DisplayLabel = 'Natureza'
      FieldName = 'flnatureza'
    end
    object MTBPessoadsdocumento: TStringField
      DisplayLabel = 'Documento'
      FieldName = 'dsdocumento'
    end
    object MTBPessoanmprimeiro: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nmprimeiro'
      Size = 100
    end
    object MTBPessoanmsegundo: TStringField
      DisplayLabel = 'Sobrenome'
      FieldName = 'nmsegundo'
      Size = 100
    end
    object MTBPessoadtregistro: TDateField
      DisplayLabel = 'Data'
      FieldName = 'dtregistro'
    end
    object MTBPessoadscep: TStringField
      DisplayLabel = 'Cep'
      FieldName = 'dscep'
    end
    object MTBPessoaidendereco: TIntegerField
      FieldName = 'idendereco'
      Visible = False
    end
  end
  object dsrPessoa: TDataSource
    DataSet = MTBPessoa
    Left = 353
    Top = 461
  end
end
