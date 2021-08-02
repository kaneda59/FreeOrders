inherited formInputOrders: TformInputOrders
  Caption = 'formInputOrders'
  ClientHeight = 540
  ClientWidth = 779
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 795
  ExplicitHeight = 579
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlheader: TPanel
    Width = 779
    inherited lblTitle: TLabel
      Left = 536
    end
  end
  inherited state: TStatusBar
    Top = 521
    Width = 779
  end
  inherited pnlBottom: TPanel
    Top = 480
    Width = 779
    ExplicitLeft = 0
    ExplicitTop = 295
    ExplicitWidth = 552
  end
  inherited pnlBody: TPanel
    Width = 779
    Height = 439
    ExplicitWidth = 712
    ExplicitHeight = 439
    object pnlread: TPanel
      Left = 1
      Top = 1
      Width = 777
      Height = 200
      Align = alTop
      TabOrder = 0
      ExplicitTop = -2
      object grpHeader: TGroupBox
        Left = 8
        Top = 8
        Width = 762
        Height = 89
        Caption = ' Ent'#234'te '
        TabOrder = 0
        object lblState: TLabel
          Left = 659
          Top = 16
          Width = 95
          Height = 23
          Alignment = taRightJustify
          Caption = 'Cr'#233'ation'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Tahoma'
          Font.Style = [fsBold, fsItalic]
          ParentFont = False
        end
        object Code: TLabel
          Left = 16
          Top = 32
          Width = 25
          Height = 13
          Caption = 'Code'
        end
        object lblClient: TLabel
          Left = 16
          Top = 54
          Width = 27
          Height = 13
          Caption = 'Client'
        end
        object lblDate: TLabel
          Left = 632
          Top = 49
          Width = 122
          Height = 19
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'Le __/__/____'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBiDiMode = False
          ParentFont = False
        end
        object edtClient: TEdit
          Left = 79
          Top = 51
          Width = 289
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
        object edtCode: TEdit
          Left = 79
          Top = 24
          Width = 193
          Height = 21
          TabOrder = 1
        end
        object btnClient: TButton
          Left = 369
          Top = 49
          Width = 33
          Height = 25
          Cursor = crHandPoint
          Caption = '...'
          TabOrder = 2
          OnClick = btnClientClick
        end
      end
      object grpItems: TGroupBox
        Left = 8
        Top = 103
        Width = 617
        Height = 54
        Caption = ' Produits '
        TabOrder = 1
        object edtCodeProduit: TEdit
          Left = 9
          Top = 24
          Width = 104
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
        object edtQte: TEdit
          Left = 480
          Top = 24
          Width = 65
          Height = 21
          TabOrder = 1
          OnKeyPress = edtQteKeyPress
        end
        object btnProduit: TButton
          Left = 114
          Top = 22
          Width = 33
          Height = 25
          Cursor = crHandPoint
          Caption = '...'
          TabOrder = 2
          OnClick = btnProduitClick
        end
        object btnAdd: TButton
          Tag = 100
          Left = 153
          Top = 22
          Width = 56
          Height = 25
          Cursor = crHandPoint
          Caption = 'Ajouter'
          TabOrder = 3
          OnClick = OnLineClick
        end
        object btnUpdate: TButton
          Tag = 101
          Left = 212
          Top = 22
          Width = 56
          Height = 25
          Cursor = crHandPoint
          Caption = 'modifier'
          TabOrder = 4
          OnClick = OnLineClick
        end
        object btnDelete: TButton
          Tag = 102
          Left = 271
          Top = 22
          Width = 56
          Height = 25
          Cursor = crHandPoint
          Caption = 'supprimer'
          TabOrder = 5
          OnClick = OnLineClick
        end
        object edtRemise: TEdit
          Left = 545
          Top = 24
          Width = 72
          Height = 21
          TabOrder = 6
          OnKeyPress = edtQteKeyPress
        end
      end
    end
    object grid: TStringGrid
      Left = 1
      Top = 201
      Width = 777
      Height = 215
      Align = alClient
      ColCount = 8
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 1
      OnClick = gridClick
      ExplicitTop = 195
      ColWidths = (
        97
        258
        64
        64
        64
        64
        64
        64)
    end
    object pnlSummer: TPanel
      Left = 1
      Top = 416
      Width = 777
      Height = 22
      Align = alBottom
      TabOrder = 2
      ExplicitTop = 415
      ExplicitWidth = 710
      object edtTotal: TEdit
        Left = 639
        Top = 0
        Width = 113
        Height = 21
        Alignment = taRightJustify
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
end
