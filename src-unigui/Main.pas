unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, uni.cli.datas,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, acPNG, uniGUIBaseClasses,
  uniImage, Vcl.Menus, uniMainMenu, uniSweetAlert;



type
  TOnRefreshAllData = procedure (const tag: integer) of object;
  TMainForm = class(TUniForm)
    unmg1: TUniImage;
    UniMainMenu1: TUniMainMenu;
    mnuFichier: TUniMenuItem;
    mnuClients: TUniMenuItem;
    mnuFournisseurs: TUniMenuItem;
    mnuFamilles: TUniMenuItem;
    mnuProduits: TUniMenuItem;
    mnuTVAs: TUniMenuItem;
    FichierN1: TUniMenuItem;
    mnuConfiguration: TUniMenuItem;
    FichierN2: TUniMenuItem;
    mnuQuitter: TUniMenuItem;
    mnuCommandes: TUniMenuItem;
    mnuBonCommandes: TUniMenuItem;
    mnuBonLivraisons: TUniMenuItem;
    mnuAide: TUniMenuItem;
    mnuAbout: TUniMenuItem;
    UniSweetAlert1: TUniSweetAlert;
    procedure mnuTVAsClick(Sender: TObject);
    procedure UniFormAfterShow(Sender: TObject);
    procedure mnuFamillesClick(Sender: TObject);
    procedure mnuProduitsClick(Sender: TObject);
    procedure mnuFournisseursClick(Sender: TObject);
    procedure mnuClientsClick(Sender: TObject);
    procedure mnuQuitterClick(Sender: TObject);
    procedure mnuConfigurationClick(Sender: TObject);
    procedure mnuBonCommandesClick(Sender: TObject);
  private
    fOnRefreshAllData: TOnRefreshAllData;
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshData(const Tag: Integer);
    property OnRefreshAllData: TOnRefreshAllData read fOnRefreshAllData write fOnRefreshAllData;
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication,
  uni.frmListOrders,
  uni.frmInputConfig,
  uni.frmListCustomers,
  uni.frmListBase,
  uni.frmListVats,
  uni.frmInputVat,
  uni.frmListItems,
  uni.frmListSuppliers,
  uni.frmListFamily;

procedure msgIGrow(msg,tipo: string);
Var
  StrJS : string;
begin
// UniSession.AddJS(StrJS);

  StrJS := '$.iGrowl({ ';
  StrJS := StrJS + 'title: "'+tipo+'",';
  StrJS := StrJS + 'type: "'+tipo+'",';
  StrJS := StrJS + 'message: "'+msg+'",';
  StrJS := StrJS + 'animation: true,';
  StrJS := StrJS + 'delay: 2500,';
  StrJS := StrJS + 'icon: "vicons-support",';
  StrJS := StrJS + 'placement : { x: "center" },';
  StrJS := StrJS + 'animShow: "fadeInLeftBig",';

//  StrJS := StrJS + 'animHide: "fadeOutRight",';
//  StrJS := StrJS + 'image: { src: "'+CDN+'/igrowl/images/'+iGtype+'.png", class: "igrowl-image" }'; // ,class: "example-image"
  StrJS := StrJS + '})';

  UniSession.AddJS(StrJS);
end;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.mnuBonCommandesClick(Sender: TObject);
var id: integer;
begin
  TformListOrders.ShowList(mdMaj, id);
end;

procedure TMainForm.mnuClientsClick(Sender: TObject);
var id: integer;
begin
  TformListCustomers.ShowList(mdMaj, id);
end;

procedure TMainForm.mnuConfigurationClick(Sender: TObject);
begin
  TformBaseConfig.Execute;
end;

procedure TMainForm.mnuFamillesClick(Sender: TObject);
var id: integer;
begin
  TformListFamily.ShowList(mdMaj, id);
end;

procedure TMainForm.mnuFournisseursClick(Sender: TObject);
var id: integer;
begin
  TformListSuppliers.ShowList(mdMaj, id);
end;

procedure TMainForm.mnuProduitsClick(Sender: TObject);
var id: integer;
begin
  TformListItems.ShowList(mdMaj, id);
end;

procedure TMainForm.mnuQuitterClick(Sender: TObject);
begin
  UniApplication.Terminate('A très bientôt');
end;

procedure TMainForm.mnuTVAsClick(Sender: TObject);
var id: integer;
begin
  TFormListVats.ShowList(mdMaj, id);
end;

procedure TMainForm.RefreshData(const Tag: Integer);
begin
  case Tag of
    FCT_TVA       : FormListVats.UpdateData;
//    FCT_ITEM      : if Assigned(formListItems) then
//                       formListItems.UpdateData;
//    FCT_FAMILY    : if Assigned(formListFamily) then
//                       formListFamily.UpdateData;
//    FCT_SUPPLIER  : if Assigned(formListSuppliers) then
//                       formListSuppliers.UpdateData;
//    FCT_CUSTOMER  : if Assigned(formListCustomers) then
//                       formListCustomers.UpdateData;
//    FCT_ORDER     : if Assigned(formListOrders) then
//                       formListOrders.UpdateData;
  end;
end;

procedure TMainForm.UniFormAfterShow(Sender: TObject);
begin
  OnRefreshAllData:= RefreshData;
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
