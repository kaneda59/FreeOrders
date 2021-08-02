unit frmInputVat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, module.vat,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformInputVat = class(TformBaseInput)
    edtLabel: TEdit;
    lblLabel: TLabel;
    edtValue: TEdit;
    lblValue: TLabel;
    procedure edtValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Déclarations publiques }
    class function Execute(const id: integer): Boolean;
  end;

var
  formInputVat: TformInputVat;

implementation

{$R *.dfm}

{ TformInputVat }

procedure TformInputVat.edtValueKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not CharInSet(Key, ['0'..'9', FormatSettings.DecimalSeparator, #8, #9]) then
    Key:= #0;
end;

class function TformInputVat.Execute(const id: integer): Boolean;
begin
  Application.CreateForm(TformInputVat, formInputVat);
  try
    formInputVat.TitleForm:= 'Fiche TVA';
    formInputVat.WriteScreen(id);
    result:= formInputVat.ShowModal = mrOk;
    if result then
      formInputVat.ReadScreen(id);
  finally
    FreeAndNil(formInputVat);
  end;
end;

procedure TformInputVat.ReadScreen(const id: integer);
begin
  mVat.Vat._label:= edtLabel.Text;
  mVat.Vat._value:= StrToFloat(edtValue.Text);
  mVat.Write;
end;

procedure TformInputVat.WriteScreen(const id: integer);
begin
  mVat:= TModule_Vat.create(id);
  mVat.Read;

  edtLabel.Text:= mVat.Vat._label;
  edtValue.Text:= FormatFloat('0.00', mVat.Vat._value);
end;

end.
