inherited formInputConfiguration: TformInputConfiguration
  Caption = 'formInputConfiguration'
  ExplicitWidth = 568
  ExplicitHeight = 394
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBottom: TPanel
    ExplicitLeft = 0
    ExplicitTop = 295
    ExplicitWidth = 552
  end
  inherited pnlBody: TPanel
    ExplicitTop = 41
    object pgConfig: TPageControl
      Left = 1
      Top = 1
      Width = 550
      Height = 252
      ActivePage = tsmORMot
      Align = alClient
      TabOrder = 0
      object tsmORMot: TTabSheet
        Caption = 'APIs'
        ImageIndex = 2
        ExplicitLeft = 6
        ExplicitTop = 23
        object lblHost: TLabel
          Left = 52
          Top = 67
          Width = 38
          Height = 13
          Caption = 'Serveur'
        end
        object lblPort: TLabel
          Left = 52
          Top = 94
          Width = 20
          Height = 13
          Caption = 'Port'
        end
        object lblAppId: TLabel
          Left = 52
          Top = 121
          Width = 50
          Height = 13
          Caption = 'Identifiant'
        end
        object edtHost: TEdit
          Left = 115
          Top = 64
          Width = 361
          Height = 21
          TabOrder = 0
        end
        object edtPort: TEdit
          Left = 115
          Top = 91
          Width = 110
          Height = 21
          TabOrder = 1
        end
        object edAppId: TEdit
          Left = 115
          Top = 118
          Width = 361
          Height = 21
          TabOrder = 2
        end
      end
      object tsConnection: TTabSheet
        Caption = 'Connexion'
        object grpDatabase: TGroupBox
          Left = 16
          Top = 16
          Width = 505
          Height = 105
          Caption = ' Base de donn'#233'es '
          TabOrder = 0
          object edtFileDataBaseName: TEdit
            Left = 16
            Top = 32
            Width = 393
            Height = 21
            TabOrder = 0
            OnChange = edtFileDataBaseNameChange
          end
          object btnSelectFile: TButton
            Left = 415
            Top = 30
            Width = 75
            Height = 25
            Cursor = crHandPoint
            Caption = 'Choisir'
            TabOrder = 1
            OnClick = btnSelectFileClick
          end
          object btnTest: TButton
            Left = 16
            Top = 59
            Width = 75
            Height = 25
            Cursor = crHandPoint
            Caption = 'Tester'
            TabOrder = 2
            OnClick = btnTestClick
          end
        end
        object grpTools: TGroupBox
          Left = 16
          Top = 128
          Width = 505
          Height = 85
          Caption = ' Outils '
          TabOrder = 1
          object btnExport: TButton
            Left = 16
            Top = 32
            Width = 161
            Height = 25
            Cursor = crHandPoint
            Caption = 'Exporter'
            TabOrder = 0
            OnClick = btnExportClick
          end
          object btnImport: TButton
            Left = 183
            Top = 32
            Width = 161
            Height = 25
            Cursor = crHandPoint
            Caption = 'Importer'
            TabOrder = 1
            OnClick = btnImportClick
          end
        end
      end
      object tsFormatSettings: TTabSheet
        Caption = 'date et nombres'
        ImageIndex = 1
        object grid: TStringGrid
          Left = 83
          Top = 16
          Width = 345
          Height = 193
          ColCount = 2
          TabOrder = 0
          ColWidths = (
            99
            217)
        end
      end
    end
  end
end
