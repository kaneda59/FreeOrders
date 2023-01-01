unit uni.frmInputCustomer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, classebase,
  uniGUIClasses, uniGUIForm, uni.frmBaseInput, uniButton, uniLabel,
  uniGUIBaseClasses, uniPanel, uniEdit, uni.frmBase;

type
  TformInputCustomer = class(TformBaseInput)
    MainContenair1: TUniContainerPanel;
    edtFirstName: TUniEdit;
    edtLastName: TUniEdit;
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
    customer: TClient;
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Public declarations }
    class procedure Execute(const id: integer; ResultOK : TOnResultOK);
  end;

function formInputCustomer: TformInputCustomer;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function formInputCustomer: TformInputCustomer;
begin
  Result := TformInputCustomer(UniMainModule.GetFormInstance(TformInputCustomer));
end;

{ TformBaseInput1 }

class procedure TformInputCustomer.Execute(const id: integer;
  ResultOK: TOnResultOK);
begin
  try
    formInputCustomer.TitleForm:= 'Fiche Client';
    formInputCustomer.WriteScreen(id);
    formInputCustomer.OnResultOK := ResultOK;
    formInputCustomer.ShowModal(
    Procedure(Sender: TComponent; Result:Integer)
    begin
      if Result=mrOk then
      begin
        formInputCustomer.ReadScreen(id);
        Sleep(1000);
        if Assigned(formInputCustomer.OnResultOK) then
        begin
          formInputCustomer.OnResultOK(Sender, id);
        end;
      end;
    end);
  finally
  end;
end;

procedure TformInputCustomer.ReadScreen(const id: integer);
begin
  if Assigned(customer) then
  begin
    customer._FirstName   := edtFirstName.Text;
    customer._LastName    := edtLastName.Text;
    customer._Address     := edtAddress.Text;
    customer._supplement  := edtComplement.Text;
    customer._City        := edtCity.Text;
    customer._ZipCode     := edtZipCode.Text;
    customer._Country     := edtLand.Text;
    customer._Phone       := edtPhoneNumber.Text;
    customer._Mobile      := edtMobile.Text;
    customer._Account     := edtAccount.Text;
    customer._mail        := edtMail.Text;

    UniMainModule.microService.setObject(customer, TClient);
  end;
end;

procedure TformInputCustomer.WriteScreen(const id: integer);
begin
  customer:=  TClient(UniMainModule.microService.getObject(id, TClient));
  if Assigned(customer) then
  begin
    edtFirstName.Text  := customer._FirstName;
    edtLastName.Text   := customer._LastName;
    edtAddress.Text    := customer._Address;
    edtComplement.Text := customer._supplement;
    edtCity.Text       := customer._City;
    edtZipCode.Text    := customer._ZipCode;
    edtLand.Text       := customer._Country;
    edtPhoneNumber.Text:= customer._Phone;
    edtMobile.Text     := customer._Mobile;
    edtAccount.Text    := customer._Account;
    edtMail.Text       := customer._mail;
  end;
end;

end.
