unit uni.frmInputSupplier;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, uni.frmBase,
  uniGUIClasses, uniGUIForm, uni.frmBaseInput, uniButton, uniLabel,
  uniGUIBaseClasses, uniPanel, uniEdit, classebase;

type
  TforInputSupplier = class(TformBaseInput)
    MainContenair1: TUniContainerPanel;
    edtLabel: TUniEdit;
    edtDescription: TUniEdit;
    edtAddress: TUniEdit;
    edtComplement: TUniEdit;
    edtCity: TUniEdit;
    edtZipCode: TUniEdit;
    edtLand: TUniEdit;
    edtPhoneNumber: TUniEdit;
    edtMobile: TUniEdit;
    edtAccount: TUniEdit;
    edtMail: TUniEdit;
  private
    { Private declarations }
    supplier: TSupplier;
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Public declarations }
    class procedure Execute(const id: integer; ResultOK : TOnResultOK);
  end;

function forInputSupplier: TforInputSupplier;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function forInputSupplier: TforInputSupplier;
begin
  Result := TforInputSupplier(UniMainModule.GetFormInstance(TforInputSupplier));
end;

{ TforInputSupplier }

class procedure TforInputSupplier.Execute(const id: integer;
  ResultOK: TOnResultOK);
begin
  try
    forInputSupplier.TitleForm:= 'Fiche Fournisseur';
    forInputSupplier.WriteScreen(id);
    forInputSupplier.OnResultOK := ResultOK;
    forInputSupplier.ShowModal(
    Procedure(Sender: TComponent; Result:Integer)
    begin
      if Result=mrOk then
      begin
        forInputSupplier.ReadScreen(id);
        Sleep(1000);
        if Assigned(forInputSupplier.OnResultOK) then
        begin
          forInputSupplier.OnResultOK(Sender, id);
        end;
      end;
    end);
  finally
  end;
end;

procedure TforInputSupplier.ReadScreen(const id: integer);
begin
  if Assigned(supplier) then
  begin
    supplier._Label       := edtLabel.Text;
    supplier._Description := edtDescription.Text;
    supplier._Address     := edtAddress.Text;
    supplier._supplement  := edtComplement.Text;
    supplier._City        := edtCity.Text;
    supplier._ZipCode     := edtZipCode.Text;
    supplier._Country     := edtLand.Text;
    supplier._Phone       := edtPhoneNumber.Text;
    supplier._Mobile      := edtMobile.Text;
    supplier._Account     := edtAccount.Text;
    supplier._mail        := edtMail.Text;

    UniMainModule.microService.setObject(supplier, Tsupplier);
  end;
end;

procedure TforInputSupplier.WriteScreen(const id: integer);
begin
  supplier:=  Tsupplier(UniMainModule.microService.getObject(id, Tsupplier));
  if Assigned(supplier) then
  begin
    edtLabel.Text      := supplier._Label;
    edtDescription.Text:= supplier._Description;
    edtAddress.Text    := supplier._Address;
    edtComplement.Text := supplier._supplement;
    edtCity.Text       := supplier._City;
    edtZipCode.Text    := supplier._ZipCode;
    edtLand.Text       := supplier._Country;
    edtPhoneNumber.Text:= supplier._Phone;
    edtMobile.Text     := supplier._Mobile;
    edtAccount.Text    := supplier._Account;
    edtMail.Text       := supplier._mail;
  end;
end;

end.
