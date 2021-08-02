inherited formInputDelivery: TformInputDelivery
  Caption = 'formInputDelivery'
  ClientHeight = 228
  ClientWidth = 440
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 456
  ExplicitHeight = 267
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlheader: TPanel
    Width = 440
    inherited lblTitle: TLabel
      Left = 197
    end
  end
  inherited state: TStatusBar
    Top = 209
    Width = 440
  end
  inherited pnlBottom: TPanel
    Top = 168
    Width = 440
    ExplicitLeft = 0
    ExplicitTop = 295
    ExplicitWidth = 552
  end
  inherited pnlBody: TPanel
    Width = 440
    Height = 127
    ExplicitWidth = 440
    ExplicitHeight = 127
    object lblState: TLabel
      Left = 44
      Top = 76
      Width = 100
      Height = 13
      Caption = 'Etat de la commande'
    end
    object lblInformation: TLabel
      Left = 18
      Top = 7
      Width = 409
      Height = 13
      Caption = 
        'Vous ne pouvez pas modifier l'#39#233'tat d'#39'une commande '#224' un '#233'tat pr'#233'c' +
        #233'dent'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCommande: TLabel
      Left = 18
      Top = 38
      Width = 116
      Height = 19
      Caption = 'Commande N'#176
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object cbbStatut: TComboBox
      Left = 168
      Top = 73
      Width = 225
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbbStatutChange
    end
  end
end
