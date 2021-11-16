unit frmInputClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, classebase, json.tools, //module.client,
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
    client: TClient;
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
uses Module, Logs, Consts_, cli.datas, configuration;

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
  FreeAndNil(Client);
end;

procedure TformInputClient.ReadScreen(const id: integer);
begin
  if Assigned(client) then
  begin
    client._FirstName  := edtFirstName.Text;
    client._LastName   := edtLastName.Text;
    client._Address    := edtAddress.Text;
    client._supplement := edtComplement.Text;
    client._City       := edtCity.Text;
    client._ZipCode    := edtZipCode.Text;
    client._Country    := edtLand.Text;
    client._Phone      := edtPhonenumber.Text;
    client._Mobile     := edtMobile.Text;
    client._Account    := edtAccount.Text;
    client._mail       := edtMail.Text;
    setObject(client, TClient);
//    Service.setCustomer(configfile.connection_server.appid, ParamToJSon(global_param), ClientToJSon(Client));
  end;
end;

procedure TformInputClient.WriteScreen(const id: integer);
begin
  client:= TClient(cli.datas.getObject(id, TClient));
  if Assigned(Client) then
  begin
    edtFirstName.Text  := client._FirstName;
    edtLastName.Text   := client._LastName;
    edtAddress.Text    := client._Address;
    edtComplement.Text := client._supplement;
    edtCity.Text       := client._City;
    edtZipCode.Text    := client._ZipCode;
    edtLand.Text       := client._Country;
    edtPhonenumber.Text:= client._Phone;
    edtMobile.Text     := client._Mobile;
    edtAccount.Text    := client._Account;
    edtMail.Text       := client._mail;
  end;
end;

end.
