unit frmInputFamily;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, module.family,
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
uses Module, Logs, Consts_;

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
  FreeAndNil(mFamily);
end;

procedure TformInputFamily.ReadScreen(const id: integer);
begin
  mFamily.Family._code       := edtCode.Text;
  mFamily.Family._Label      := edtLabel.Text;
  mFamily.Family._Description:= edtDescription.Text;
  mFamily.Write;
end;

procedure TformInputFamily.WriteScreen(const id: integer);
begin
  mFamily:= TModule_Family.Create(id);
  mFamily.Read;
  edtCode.Text       := mFamily.Family._code;
  edtLabel.Text      := mFamily.Family._Label;
  edtDescription.Text:= mFamily.Family._Description;
end;

end.
