unit uni.frmInputVat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uni.frmBaseInput, uni.frmBase, uniLabel,
  uniGUIBaseClasses, uniPanel, uniEdit, uniButton, classebase, json.tools;

type
  TformInputVat = class(TformBaseInput)
    edtLabel: TUniEdit;
    edtValue: TUniEdit;
    lblLabel: TUniLabel;
    lblValue: TUniLabel;
    procedure edtValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    vat: Tvat;
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Public declarations }
    class procedure Execute(const id: integer; ResultOK : TOnResultOK);
  end;

function formInputVat: TformInputVat;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, uni.cli.datas, configuration;

function formInputVat: TformInputVat;
begin
  Result := TformInputVat(UniMainModule.GetFormInstance(TformInputVat));
end;

{ TformBase1 }

procedure TformInputVat.edtValueKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not CharInSet(Key, ['0'..'9', FormatSettings.DecimalSeparator, #8, #9]) then
    Key:= #0;
end;

class procedure TformInputVat.Execute(const id: integer; ResultOK : TOnResultOK);
begin
  //Application.CreateForm(TformInputVat, formInputVat);
  try
    formInputVat.TitleForm:= 'Fiche TVA';
    formInputVat.WriteScreen(id);
    formInputVat.OnResultOK := ResultOK;
    formInputVat.ShowModal(
    Procedure(Sender: TComponent; Result:Integer)
    begin
      if Result=mrOk then
      begin
        formInputVat.ReadScreen(id);
        Sleep(1000);
        if Assigned(formInputVat.OnResultOK) then
        begin
          formInputVat.OnResultOK(Sender, id);
        end;
      end;
    end);
  finally
    //FreeAndNil(formInputVat);
  end;
end;

procedure TformInputVat.ReadScreen(const id: integer);
begin
  if Assigned(vat) then
  begin
    vat._label:= edtLabel.Text;
    vat._value:= StrToFloat(edtValue.Text);
    UniMainModule.microService.setObject(vat, TVat);
  end;
end;

procedure TformInputVat.WriteScreen(const id: integer);
begin
  vat:=  TVat(UniMainModule.microService.getObject(id, TVat));
  if Assigned(vat) then
  begin
    edtLabel.Text:= Vat._label;
    edtValue.Text:= FormatFloat('0.00', Vat._value);
  end;
end;

end.
