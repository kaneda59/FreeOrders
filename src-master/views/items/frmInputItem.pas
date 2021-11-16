unit frmInputItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, //module.items,
  classebase, json.tools, module.family,
  module.vat, module.supplier,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformInputItems = class(TformBaseInput)
    chkActif: TCheckBox;
    edtLabel: TEdit;
    edtDescription: TEdit;
    edtPvHT: TEdit;
    edtPAHT: TEdit;
    edtVAT: TEdit;
    edtSupplier: TEdit;
    edtFamily: TEdit;
    btnVAT: TButton;
    btnSupplier: TButton;
    btnFamily: TButton;
    libellé: TLabel;
    Description: TLabel;
    PrixVHT: TLabel;
    Label1: TLabel;
    TVA: TLabel;
    Fournisseur: TLabel;
    Famille: TLabel;
    edtCode: TEdit;
    lblCode: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure btnVATClick(Sender: TObject);
    procedure btnSupplierClick(Sender: TObject);
    procedure btnFamilyClick(Sender: TObject);
    procedure edtPvHTKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    items: TItems;
    vat: TVat;
    family: TFamily;
    supplier: TSupplier;
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
    procedure getVat(const id: Integer);
    procedure getFamily(const id: integer);
    procedure getSupplier(const id: integer);
  public
    { Déclarations publiques }
    class function Execute(const id: integer): Boolean;
  end;

var
  formInputItems: TformInputItems;

implementation

{$R *.dfm}
  uses Module,
       Logs, consts_, frmListBase, frmListFamily, frmListVats, frmListSuppliers,
       cli.datas, configuration;

{ TformInputItems }

procedure TformInputItems.btnFamilyClick(Sender: TObject);
var id: Integer;
    Family: TModule_Family;
begin
  inherited;
  id:= edtFamily.Tag;
  if TFormListFamily.ShowList(mdSelection, id) then
  begin
    Family:= TModule_Family.Create(id);
    Family.Read;
    edtFamily.Tag:= id;
    edtFamily.Text:= Family.Family._Label;
  end;
end;

procedure TformInputItems.btnSupplierClick(Sender: TObject);
var id: Integer;
    Supplier: TModule_Suppliers;
begin
  inherited;
  id:= edtSupplier.Tag;
  if TFormListSuppliers.ShowList(mdSelection, id) then
  begin
    supplier:= TModule_Suppliers.Create(id);
    supplier.Read;
    edtSupplier.Tag:= id;
    edtSupplier.Text:= supplier.supplier._label;
  end;
end;

procedure TformInputItems.btnVATClick(Sender: TObject);
var id: Integer;
    vat: TModule_Vat;
begin
  inherited;
  id:= edtVAT.Tag;
  if TFormListVats.ShowList(mdSelection, id) then
  begin
    vat:= TModule_Vat.Create(id);
    vat.Read;
    edtVAT.Tag:= id;
    edtVAT.Text:= vat.Vat._label;
  end;
end;

procedure TformInputItems.edtPvHTKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not CharInSet(Key, ['0'..'9', FormatSettings.DecimalSeparator, #8, #9]) then
    Key:= #0;
end;

class function TformInputItems.Execute(const id: integer): Boolean;
begin
  Application.CreateForm(TformInputItems, formInputItems);
  try
    formInputItems.TitleForm:= 'Fiche Produit';
    formInputItems.WriteScreen(id);
    result:= formInputItems.ShowModal = mrOk;
    if result then
      formInputItems.ReadScreen(id);
  finally
    FreeAndNil(formInputItems);
  end;
end;

procedure TformInputItems.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(items);
  //FreeAndNil(mItems);
  FreeAndNil(mVat);
  FreeAndNil(mSupplier);
  FreeAndNil(mFamily);
end;

procedure TformInputItems.getFamily(const id: integer);
begin
  Family:= TFamily(GetObject(id, TFamily));
end;

procedure TformInputItems.getSupplier(const id: integer);
begin
  supplier:= TSupplier(GetObject(id, TSupplier));
end;

procedure TformInputItems.getVat(const id: Integer);
var result: TResultInformation;
begin
  Vat:= TVat(GetObject(id, TVat));
end;

procedure TformInputItems.ReadScreen(const id: integer);
begin
  if Assigned(items) then
  begin
    Items._Code       := edtCode.Text;
    Items._Label      := edtLabel.Text;
    Items._description:= edtDescription.Text;
    Items._pvht       := StrToFloat(edtPvHT.Text);
    Items._paht       := StrToFloat(edtPAHT.Text);
    Items._actif      := chkActif.Checked;
    Items._idvat      := edtVAT.Tag;
    Items._idfamily   := edtFamily.Tag;
    Items._idSupplier := edtSupplier.Tag;
    setObject(items, TItems);
  end;
end;

procedure TformInputItems.WriteScreen(const id: integer);
var result: TResultInformation;
begin
  Items:= TItems(GetObject(id, TItems));
  if Assigned(Items) then
  begin
    edtCode.Text       := Items._Code;
    edtLabel.Text      := Items._Label;
    edtDescription.Text:= Items._description;
    edtPvHT.Text       := FormatFloat('0.00', Items._pvht);
    edtPAHT.Text       := FormatFloat('0.00', Items._paht);

    chkActif.Checked:= Items._actif;

    getVat(items._idvat);
    edtVAT.Tag := Items._idvat;
    edtVAT.Text:= Vat._label;

    getFamily(items._idfamily);
    edtFamily.Tag:= Items._idfamily;
    edtFamily.Text:= Family._Label;

    getSupplier(items._idSupplier);
    edtSupplier.Tag:= Items._idSupplier;
    edtSupplier.Text:= Supplier._Label;
  end;
end;

end.
