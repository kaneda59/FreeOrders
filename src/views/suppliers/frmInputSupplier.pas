unit frmInputSupplier;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, module.supplier,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformInputSupplier = class(TformBaseInput)
    edtLabel: TEdit;
    edtDescription: TEdit;
    edtAddress: TEdit;
    edtComplement: TEdit;
    edtCity: TEdit;
    edtZipCode: TEdit;
    edtLand: TEdit;
    edtPhonenumber: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edtMobile: TEdit;
    edtAccount: TEdit;
    edtMail: TEdit;
  private
    { Déclarations privées }
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Déclarations publiques }
    class function Execute(const id: integer): Boolean;
  end;

var
  formInputSupplier: TformInputSupplier;

implementation

{$R *.dfm}

uses Module, Logs, Consts_;

{ TformBaseInput1 }

class function TformInputSupplier.Execute(const id: integer): Boolean;
begin
  Application.CreateForm(TformInputSupplier, formInputSupplier);
  try
    formInputSupplier.TitleForm:= 'Fiche Fournisseur';
    formInputSupplier.WriteScreen(id);
    result:= formInputSupplier.ShowModal = mrOk;
    if result then
      formInputSupplier.ReadScreen(id);
  finally
    FreeAndNil(formInputSupplier);
  end;
end;

procedure TformInputSupplier.ReadScreen(const id: integer);
begin
  mSupplier.Supplier._Label      := edtLabel.Text;
  mSupplier.Supplier._Description:= edtDescription.Text;
  mSupplier.Supplier._Address    := edtAddress.Text;
  mSupplier.Supplier._supplement := edtComplement.Text;
  mSupplier.Supplier._City       := edtCity.Text;
  mSupplier.Supplier._ZipCode    := edtZipCode.Text;
  mSupplier.Supplier._Country    := edtLand.Text;
  mSupplier.Supplier._Phone      := edtPhonenumber.Text;
  mSupplier.Supplier._Mobile     := edtMobile.Text;
  mSupplier.Supplier._Account    := edtAccount.Text;
  mSupplier.Supplier._mail       := edtMail.Text;
  mSupplier.Write;
end;

procedure TformInputSupplier.WriteScreen(const id: integer);
begin
  mSupplier:= TModule_Suppliers.Create(id);
  mSupplier.Read;
  edtLabel.Text      := mSupplier.Supplier._Label;
  edtDescription.Text:= mSupplier.Supplier._Description;
  edtAddress.Text    := mSupplier.Supplier._Address;
  edtComplement.Text := mSupplier.Supplier._supplement;
  edtCity.Text       := mSupplier.Supplier._City;
  edtZipCode.Text    := mSupplier.Supplier._ZipCode;
  edtLand.Text       := mSupplier.Supplier._Country;
  edtPhonenumber.Text:= mSupplier.Supplier._Phone;
  edtMobile.Text     := mSupplier.Supplier._Mobile;
  edtAccount.Text    := mSupplier.Supplier._Account;
  edtMail.Text       := mSupplier.Supplier._mail;
end;

end.
