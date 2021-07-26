inherited formInputItems: TformInputItems
  Caption = 'formInputItems'
  ClientHeight = 373
  ClientWidth = 638
  OnDestroy = FormDestroy
  ExplicitWidth = 654
  ExplicitHeight = 412
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlheader: TPanel
    Width = 638
    inherited lblTitle: TLabel
      Left = 395
    end
  end
  inherited state: TStatusBar
    Top = 354
    Width = 638
  end
  inherited pnlBottom: TPanel
    Top = 313
    Width = 638
    ExplicitLeft = 0
    ExplicitTop = 295
    ExplicitWidth = 552
  end
  inherited pnlBody: TPanel
    Width = 638
    Height = 272
    ExplicitWidth = 694
    ExplicitHeight = 482
    object libellé: TLabel
      Left = 32
      Top = 75
      Width = 36
      Height = 13
      Caption = 'Libell'#233
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Description: TLabel
      Left = 32
      Top = 102
      Width = 64
      Height = 13
      Caption = 'Description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object PrixVHT: TLabel
      Left = 32
      Top = 129
      Width = 86
      Height = 13
      Caption = 'Prix vente (HT)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 288
      Top = 129
      Width = 85
      Height = 13
      Caption = 'Prix achat (HT)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TVA: TLabel
      Left = 32
      Top = 156
      Width = 22
      Height = 13
      Caption = 'TVA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Fournisseur: TLabel
      Left = 32
      Top = 183
      Width = 66
      Height = 13
      Caption = 'Fournisseur'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Famille: TLabel
      Left = 32
      Top = 211
      Width = 40
      Height = 13
      Caption = 'Famille'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCode: TLabel
      Left = 32
      Top = 48
      Width = 28
      Height = 13
      Caption = 'Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object chkActif: TCheckBox
      Left = 32
      Top = 15
      Width = 97
      Height = 17
      Cursor = crHandPoint
      Caption = ' ACTIF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object edtLabel: TEdit
      Left = 124
      Top = 72
      Width = 249
      Height = 21
      TabOrder = 1
    end
    object edtDescription: TEdit
      Left = 124
      Top = 99
      Width = 489
      Height = 21
      TabOrder = 2
    end
    object edtPvHT: TEdit
      Left = 124
      Top = 126
      Width = 121
      Height = 21
      TabOrder = 3
      OnKeyPress = edtPvHTKeyPress
    end
    object edtPAHT: TEdit
      Left = 380
      Top = 126
      Width = 121
      Height = 21
      TabOrder = 4
      OnKeyPress = edtPvHTKeyPress
    end
    object edtVAT: TEdit
      Left = 124
      Top = 153
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object edtSupplier: TEdit
      Left = 124
      Top = 180
      Width = 249
      Height = 21
      TabOrder = 6
    end
    object edtFamily: TEdit
      Left = 124
      Top = 208
      Width = 249
      Height = 21
      TabOrder = 7
    end
    object btnVAT: TButton
      Left = 246
      Top = 153
      Width = 33
      Height = 23
      Cursor = crHandPoint
      Caption = '...'
      TabOrder = 8
      OnClick = btnVATClick
    end
    object btnSupplier: TButton
      Left = 374
      Top = 179
      Width = 33
      Height = 23
      Cursor = crHandPoint
      Caption = '...'
      TabOrder = 9
      OnClick = btnSupplierClick
    end
    object btnFamily: TButton
      Left = 374
      Top = 207
      Width = 33
      Height = 23
      Cursor = crHandPoint
      Caption = '...'
      TabOrder = 10
      OnClick = btnFamilyClick
    end
    object edtCode: TEdit
      Left = 124
      Top = 45
      Width = 121
      Height = 21
      TabOrder = 11
    end
  end
end
