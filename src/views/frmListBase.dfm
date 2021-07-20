inherited FormBaseList: TFormBaseList
  Caption = 'FormBaseList'
  ClientHeight = 414
  ClientWidth = 618
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 634
  ExplicitHeight = 453
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlheader: TPanel
    Width = 618
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 552
    DesignSize = (
      618
      41)
    inherited LblFree: TLabel
      Top = 11
      ExplicitTop = 11
    end
    inherited lblTitle: TLabel
      Left = 375
    end
  end
  inherited state: TStatusBar
    Top = 395
    Width = 618
    ExplicitLeft = 0
    ExplicitTop = 336
    ExplicitWidth = 552
  end
  object dbgrd: TDBGrid
    Left = 0
    Top = 81
    Width = 618
    Height = 273
    Cursor = crHandPoint
    Align = alClient
    DataSource = ds
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = dbgrdDblClick
  end
  object pnlSearch: TPanel
    Left = 0
    Top = 41
    Width = 618
    Height = 40
    Align = alTop
    TabOrder = 3
    ExplicitWidth = 552
    object edtSearch: TEdit
      Left = 8
      Top = 8
      Width = 145
      Height = 21
      TabOrder = 0
    end
    object btnSearch: TButton
      Left = 154
      Top = 6
      Width = 25
      Height = 25
      Cursor = crHandPoint
      Caption = '...'
      TabOrder = 1
      OnClick = btnSearchClick
    end
    object pnlRight: TPanel
      Left = 368
      Top = 1
      Width = 249
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      Caption = 'pnlRight'
      TabOrder = 2
      object btnNew: TButton
        Left = 8
        Top = 4
        Width = 75
        Height = 25
        Cursor = crHandPoint
        Caption = 'Ajouter'
        TabOrder = 0
      end
      object btnUpdate: TButton
        Left = 89
        Top = 4
        Width = 75
        Height = 25
        Cursor = crHandPoint
        Caption = 'Modifier'
        TabOrder = 1
      end
      object btnDelete: TButton
        Left = 170
        Top = 4
        Width = 75
        Height = 25
        Cursor = crHandPoint
        Caption = 'Supprimer'
        TabOrder = 2
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 354
    Width = 618
    Height = 41
    Align = alBottom
    TabOrder = 4
    ExplicitLeft = 224
    ExplicitTop = 208
    ExplicitWidth = 185
    object btnCancel: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Cancel = True
      Caption = '&Annuler'
      ModalResult = 2
      TabOrder = 0
    end
    object btnValid: TButton
      Left = 7
      Top = 8
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = '&Choisir'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object ds: TDataSource
    DataSet = qryList
    OnDataChange = dsDataChange
    Left = 216
    Top = 144
  end
  object qryList: TADOQuery
    AfterOpen = qryListAfterOpen
    Parameters = <>
    Left = 296
    Top = 184
  end
end
