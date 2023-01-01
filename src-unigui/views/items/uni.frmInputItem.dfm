inherited formInputItem: TformInputItem
  ClientHeight = 414
  ClientWidth = 624
  Caption = 'Produit'
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  ExplicitWidth = 640
  ExplicitHeight = 453
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TUniPanel
    Width = 624
    ExplicitWidth = 624
    inherited lblTitle: TUniLabel
      Left = 364
      ExplicitLeft = 364
    end
  end
  inherited pnlBottom: TUniPanel
    Top = 380
    Width = 624
    ExplicitTop = 380
    ExplicitWidth = 624
  end
  object pnlBody: TUniPanel
    Left = 0
    Top = 41
    Width = 624
    Height = 339
    Hint = ''
    Align = alClient
    TabOrder = 2
    Caption = ''
    object btnFamille: TUniSpeedButton
      Left = 498
      Top = 248
      Width = 23
      Height = 22
      Cursor = crHandPoint
      Hint = ''
      Caption = '...'
      ParentColor = False
      TabOrder = 13
      OnClick = btnFamilleClick
    end
    object chkActif: TUniCheckBox
      Left = 24
      Top = 57
      Width = 97
      Height = 17
      Hint = ''
      Caption = 'Actif'
      TabOrder = 1
    end
    object edtCode: TUniEdit
      Left = 24
      Top = 80
      Width = 205
      Hint = ''
      Text = ''
      TabOrder = 2
      FieldLabel = 'Code'
    end
    object edtLibelle: TUniEdit
      Left = 24
      Top = 108
      Width = 348
      Hint = ''
      Text = ''
      TabOrder = 3
      FieldLabel = 'Libell'#233
    end
    object edtDescription: TUniEdit
      Left = 24
      Top = 136
      Width = 580
      Hint = ''
      Text = ''
      TabOrder = 4
      FieldLabel = 'Description'
    end
    object edtPvHT: TUniEdit
      Left = 24
      Top = 164
      Width = 205
      Hint = ''
      Text = ''
      TabOrder = 5
      FieldLabel = 'Prix vente (HT)'
    end
    object edtPAHT: TUniEdit
      Left = 371
      Top = 164
      Width = 233
      Hint = ''
      Text = ''
      TabOrder = 6
      FieldLabel = 'Prix achat (HT)'
    end
    object edtTVA: TUniEdit
      Left = 24
      Top = 192
      Width = 284
      Hint = ''
      Text = ''
      TabOrder = 7
      FieldLabel = 'TVA'
    end
    object edtFournisseur: TUniEdit
      Left = 24
      Top = 220
      Width = 468
      Hint = ''
      Text = ''
      TabOrder = 8
      FieldLabel = 'Fournisseur'
    end
    object edtFamille: TUniEdit
      Left = 24
      Top = 248
      Width = 468
      Hint = ''
      Text = ''
      TabOrder = 9
      FieldLabel = 'Famille'
    end
    object btnTVA: TUniSpeedButton
      Left = 312
      Top = 192
      Width = 23
      Height = 22
      Cursor = crHandPoint
      Hint = ''
      Caption = '...'
      ParentColor = False
      TabOrder = 10
      OnClick = btnTVAClick
    end
    object btnFournisseur: TUniSpeedButton
      Left = 496
      Top = 219
      Width = 23
      Height = 22
      Cursor = crHandPoint
      Hint = ''
      Caption = '...'
      ParentColor = False
      TabOrder = 11
      OnClick = btnFournisseurClick
    end
    object btnFamily: TUniSpeedButton
      Left = 496
      Top = 248
      Width = 23
      Height = 22
      Cursor = crHandPoint
      Hint = ''
      Caption = '...'
      ParentColor = False
      TabOrder = 12
      OnClick = btnFamilleClick
    end
  end
end
