inherited formInputOrders: TformInputOrders
  ClientHeight = 806
  ClientWidth = 854
  Caption = 'Commande'
  BorderStyle = bsNone
  ExplicitTop = 0
  ExplicitWidth = 854
  ExplicitHeight = 806
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TUniPanel
    Width = 854
    inherited lblTitle: TUniLabel
      Left = 594
    end
  end
  inherited pnlBottom: TUniPanel
    Top = 772
    Width = 854
  end
  object UniContainerPanel1: TUniContainerPanel
    Left = 0
    Top = 41
    Width = 854
    Height = 731
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 2
    ExplicitTop = 40
    ExplicitWidth = 838
    ExplicitHeight = 515
    object UniPanel1: TUniPanel
      Left = 0
      Top = 0
      Width = 854
      Height = 144
      Hint = ''
      Align = alTop
      TabOrder = 1
      Caption = ''
      ExplicitWidth = 838
      object grpHeader: TUniGroupBox
        Left = 1
        Top = 1
        Width = 852
        Height = 142
        Hint = ''
        Caption = ' Ent'#234'te '
        Align = alClient
        TabOrder = 1
        ParentFont = False
        ExplicitLeft = 3
        ExplicitTop = 6
        ExplicitWidth = 829
        ExplicitHeight = 105
        object edtCode: TUniEdit
          Left = 56
          Top = 24
          Width = 233
          Hint = ''
          Text = ''
          TabOrder = 1
          FieldLabel = 'Code'
        end
        object edtClient: TUniEdit
          Left = 56
          Top = 64
          Width = 337
          Hint = ''
          Text = ''
          TabOrder = 2
          FieldLabel = 'Client'
        end
        object lbState: TUniLabel
          Left = 720
          Top = 20
          Width = 81
          Height = 23
          Hint = ''
          Alignment = taRightJustify
          Caption = 'Cr'#233'ation'
          ParentFont = False
          Font.Height = -19
          Font.Style = [fsBold, fsItalic]
          TabOrder = 3
        end
        object lblDate: TUniLabel
          Left = 680
          Top = 56
          Width = 122
          Height = 19
          Hint = ''
          Alignment = taRightJustify
          Caption = 'Le __/__/____'
          ParentFont = False
          Font.Height = -16
          Font.Style = [fsBold]
          TabOrder = 4
        end
        object btnClient: TUniButton
          Left = 393
          Top = 63
          Width = 33
          Height = 25
          Cursor = crHandPoint
          Hint = ''
          Caption = '...'
          TabOrder = 5
        end
      end
    end
    object pnlHeader1: TUniPanel
      Left = 0
      Top = 144
      Width = 854
      Height = 99
      Hint = ''
      Align = alTop
      TabOrder = 2
      Caption = ''
      ExplicitTop = 118
      ExplicitWidth = 838
      object grpItems: TUniGroupBox
        Left = 1
        Top = 1
        Width = 852
        Height = 97
        Hint = ''
        Caption = ' Produits '
        Align = alClient
        TabOrder = 1
        ParentFont = False
        ExplicitTop = -4
        ExplicitWidth = 836
        ExplicitHeight = 217
        object edtItem: TUniEdit
          Left = 3
          Top = 29
          Width = 126
          Hint = ''
          Text = ''
          ParentFont = False
          TabOrder = 1
        end
        object btnSearchItem: TUniButton
          Left = 135
          Top = 28
          Width = 33
          Height = 25
          Cursor = crHandPoint
          Hint = ''
          Caption = '...'
          ParentFont = False
          TabOrder = 2
        end
        object edtQte: TUniEdit
          Left = 472
          Top = 31
          Width = 65
          Hint = ''
          Alignment = taRightJustify
          Text = '0'
          ParentFont = False
          TabOrder = 3
          FieldLabel = 'Qt'#233
          FieldLabelWidth = 30
        end
        object edtRemise: TUniEdit
          Left = 642
          Top = 31
          Width = 65
          Hint = ''
          Alignment = taRightJustify
          Text = '0'
          ParentFont = False
          TabOrder = 4
          FieldLabel = 'Remise'
          FieldLabelWidth = 40
        end
        object btnAdd: TUniButton
          Left = 176
          Top = 28
          Width = 75
          Height = 25
          Cursor = crHandPoint
          Hint = ''
          Caption = 'Ajouter'
          TabOrder = 5
        end
        object btnupdate: TUniButton
          Left = 253
          Top = 28
          Width = 75
          Height = 25
          Cursor = crHandPoint
          Hint = ''
          Caption = 'Modifier'
          TabOrder = 6
        end
        object btnDelete: TUniButton
          Left = 330
          Top = 28
          Width = 75
          Height = 25
          Cursor = crHandPoint
          Hint = ''
          Caption = 'supprimer'
          TabOrder = 7
        end
      end
    end
    object grid: TUniStringGrid
      Left = 0
      Top = 243
      Width = 854
      Height = 453
      Hint = ''
      FixedCols = 0
      ColCount = 8
      Columns = <>
      Align = alClient
      TabOrder = 3
      ParentFont = False
      ExplicitLeft = -1
      ExplicitWidth = 838
      ExplicitHeight = 414
    end
    object pnlHeader2: TUniPanel
      Left = 0
      Top = 696
      Width = 854
      Height = 35
      Hint = ''
      Align = alBottom
      TabOrder = 4
      Caption = ''
      ExplicitTop = 480
      ExplicitWidth = 838
      object edtTotal: TUniEdit
        Left = 603
        Top = 6
        Width = 201
        Hint = ''
        Alignment = taRightJustify
        Text = '0.00'
        ParentFont = False
        TabOrder = 1
        FieldLabel = 'Total'
      end
    end
  end
end
