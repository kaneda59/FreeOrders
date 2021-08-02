unit frmInputItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, module.items, module.family,
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
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Déclarations publiques }
    class function Execute(const id: integer): Boolean;
  end;

var
  formInputItems: TformInputItems;

implementation

{$R *.dfm}
  uses Module, Logs, consts_, frmListBase, frmListFamily, frmListVats, frmListSuppliers;

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
  FreeAndNil(mItems);
  FreeAndNil(mVat);
  FreeAndNil(mSupplier);
  FreeAndNil(mFamily);
end;

procedure TformInputItems.ReadScreen(const id: integer);
begin
  mItems.Items._Code       := edtCode.Text;
  mItems.Items._Label      := edtLabel.Text;
  mItems.Items._description:= edtDescription.Text;
  mItems.Items._pvht       := StrToFloat(edtPvHT.Text);
  mItems.Items._paht       := StrToFloat(edtPAHT.Text);
  mItems.Items._actif      := chkActif.Checked;
  mItems.Items._idvat      := edtVAT.Tag;
  mItems.Items._idfamily   := edtFamily.Tag;
  mItems.Items._idSupplier := edtSupplier.Tag;
  mSupplier.Supplier._Label:= edtSupplier.Text;

  mItems.Write;
end;

procedure TformInputItems.WriteScreen(const id: integer);
begin
  mItems:= TModule_items.Create(id);
  mItems.Read;

  edtCode.Text       := mItems.Items._Code;
  edtLabel.Text      := mItems.Items._Label;
  edtDescription.Text:= mItems.Items._description;
  edtPvHT.Text       := FormatFloat('0.00', mItems.Items._pvht);
  edtPAHT.Text       := FormatFloat('0.00', mItems.Items._paht);

  chkActif.Checked:= mItems.Items._actif;

  mVat := TModule_Vat.Create(mItems.Items._idvat);
  mVat.Read;
  edtVAT.Tag:= mItems.Items._idvat;
  edtVAT.Text:= mVat.Vat._label;

  mFamily:= TModule_Family.Create(mItems.Items._idfamily);
  mFamily.Read;
  edtFamily.Tag:= mItems.Items._idfamily;
  edtFamily.Text:= mFamily.Family._Label;

  mSupplier:= TModule_Suppliers.Create(mItems.Items._idSupplier);
  mSupplier.Read;
  edtSupplier.Tag:= mItems.Items._idSupplier;
  edtSupplier.Text:= mSupplier.Supplier._Label;
end;

end.
