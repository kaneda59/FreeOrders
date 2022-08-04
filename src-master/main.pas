unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, acPNG, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Menus;

const WM_NOTIFYEVENT = WM_USER + 1000;

type
  TformMain = class(TForm)
    imglogo: TImage;
    mm1: TMainMenu;
    mniFiles: TMenuItem;
    mnuClients: TMenuItem;
    mnuSuppliers: TMenuItem;
    mnuItems: TMenuItem;
    mniN1: TMenuItem;
    MnuClose: TMenuItem;
    mniOrders: TMenuItem;
    mnuOrderForms: TMenuItem;
    mnuDeliveryNotes: TMenuItem;
    A1: TMenuItem;
    mnuAbout: TMenuItem;
    mniN2: TMenuItem;
    stat1: TStatusBar;
    mnuConfiguration: TMenuItem;
    mnuFamily: TMenuItem;
    mnuVATs: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure mnuActionClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure getMessage(var msg: TMessage); message WM_NOTIFYEVENT;
  end;

var
  formMain: TformMain;

implementation

  uses consts_, Logs, frmListClients, frmListSuppliers, frmListOrders, frmAbout, frmInputDelivery,
       frmListFamily, frmListItems, frmListVats, frmListBase, frmInputConfiguration, module, cli.datas;

{$R *.dfm}
/// <summary>
///  On initialise les tag des menu pour affecter les actions associées à chacun d'entre eux
/// </summary>
procedure TformMain.FormCreate(Sender: TObject);
begin
  mnuclients.Tag      := ACT_LIST_CLIENTS;
  mnuSuppliers.Tag    := ACT_LIST_SUPPLIERS;
  mnuFamily.Tag       := ACT_LIST_FAMILY;
  mnuItems.Tag        := ACT_LIST_ITEMS;
  mnuOrderForms.Tag   := ACT_ORDERS;
  mnuDeliveryNotes.Tag:= ACT_DELIVERIES;
  mnuConfiguration.Tag:= ACT_CONFIGURATION;
  mnuVATs.Tag         := ACT_LIST_VATS;
  MnuClose.Tag        := ACT_CLOSE;
  mnuAbout.Tag        := ACT_ABOUT;
end;

procedure TformMain.getMessage(var msg: TMessage);
begin
  Donnees.FillDatas(msg.WParam);
  case msg.WParam of
    FCT_TVA       : if Assigned(FormListVats) then
                       FormListVats.UpdateData;
    FCT_ITEM      : if Assigned(formListItems) then
                       formListItems.UpdateData;
    FCT_FAMILY    : if Assigned(formListFamily) then
                       formListFamily.UpdateData;
    FCT_SUPPLIER  : if Assigned(formListSuppliers) then
                       formListSuppliers.UpdateData;
    FCT_CUSTOMER  : if Assigned(formListClients) then
                       formListClients.UpdateData;
    FCT_ORDER     : if Assigned(formListOrders) then
                       formListOrders.UpdateData;
  end;
end;

/// <summary>
///  tous les menus sont associés à un seul event click et selon le tag du menu passé en paramètre (sender) on
///  exécute la méthode approprié
/// </summary>
procedure TformMain.mnuActionClick(Sender: TObject);
var id: integer;
begin
  case TMenuItem(Sender).Tag of

  ACT_LIST_CLIENTS  : TformListClients.ShowList(mdMaj, id);
  ACT_LIST_SUPPLIERS: TformListSuppliers.ShowList(mdMaj, id);
  ACT_LIST_FAMILY   : TformListFamily.ShowList(mdMaj, id);
  ACT_LIST_ITEMS    : TformListItems.ShowList(mdMaj, id);
  ACT_LIST_VATS     : TFormListVats.ShowList(mdMaj, id);
  ACT_ORDERS        : TformListOrders.ShowList(mdMaj, id);
  ACT_DELIVERIES    : if TformListOrders.ShowList(mdSelection, id) then
                      begin
                        TformInputDelivery.Execute(id);
                      end;
  ACT_CONFIGURATION : TformInputConfiguration.Execute;
  ACT_CLOSE         : Close;
  ACT_ABOUT         : TformAbout.Execute;

  end;

end;

end.
