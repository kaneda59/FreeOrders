inherited formInputFamily: TformInputFamily
  ClientHeight = 218
  ClientWidth = 546
  Caption = 'formInputFamily'
  ExplicitWidth = 562
  ExplicitHeight = 257
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TUniPanel
    Width = 546
    ExplicitWidth = 546
    inherited lblTitle: TUniLabel
      Left = 278
      Top = 10
      ExplicitLeft = 278
      ExplicitTop = 10
    end
  end
  inherited pnlBottom: TUniPanel
    Top = 184
    Width = 546
    ExplicitTop = 194
    ExplicitWidth = 546
    inherited btnValid: TUniButton
      Caption = 'Enregistrer'
    end
  end
  object pnlBody: TUniPanel
    Left = 0
    Top = 41
    Width = 546
    Height = 143
    Hint = ''
    Align = alClient
    TabOrder = 2
    Caption = ''
    ExplicitHeight = 153
    object edtCode: TUniEdit
      Left = 89
      Top = 32
      Width = 121
      Hint = ''
      Text = ''
      TabOrder = 1
    end
    object edtLabel: TUniEdit
      Left = 89
      Top = 60
      Width = 281
      Hint = ''
      Text = ''
      TabOrder = 2
    end
    object edtDescription: TUniEdit
      Left = 89
      Top = 88
      Width = 433
      Hint = ''
      Text = ''
      TabOrder = 3
    end
    object lblCode: TUniLabel
      Left = 14
      Top = 35
      Width = 25
      Height = 13
      Hint = ''
      Caption = 'Code'
      TabOrder = 4
    end
    object lblLabel: TUniLabel
      Left = 14
      Top = 63
      Width = 29
      Height = 13
      Hint = ''
      Caption = 'Libell'#233
      TabOrder = 6
    end
    object lblDescription: TUniLabel
      Left = 14
      Top = 90
      Width = 53
      Height = 13
      Hint = ''
      Caption = 'Description'
      TabOrder = 5
    end
  end
end
