unit uni.frmInputFamily;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uni.frmBaseInput, uni.frmBase, uniLabel, uniGUIBaseClasses, uniPanel, classebase, json.tools,
  uniButton, uniEdit, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformInputFamily = class(TformBaseInput)
    pnlBody: TUniPanel;
    edtCode: TUniEdit;
    edtLabel: TUniEdit;
    edtDescription: TUniEdit;
    lblCode: TUniLabel;
    lblLabel: TUniLabel;
    lblDescription: TUniLabel;
  private
    { Private declarations }
    Family: TFamily;
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Public declarations }
    class procedure Execute(const id: integer; ResultOK : TOnResultOK);
  end;

function formInputFamily: TformInputFamily;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, uni.cli.datas, configuration;

function formInputFamily: TformInputFamily;
begin
  Result := TformInputFamily(UniMainModule.GetFormInstance(TformInputFamily));
end;

{ TformBase1 }

class procedure TformInputFamily.Execute(const id: integer; ResultOK: TOnResultOK);
begin
  formInputFamily.TitleForm:= 'Fiche Famille';
  formInputFamily.WriteScreen(id);
  formInputFamily.OnResultOK := ResultOK;
  formInputFamily.ShowModal(
  Procedure(Sender: TComponent; Result:Integer)
  begin
    if Result=mrOk then
    begin
      formInputFamily.ReadScreen(id);
      Sleep(1000);
      if Assigned(formInputFamily.OnResultOK) then
      begin
        formInputFamily.OnResultOK(Sender, id);
      end;
    end;
  end);
end;

procedure TformInputFamily.ReadScreen(const id: integer);
begin
  if Assigned(Family) then
  begin
    Family._label      := edtLabel.Text;
    Family._code       := edtCode.Text;
    Family._Description:= edtDescription.Text;
    UniMainModule.microService.setObject(Family, TFamily);
  end;
end;

procedure TformInputFamily.WriteScreen(const id: integer);
begin
  Family:=  TFamily(UniMainModule.microService.getObject(id, TFamily));
  if Assigned(Family) then
  begin
    edtLabel.Text      := Family._label;
    edtCode.Text       := Family._code;
    edtDescription.Text:= Family._Description;
  end;
end;

end.
