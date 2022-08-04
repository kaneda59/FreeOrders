unit frmBaseInput;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBase, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, uniButton, uniLabel, uniGUIBaseClasses, uniGUIClasses, uniPanel;

type
  TformBaseInput = class(TFormBase)
    pnlBottom: TPanel;
    pnlBody: TPanel;
    btnValid: TButton;
    btnCancel: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  formBaseInput: TformBaseInput;

implementation

{$R *.dfm}

end.
