inherited formBaseInput: TformBaseInput
  Caption = ''
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlheader: TPanel
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 552
  end
  inherited state: TStatusBar
    ExplicitLeft = 0
    ExplicitTop = 336
    ExplicitWidth = 552
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 295
    Width = 552
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 192
    ExplicitTop = 176
    ExplicitWidth = 185
    object btnValid: TButton
      Left = 7
      Top = 8
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = '&Valider'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Cancel = True
      Caption = '&Annuler'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 41
    Width = 552
    Height = 254
    Align = alClient
    TabOrder = 3
    ExplicitTop = 39
  end
end
