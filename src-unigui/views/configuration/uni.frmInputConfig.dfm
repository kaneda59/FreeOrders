inherited formBaseConfig: TformBaseConfig
  Caption = 'Configuration'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TUniPanel
    inherited lblTitle: TUniLabel
      Left = 378
      ExplicitLeft = 378
    end
  end
  object pageControl: TUniPageControl
    Left = 0
    Top = 41
    Width = 635
    Height = 224
    Hint = ''
    ActivePage = tbsAPI
    Align = alClient
    TabOrder = 2
    object tbsAPI: TUniTabSheet
      Hint = ''
      Caption = 'API'
      object UniContainerPanel1: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 627
        Height = 196
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 184
        ExplicitTop = 32
        ExplicitWidth = 256
        ExplicitHeight = 128
        object edtHost: TUniEdit
          Left = 128
          Top = 48
          Width = 417
          Hint = ''
          Text = '127.0.0.1'
          TabOrder = 1
          FieldLabel = 'Serveur'
        end
        object edtPort: TUniEdit
          Left = 128
          Top = 76
          Width = 417
          Hint = ''
          MaxLength = 5
          Text = '3000'
          TabOrder = 2
          EmptyText = '65000'
          FieldLabel = 'Port'
        end
        object btnTest: TUniButton
          Left = 128
          Top = 120
          Width = 75
          Height = 25
          Cursor = crHandPoint
          Hint = ''
          Caption = 'Tester'
          TabOrder = 3
          OnClick = btnTestClick
        end
      end
    end
    object tbsAllParams: TUniTabSheet
      Hint = ''
      Caption = 'Date et nombres'
      object grid: TUniStringGrid
        Left = 0
        Top = 0
        Width = 627
        Height = 196
        Hint = ''
        ColCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        Columns = <>
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 40
        ExplicitTop = 16
        ExplicitWidth = 320
        ExplicitHeight = 240
      end
    end
  end
end
