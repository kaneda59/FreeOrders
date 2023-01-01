object formBase: TformBase
  Left = 0
  Top = 0
  ClientHeight = 299
  ClientWidth = 635
  Caption = 'formBase'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TUniPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 41
    Hint = ''
    Align = alTop
    TabOrder = 0
    Caption = ''
    Color = clActiveCaption
    DesignSize = (
      635
      41)
    object UniLabel1: TUniLabel
      Left = 13
      Top = 12
      Width = 27
      Height = 19
      Hint = ''
      Caption = 'free'
      ParentFont = False
      Font.Color = clWhite
      Font.Height = -16
      TabOrder = 1
    end
    object lblOrder: TUniLabel
      Left = 43
      Top = 5
      Width = 89
      Height = 29
      Hint = ''
      AutoSize = False
      Caption = 'Orders'
      ParentFont = False
      Font.Height = -24
      Font.Style = [fsBold, fsItalic]
      TabOrder = 2
    end
    object lblTitle: TUniLabel
      Left = 375
      Top = 15
      Width = 257
      Height = 23
      Hint = ''
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lblTitle'
      Anchors = [akTop, akRight]
      ParentFont = False
      Font.Color = clWhite
      Font.Height = -19
      Font.Style = [fsBold, fsItalic]
      TabOrder = 3
    end
  end
  object pnlBottom: TUniPanel
    Left = 0
    Top = 265
    Width = 635
    Height = 34
    Hint = ''
    Align = alBottom
    TabOrder = 1
    Caption = ''
    object btnValid: TUniButton
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Hint = ''
      Caption = 'Choisir'
      ModalResult = 1
      TabOrder = 1
    end
    object btnCancel: TUniButton
      Left = 89
      Top = 6
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Hint = ''
      Caption = 'Annuler'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
