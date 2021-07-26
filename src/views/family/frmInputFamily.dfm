inherited formInputFamily: TformInputFamily
  Caption = 'formInputFamily'
  ClientHeight = 291
  OnDestroy = FormDestroy
  ExplicitHeight = 330
  PixelsPerInch = 96
  TextHeight = 13
  inherited state: TStatusBar
    Top = 272
  end
  inherited pnlBottom: TPanel
    Top = 231
    ExplicitLeft = 0
    ExplicitTop = 295
    ExplicitWidth = 552
  end
  inherited pnlBody: TPanel
    Height = 190
    ExplicitTop = 41
    object Label1: TLabel
      Left = 29
      Top = 64
      Width = 25
      Height = 13
      Caption = 'Code'
    end
    object lbl1: TLabel
      Left = 29
      Top = 88
      Width = 29
      Height = 13
      Caption = 'Libell'#233
    end
    object lbl2: TLabel
      Left = 29
      Top = 113
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object edtCode: TEdit
      Left = 104
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object edtLabel: TEdit
      Left = 104
      Top = 83
      Width = 249
      Height = 21
      TabOrder = 1
    end
    object edtDescription: TEdit
      Left = 104
      Top = 110
      Width = 417
      Height = 21
      TabOrder = 2
    end
  end
end
