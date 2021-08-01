inherited formAbout: TformAbout
  BorderStyle = bsToolWindow
  Caption = 'A propos'
  ClientHeight = 365
  ClientWidth = 562
  PixelsPerInch = 96
  TextHeight = 13
  object lblSociete: TLabel [0]
    Left = 229
    Top = 72
    Width = 299
    Height = 49
    Caption = 'LesBonsPlans.com'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Tempus Sans ITC'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object lblCopyright: TLabel [1]
    Left = 16
    Top = 128
    Width = 92
    Height = 13
    Caption = #169'2021. by Kaneda'
  end
  object lblInformations: TLabel [2]
    Left = 16
    Top = 152
    Width = 471
    Height = 13
    Caption = 
      'ce programme est un outil de test libre de droits d'#233'velopp'#233's dan' +
      's le cadre du livre Delphi & mORMot'
  end
  object lblInformations2: TLabel [3]
    Left = 16
    Top = 168
    Width = 415
    Height = 13
    Caption = 
      'Il s'#39'agit d'#39'un programme classique qui sera modifi'#233' pour impl'#233'me' +
      'nter des micro-services'
  end
  object lblInformations3: TLabel [4]
    Left = 16
    Top = 200
    Width = 127
    Height = 13
    Caption = 'code source disponible ici :'
  end
  object lblURL: TLabel [5]
    Left = 152
    Top = 200
    Width = 216
    Height = 13
    Cursor = crHandPoint
    Caption = 'https://github.com/kaneda59/FreeOrders.git'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsItalic, fsUnderline]
    ParentFont = False
  end
  inherited pnlheader: TPanel
    Width = 562
    inherited lblTitle: TLabel
      Left = 319
    end
  end
  inherited state: TStatusBar
    Top = 346
    Width = 562
  end
  object btnClose: TButton
    Left = 16
    Top = 315
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'Fermer'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
end
