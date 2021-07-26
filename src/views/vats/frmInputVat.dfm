inherited formInputVat: TformInputVat
  ClientHeight = 219
  ExplicitHeight = 258
  PixelsPerInch = 96
  TextHeight = 13
  inherited state: TStatusBar
    Top = 200
  end
  inherited pnlBottom: TPanel
    Top = 159
  end
  inherited pnlBody: TPanel
    Height = 118
    object lblLabel: TLabel
      Left = 72
      Top = 35
      Width = 29
      Height = 13
      Caption = 'Libell'#233
    end
    object lblValue: TLabel
      Left = 72
      Top = 59
      Width = 30
      Height = 13
      Caption = 'Valeur'
    end
    object edtLabel: TEdit
      Left = 144
      Top = 32
      Width = 321
      Height = 21
      TabOrder = 0
    end
    object edtValue: TEdit
      Left = 144
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 1
      OnKeyPress = edtValueKeyPress
    end
  end
end
