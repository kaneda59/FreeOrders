unit frmInputClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, module.client,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformInputClient = class(TformBaseInput)
    edtFirstName: TEdit;
    edtLastName: TEdit;
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
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure ReadScreen(const id: integer);
    procedure WriteScreen(const id: integer);
  public
    { Déclarations publiques }
    class function Execute(const id: integer): Boolean;
  end;

var
  formInputClient: TformInputClient;

implementation

{$R *.dfm}
uses Module, Logs, Consts_;

{ TformInputClient }

class function TformInputClient.Execute(const id: integer): Boolean;
begin
  Application.CreateForm(TformInputClient, formInputClient);
  try
    formInputClient.TitleForm:= 'Fiche client';
    formInputClient.WriteScreen(id);
    result:= formInputClient.ShowModal = mrOk;
    if result then
      formInputClient.ReadScreen(id);
  finally
    FreeAndNil(formInputClient);
  end;
end;

procedure TformInputClient.FormCreate(Sender: TObject);
begin
  inherited;
  FreeAndNil(mClient);
end;

procedure TformInputClient.ReadScreen(const id: integer);
begin
  mClient.client._FirstName  := edtFirstName.Text;
  mClient.client._LastName   := edtLastName.Text;
  mClient.client._Address    := edtAddress.Text;
  mClient.client._supplement := edtComplement.Text;
  mClient.client._City       := edtCity.Text;
  mClient.client._ZipCode    := edtZipCode.Text;
  mClient.client._Country    := edtLand.Text;
  mClient.client._Phone      := edtPhonenumber.Text;
  mClient.client._Mobile     := edtMobile.Text;
  mClient.client._Account    := edtAccount.Text;
  mClient.client._mail       := edtMail.Text;
  mclient.Write;
end;

procedure TformInputClient.WriteScreen(const id: integer);
begin
  mClient:= TModule_Client.Create(id);
  mClient.Read;
  edtFirstName.Text  := mClient.client._FirstName;
  edtLastName.Text   := mClient.client._LastName;
  edtAddress.Text    := mClient.client._Address;
  edtComplement.Text := mClient.client._supplement;
  edtCity.Text       := mClient.client._City;
  edtZipCode.Text    := mClient.client._ZipCode;
  edtLand.Text       := mClient.client._Country;
  edtPhonenumber.Text:= mClient.client._Phone;
  edtMobile.Text     := mClient.client._Mobile;
  edtAccount.Text    := mClient.client._Account;
  edtMail.Text       := mClient.client._mail;
end;

end.
