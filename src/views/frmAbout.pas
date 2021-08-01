unit frmAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBase, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TformAbout = class(TFormBase)
    lblSociete: TLabel;
    lblCopyright: TLabel;
    lblInformations: TLabel;
    lblInformations2: TLabel;
    btnClose: TButton;
    lblInformations3: TLabel;
    lblURL: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    class procedure Execute;
  end;

var
  formAbout: TformAbout;

implementation

{$R *.dfm}

{ TformAbout }

class procedure TformAbout.Execute;
begin
  Application.CreateForm(TformAbout, formAbout);
  try
    formAbout.TitleForm:= 'A propos';
    formAbout.ShowModal;
  finally
    FreeAndNil(formAbout);
  end;
end;

end.
