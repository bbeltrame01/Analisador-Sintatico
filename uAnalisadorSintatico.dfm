object fAnalisadorSintatico: TfAnalisadorSintatico
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Analisador Sint'#225'tico'
  ClientHeight = 536
  ClientWidth = 1021
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lbl_sentenca: TLabel
    Left = 24
    Top = 11
    Width = 58
    Height = 16
    Caption = 'Senten'#231'a:'
  end
  object Shape1: TShape
    Left = 366
    Top = 30
    Width = 2
    Height = 498
  end
  object lbl_gramatica: TLabel
    Left = 24
    Top = 103
    Width = 63
    Height = 16
    Caption = 'Gram'#225'tica:'
  end
  object Label1: TLabel
    Left = 24
    Top = 230
    Width = 44
    Height = 16
    Caption = 'Tabela:'
  end
  object lbl_first_follow: TLabel
    Left = 24
    Top = 382
    Width = 94
    Height = 16
    Caption = 'FIRST/FOLLOW:'
  end
  object lbl_resposta: TLabel
    Left = 380
    Top = 487
    Width = 102
    Height = 23
    Caption = 'RESPOSTA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_delay: TLabel
    Left = 824
    Top = 465
    Width = 62
    Height = 16
    Caption = 'Velocidade'
  end
  object lbl_1s: TLabel
    Left = 896
    Top = 508
    Width = 11
    Height = 13
    Caption = '1s'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_02s: TLabel
    Left = 818
    Top = 508
    Width = 21
    Height = 13
    Caption = '0.2s'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_2s: TLabel
    Left = 989
    Top = 508
    Width = 11
    Height = 13
    Caption = '2s'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object tkb_delay: TTrackBar
    Left = 816
    Top = 479
    Width = 189
    Height = 31
    Min = 1
    Position = 5
    TabOrder = 8
  end
  object edt_sentenca: TEdit
    Left = 24
    Top = 30
    Width = 328
    Height = 24
    TabOrder = 0
    OnChange = edt_sentencaChange
    OnKeyPress = edt_sentencaKeyPress
  end
  object stg_gramatica: TStringGrid
    Left = 24
    Top = 121
    Width = 328
    Height = 103
    BevelInner = bvSpace
    ColCount = 3
    Enabled = False
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    GradientEndColor = clWindow
    Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect]
    TabOrder = 4
    OnDrawCell = stg_gramaticaDrawCell
    ColWidths = (
      64
      130
      128)
  end
  object stg_tabela: TStringGrid
    Left = 24
    Top = 248
    Width = 328
    Height = 128
    ColCount = 6
    DefaultColWidth = 53
    Enabled = False
    FixedCols = 0
    TabOrder = 5
    OnDrawCell = stg_tabelaDrawCell
  end
  object stg_first_follow: TStringGrid
    Left = 24
    Top = 400
    Width = 328
    Height = 128
    ColCount = 3
    DefaultColWidth = 107
    Enabled = False
    FixedCols = 0
    TabOrder = 6
    OnDrawCell = stg_first_followDrawCell
    ColWidths = (
      64
      130
      128)
  end
  object btn_gerar: TButton
    Left = 24
    Top = 60
    Width = 100
    Height = 37
    Caption = 'Gerar'
    TabOrder = 1
    OnClick = btn_gerarClick
  end
  object btn_total: TButton
    Left = 138
    Top = 60
    Width = 100
    Height = 37
    Caption = 'Total'
    Enabled = False
    TabOrder = 2
    OnClick = btn_totalClick
  end
  object btn_passo_a_passo: TButton
    Left = 252
    Top = 60
    Width = 100
    Height = 37
    Caption = '&Passo a Passo'
    Enabled = False
    TabOrder = 3
    OnClick = btn_passo_a_passoClick
  end
  object stg_principal: TStringGrid
    Left = 380
    Top = 30
    Width = 625
    Height = 427
    ColCount = 4
    DefaultColWidth = 190
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 7
    OnDrawCell = stg_principalDrawCell
    ColWidths = (
      30
      190
      190
      190)
  end
  object tmr: TTimer
    Enabled = False
    OnTimer = tmrTimer
    Left = 752
    Top = 488
  end
end
