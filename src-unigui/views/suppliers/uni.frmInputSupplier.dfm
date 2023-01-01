inherited forInputSupplier: TforInputSupplier
  ClientHeight = 446
  Caption = 'Fournisseur'
  ExplicitHeight = 485
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TUniPanel
    Top = 412
    ExplicitLeft = -3
    ExplicitTop = 372
  end
  object MainContenair1: TUniContainerPanel
    Left = 0
    Top = 41
    Width = 635
    Height = 371
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 1
    ExplicitTop = 40
    ExplicitHeight = 325
    object edtLabel: TUniEdit
      Left = 120
      Top = 16
      Width = 241
      Hint = ''
      Text = ''
      TabOrder = 1
      FieldLabel = 'Libell'#233
    end
    object edtDescription: TUniEdit
      Left = 120
      Top = 44
      Width = 481
      Hint = ''
      Text = ''
      TabOrder = 2
      FieldLabel = 'Description'
    end
    object edtAddress: TUniEdit
      Left = 120
      Top = 72
      Width = 481
      Hint = ''
      Text = ''
      TabOrder = 3
      FieldLabel = 'Adresse'
    end
    object edtComplement: TUniEdit
      Left = 120
      Top = 100
      Width = 481
      Hint = ''
      Text = ''
      TabOrder = 4
      FieldLabel = 'Compl'#233'ment'
    end
    object edtCity: TUniEdit
      Left = 120
      Top = 128
      Width = 241
      Hint = ''
      Text = ''
      TabOrder = 5
      FieldLabel = 'Ville'
    end
    object edtZipCode: TUniEdit
      Left = 120
      Top = 156
      Width = 241
      Hint = ''
      MaxLength = 6
      Text = ''
      TabOrder = 6
      EmptyText = '     '
      ClearButton = True
      FieldLabel = 'Code Postal'
      InputType = 'number'
    end
    object edtLand: TUniEdit
      Left = 120
      Top = 185
      Width = 241
      Hint = ''
      Text = ''
      TabOrder = 7
      FieldLabel = 'Pays'
    end
    object edtPhoneNumber: TUniEdit
      Left = 120
      Top = 213
      Width = 241
      Hint = ''
      Text = ''
      TabOrder = 8
      FieldLabel = 'Fixe'
    end
    object edtMobile: TUniEdit
      Left = 120
      Top = 241
      Width = 241
      Hint = ''
      Text = ''
      TabOrder = 9
      FieldLabel = 'Portable'
    end
    object edtAccount: TUniEdit
      Left = 120
      Top = 269
      Width = 241
      Hint = ''
      Text = ''
      TabOrder = 10
      FieldLabel = 'Compte'
    end
    object edtMail: TUniEdit
      Left = 120
      Top = 297
      Width = 481
      Hint = ''
      Text = ''
      TabOrder = 11
      FieldLabel = 'Mail'
    end
  end
end
