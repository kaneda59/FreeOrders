unit frmBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormBase = class(TForm)
    pnlheader: TPanel;
    state: TStatusBar;
    LblFree: TLabel;
    lblOrders: TLabel;
    lblTitle: TLabel;
  private
    function getTitleForm: string;
    procedure setTitleForm(const Value: string);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property TitleForm: string read getTitleForm write setTitleForm;
  end;

var
  FormBase: TFormBase;

implementation

{$R *.dfm}

{ TForm2 }

function TFormBase.getTitleForm: string;
begin
  result:= lblTitle.Caption;
end;

procedure TFormBase.setTitleForm(const Value: string);
begin
  lblTitle.Caption:= Value;
  Caption:= '';
end;

end.
