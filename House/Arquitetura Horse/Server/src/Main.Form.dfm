object FrmVCL: TFrmVCL
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Server'
  ClientHeight = 214
  ClientWidth = 523
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -29
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 250
  TextHeight = 35
  object Label1: TLabel
    Left = 21
    Top = 49
    Width = 62
    Height = 35
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Caption = 'Port:'
  end
  object btnStop: TBitBtn
    Left = 271
    Top = 130
    Width = 234
    Height = 65
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Caption = 'Stop'
    Enabled = False
    TabOrder = 0
    OnClick = btnStopClick
  end
  object btnStart: TBitBtn
    Left = 21
    Top = 130
    Width = 234
    Height = 65
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Caption = 'Start'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object edtPort: TEdit
    Left = 99
    Top = 42
    Width = 406
    Height = 43
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    NumbersOnly = True
    TabOrder = 2
    Text = '8080'
  end
  object qryExecJson: TFDQuery
    SQL.Strings = (
      'insert into pessoa values '
      '(:Codigo, :Natureza, :Documento, :Nome, :Sobrenome, :Data)')
    Left = 424
    Top = 8
    ParamData = <
      item
        Name = 'CODIGO'
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NATUREZA'
        ParamType = ptInput
      end
      item
        Name = 'DOCUMENTO'
        ParamType = ptInput
      end
      item
        Name = 'NOME'
        ParamType = ptInput
      end
      item
        Name = 'SOBRENOME'
        ParamType = ptInput
      end
      item
        Name = 'DATA'
        ParamType = ptInput
      end>
  end
end
