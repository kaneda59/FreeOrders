unit frmInputSupplier;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, classebase, json.tools,//module.supplier,
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
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    supplier: TSupplier;
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

uses //Module,
     Logs, Consts_, cli.datas, configuration;

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

procedure TformInputSupplier.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Supplier);
end;

procedure TformInputSupplier.ReadScreen(const id: integer);
begin
  if Assigned(supplier) then
  begin
    Supplier._Label      := edtLabel.Text;
    Supplier._Description:= edtDescription.Text;
    Supplier._Address    := edtAddress.Text;
    Supplier._supplement := edtComplement.Text;
    Supplier._City       := edtCity.Text;
    Supplier._ZipCode    := edtZipCode.Text;
    Supplier._Country    := edtLand.Text;
    Supplier._Phone      := edtPhonenumber.Text;
    Supplier._Mobile     := edtMobile.Text;
    Supplier._Account    := edtAccount.Text;
    Supplier._mail       := edtMail.Text;
    setObject(Supplier, TSupplier);
  end;
end;

procedure TformInputSupplier.WriteScreen(const id: integer);
begin
  supplier:= TSupplier(getObject(id, TSupplier));
  if Assigned(supplier) then
  begin
    edtLabel.Text      := Supplier._Label;
    edtDescription.Text:= Supplier._Description;
    edtAddress.Text    := Supplier._Address;
    edtComplement.Text := Supplier._supplement;
    edtCity.Text       := Supplier._City;
    edtZipCode.Text    := Supplier._ZipCode;
    edtLand.Text       := Supplier._Country;
    edtPhonenumber.Text:= Supplier._Phone;
    edtMobile.Text     := Supplier._Mobile;
    edtAccount.Text    := Supplier._Account;
    edtMail.Text       := Supplier._mail;
  end;
end;

end.
