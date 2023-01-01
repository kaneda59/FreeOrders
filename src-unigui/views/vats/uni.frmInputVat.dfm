inherited formInputVat: TformInputVat
  ClientHeight = 183
  ClientWidth = 405
  Caption = 'TVA'
  ExplicitWidth = 421
  ExplicitHeight = 222
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TUniPanel
    Width = 405
    ExplicitWidth = 405
    inherited lblTitle: TUniLabel
      Left = 145
      ExplicitLeft = 145
    end
  end
  inherited pnlBottom: TUniPanel
    Top = 149
    Width = 405
    ExplicitTop = 149
    ExplicitWidth = 405
  end
  object edtLabel: TUniEdit
    Left = 72
    Top = 72
    Width = 297
    Hint = ''
    Text = ''
    TabOrder = 2
  end
  object edtValue: TUniEdit
    Left = 72
    Top = 100
    Width = 92
    Hint = ''
    Text = ''
    TabOrder = 3
    OnKeyPress = edtValueKeyPress
  end
  object lblLabel: TUniLabel
    Left = 24
    Top = 77
    Width = 29
    Height = 13
    Hint = ''
    Caption = 'Libell'#233
    TabOrder = 4
  end
  object lblValue: TUniLabel
    Left = 23
    Top = 104
    Width = 30
    Height = 13
    Hint = ''
    Caption = 'Valeur'
    TabOrder = 5
  end
end
