unit uni.frmInputItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, classebase,  json.tools,
  uniGUIClasses, uniGUIForm, uni.frmBaseInput, uniButton, uniLabel,
  uniGUIBaseClasses, uniPanel, uniBitBtn, uniSpeedButton, uniEdit, uniCheckBox,
  Vcl.Buttons, uni.frmBase;

type
  TformInputItem = class(TformBaseInput)
    pnlBody: TUniPanel;
    chkActif: TUniCheckBox;
    edtCode: TUniEdit;
    edtLibelle: TUniEdit;
    edtDescription: TUniEdit;
    edtPvHT: TUniEdit;
    edtPAHT: TUniEdit;
    edtTVA: TUniEdit;
    edtFournisseur: TUniEdit;
    edtFamille: TUniEdit;
    btnTVA: TUniSpeedButton;
    btnFournisseur: TUniSpeedButton;
    btnFamille: TUniSpeedButton;
    btnFamily: TUniSpeedButton;
    procedure UniFormDestroy(Sender: TObject);
    procedure btnTVAClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure btnFamilleClick(Sender: TObject);
    procedure btnFournisseurClick(Sender: TObject);
  private
    { Private declarations }
    items: TItems;
    vat: TVat;
    family: TFamily;
    supplier: TSupplier;
    procedure OnSelectVat(Sender: TObject; const id: integer);
    procedure OnSelectFamily(Sender: TObject; const id: integer);
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
    procedure getVat(const id: Integer);
    procedure getFamily(const id: integer);
    procedure getSupplier(const id: integer);
    procedure OnSelectSupplier(Sender: TObject; const id: integer);
  public
    { Public declarations }
    class function Execute(const id: integer; ResultOK : TOnResultOK): Boolean;
  end;

function formInputItem: TformInputItem;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Logs, consts_,
  uni.frmListBase, uni.frmListFamily, uni.frmListVats,
  uni.frmListSuppliers,
  uni.cli.datas, configuration;

function formInputItem: TformInputItem;
begin
  Result := TformInputItem(UniMainModule.GetFormInstance(TformInputItem));
end;

{ TformInputItem }

procedure TformInputItem.btnFamilleClick(Sender: TObject);
var id: integer;
begin
  inherited;
  TformListFamily.ShowList(mdSelection, id, OnSelectFamily);
end;

class function TformInputItem.Execute(const id: integer; ResultOK : TOnResultOK): Boolean;
begin
  formInputItem.TitleForm:= 'Produit';
  formInputItem.WriteScreen(id);
  formInputItem.ShowModal(
  Procedure(Sender: TComponent; Result:Integer)
  begin
    if Result=mrOk then
    begin
      formInputItem.ReadScreen(id);
      Sleep(1000);
      if Assigned(formInputItem.OnResultOK) then
      begin
        formInputItem.OnResultOK(Sender, id);
      end;
    end;
  end)
end;

procedure TformInputItem.getFamily(const id: integer);
begin
  Family:= TFamily(UniMainModule.microService.GetObject(id, TFamily));
end;

procedure TformInputItem.getSupplier(const id: integer);
begin
  Supplier:= TSupplier(UniMainModule.microService.getObject(id, TSupplier));
end;

procedure TformInputItem.getVat(const id: Integer);
begin
  Vat:= TVat(UniMainModule.microService.GetObject(id, TVat));
end;

procedure TformInputItem.OnSelectFamily(Sender: TObject; const id: integer);
var f: TFamily;
begin
  f:= TFamily(UniMainModule.microService.getObject(id, TFamily));
  edtFamille.Tag:= id;
  edtFamille.Text:= f._Label;
end;

procedure TformInputItem.OnSelectVat(Sender: TObject; const id: integer);
var t : Tvat;
begin
  t := Tvat(UniMainModule.microService.getObject(id, TVat));
  edtTVA.Tag:= id;
  edtTVA.Text:= t._label;
end;

procedure TformInputItem.OnSelectSupplier(Sender: TObject; const id: integer);
var s: TSupplier;
begin
  s:= TSupplier(UniMainModule.microService.GetObject(id, TSupplier));
  edtFournisseur.Tag:= id;
  edtFournisseur.Text:= s._Label;
end;

procedure TformInputItem.ReadScreen(const id: integer);
begin
  if Assigned(items) then
  begin
    Items._Code       := edtCode.Text;
    Items._Label      := edtLibelle.Text;
    Items._description:= edtDescription.Text;
    Items._pvht       := StrToFloat(edtPvHT.Text);
    Items._paht       := StrToFloat(edtPAHT.Text);
    Items._actif      := chkActif.Checked;
    Items._idvat      := edtTVA.Tag;
    Items._idfamily   := edtFamille.Tag;
    Items._idSupplier := edtFournisseur.Tag;
    UniMainModule.microService.setObject(items, TItems);
  end;
end;

procedure TformInputItem.UniFormCreate(Sender: TObject);
begin
  inherited;

  items   := TItems.Create;
  vat     := Tvat.Create;
  Supplier:= TSupplier.Create;
  family  := TFamily.Create;
end;

procedure TformInputItem.UniFormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(items);
  FreeAndNil(Vat);
  FreeAndNil(Supplier);
  FreeAndNil(Family);
end;

procedure TformInputItem.btnFournisseurClick(Sender: TObject);
var id: integer;
begin
  inherited;
  TFormListSuppliers.ShowList(mdSelection, id, OnSelectSupplier);
end;

procedure TformInputItem.btnTVAClick(Sender: TObject);
var id: integer;
begin
  inherited;
  TFormListVats.ShowList(mdSelection, id, OnSelectVat);
end;

procedure TformInputItem.WriteScreen(const id: integer);
begin
  Items:= TItems(UniMainModule.microService.GetObject(id, TItems));
  if Assigned(Items) then
  begin
    edtCode.Text       := Items._Code;
    edtLibelle.Text      := Items._Label;
    edtDescription.Text:= Items._description;
    edtPvHT.Text       := FormatFloat('0.00', Items._pvht);
    edtPAHT.Text       := FormatFloat('0.00', Items._paht);

    chkActif.Checked:= Items._actif;

    getVat(items._idvat);
    edtTVA.Tag := Items._idvat;
    edtTVA.Text:= Vat._label;

    getFamily(items._idfamily);
    edtFamille.Tag:= Items._idfamily;
    edtFamille.Text:= Family._Label;

    getSupplier(items._idSupplier);
    edtFournisseur.Tag:= Items._idSupplier;
    edtFournisseur.Text:= Supplier._Label;
  end;
end;

end.
