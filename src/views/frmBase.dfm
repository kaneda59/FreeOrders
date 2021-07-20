object FormBase: TFormBase
  Left = 0
  Top = 0
  Caption = 'Form Base'
  ClientHeight = 355
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlheader: TPanel
    Left = 0
    Top = 0
    Width = 552
    Height = 41
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 56
    ExplicitTop = 48
    ExplicitWidth = 185
    DesignSize = (
      552
      41)
    object LblFree: TLabel
      Left = 16
      Top = 10
      Width = 27
      Height = 19
      Caption = 'free'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblOrders: TLabel
      Left = 44
      Top = 4
      Width = 93
      Height = 29
      AutoSize = False
      Caption = 'Orders'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lblTitle: TLabel
      Left = 309
      Top = 7
      Width = 235
      Height = 23
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'lblTitle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
  end
  object state: TStatusBar
    Left = 0
    Top = 336
    Width = 552
    Height = 19
    Panels = <>
    ExplicitLeft = 288
    ExplicitTop = 192
    ExplicitWidth = 0
  end
end
