inherited formInputSupplier: TformInputSupplier
  Caption = 'formInputSupplier'
  ClientHeight = 519
  ClientWidth = 658
  OnDestroy = FormDestroy
  ExplicitWidth = 674
  ExplicitHeight = 558
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlheader: TPanel
    Width = 658
    ExplicitWidth = 658
    inherited lblTitle: TLabel
      Left = 415
      ExplicitLeft = 415
    end
  end
  inherited state: TStatusBar
    Top = 500
    Width = 658
    ExplicitTop = 500
    ExplicitWidth = 658
  end
  inherited pnlBottom: TPanel
    Top = 459
    Width = 658
    ExplicitTop = 459
    ExplicitWidth = 658
  end
  inherited pnlBody: TPanel
    Width = 658
    Height = 418
    ExplicitWidth = 658
    ExplicitHeight = 418
    object Label1: TLabel
      Left = 85
      Top = 87
      Width = 34
      Height = 13
      Caption = 'Intitul'#233
    end
    object Label2: TLabel
      Left = 85
      Top = 113
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object Label3: TLabel
      Left = 85
      Top = 142
      Width = 39
      Height = 13
      Caption = 'Adresse'
    end
    object Label4: TLabel
      Left = 85
      Top = 167
      Width = 59
      Height = 13
      Caption = 'Compl'#233'ment'
    end
    object Label5: TLabel
      Left = 85
      Top = 196
      Width = 18
      Height = 13
      Caption = 'Ville'
    end
    object Label6: TLabel
      Left = 85
      Top = 223
      Width = 57
      Height = 13
      Caption = 'Code Postal'
    end
    object Label7: TLabel
      Left = 85
      Top = 250
      Width = 23
      Height = 13
      Caption = 'Pays'
    end
    object Label8: TLabel
      Left = 85
      Top = 277
      Width = 50
      Height = 13
      Caption = 'T'#233'l'#233'phone'
    end
    object Label9: TLabel
      Left = 85
      Top = 304
      Width = 40
      Height = 13
      Caption = 'Portable'
    end
    object Label10: TLabel
      Left = 85
      Top = 60
      Width = 67
      Height = 13
      Caption = 'N'#176' de Compte'
    end
    object Label11: TLabel
      Left = 85
      Top = 331
      Width = 18
      Height = 13
      Caption = 'Mail'
    end
    object edtLabel: TEdit
      Left = 177
      Top = 84
      Width = 231
      Height = 21
      TabOrder = 0
    end
    object edtDescription: TEdit
      Left = 177
      Top = 110
      Width = 231
      Height = 21
      TabOrder = 1
    end
    object edtAddress: TEdit
      Left = 177
      Top = 137
      Width = 344
      Height = 21
      TabOrder = 2
    end
    object edtComplement: TEdit
      Left = 177
      Top = 164
      Width = 344
      Height = 21
      TabOrder = 3
    end
    object edtCity: TEdit
      Left = 177
      Top = 193
      Width = 231
      Height = 21
      TabOrder = 4
    end
    object edtZipCode: TEdit
      Left = 177
      Top = 220
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object edtLand: TEdit
      Left = 177
      Top = 247
      Width = 121
      Height = 21
      TabOrder = 6
    end
    object edtPhonenumber: TEdit
      Left = 177
      Top = 274
      Width = 121
      Height = 21
      TabOrder = 7
    end
    object edtMobile: TEdit
      Left = 177
      Top = 301
      Width = 121
      Height = 21
      TabOrder = 8
    end
    object edtAccount: TEdit
      Left = 177
      Top = 57
      Width = 231
      Height = 21
      TabOrder = 9
    end
    object edtMail: TEdit
      Left = 177
      Top = 328
      Width = 231
      Height = 21
      TabOrder = 10
    end
  end
end
