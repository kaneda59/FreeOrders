unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, acPNG, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Menus;

type
  TForm1 = class(TForm)
    imglogo: TImage;
    mm1: TMainMenu;
    mniFiles: TMenuItem;
    mniClients: TMenuItem;
    mnuSuppliers: TMenuItem;
    mnuItems: TMenuItem;
    mniN1: TMenuItem;
    MnuClose: TMenuItem;
    mniOrders: TMenuItem;
    mniMnuOrderForms: TMenuItem;
    mnuDeliveryNotes: TMenuItem;
    A1: TMenuItem;
    mnuAbout: TMenuItem;
    MnuParameters: TMenuItem;
    mniN2: TMenuItem;
    stat1: TStatusBar;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
