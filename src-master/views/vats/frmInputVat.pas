unit frmInputVat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, classebase, json.tools,//module.vat,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformInputVat = class(TformBaseInput)
    edtLabel: TEdit;
    lblLabel: TLabel;
    edtValue: TEdit;
    lblValue: TLabel;
    procedure edtValueKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    vat: Tvat;
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
  uses cli.datas, configuration;

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

procedure TformInputVat.FormCreate(Sender: TObject);
begin
  inherited;
  FreeAndNil(vat);
end;

procedure TformInputVat.ReadScreen(const id: integer);
begin
  if Assigned(vat) then
  begin
    vat._label:= edtLabel.Text;
    vat._value:= StrToFloat(edtValue.Text);
    setObject(vat, TVat);
  end;
end;

procedure TformInputVat.WriteScreen(const id: integer);
begin
  vat:=  TVat(getObject(id, TVat));
  if Assigned(vat) then
  begin
    edtLabel.Text:= Vat._label;
    edtValue.Text:= FormatFloat('0.00', Vat._value);
  end;
end;

end.
