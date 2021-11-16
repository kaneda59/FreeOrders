unit frmInputFamily;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, classebase, json.tools,//module.family,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformInputFamily = class(TformBaseInput)
    edtCode: TEdit;
    edtLabel: TEdit;
    edtDescription: TEdit;
    Label1: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    family: TFamily;
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Déclarations publiques }
    class function Execute(const id: integer): Boolean;
  end;

var
  formInputFamily: TformInputFamily;

implementation

{$R *.dfm}
uses //Module,
     Logs, Consts_, cli.datas, configuration;

{ TformInputFamily }

class function TformInputFamily.Execute(const id: integer): Boolean;
begin
  Application.CreateForm(TformInputFamily, formInputFamily);
  try
    formInputFamily.TitleForm:= 'Fiche Famille';
    formInputFamily.WriteScreen(id);
    result:= formInputFamily.ShowModal = mrOk;
    if result then
      formInputFamily.ReadScreen(id);
  finally
    FreeAndNil(formInputFamily);
  end;
end;

procedure TformInputFamily.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Family);
end;

procedure TformInputFamily.ReadScreen(const id: integer);
begin
  if Assigned(family) then
  begin
    Family._code       := edtCode.Text;
    Family._Label      := edtLabel.Text;
    Family._Description:= edtDescription.Text;
    Service.setFamily(configfile.connection_server.appid, ParamToJSon(global_param), FamilyToJSon(Family));
  end;
end;

procedure TformInputFamily.WriteScreen(const id: integer);
begin
  Family:= TFamily(getObject(id, TFamily));
  if Assigned(Family) then
  begin
    edtCode.Text       := Family._code;
    edtLabel.Text      := Family._Label;
    edtDescription.Text:= Family._Description;
  end;
end;

end.
