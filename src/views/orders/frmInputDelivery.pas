unit frmInputDelivery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, module.orders,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformInputDelivery = class(TformBaseInput)
    cbbStatut: TComboBox;
    lblState: TLabel;
    lblInformation: TLabel;
    lblCommande: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbbStatutChange(Sender: TObject);
  private
    { Déclarations privées }
    mOrder: TModule_orders;
    procedure WriteScreen(const id: Integer);
    procedure ReadScreen(const id: integer);
  public
    { Déclarations publiques }
    class function Execute(const id: Integer): Boolean;
  end;

var
  formInputDelivery: TformInputDelivery;

implementation

{$R *.dfm}
  uses logs, consts_, Module, classebase;

{ TformInputDelivery }

procedure TformInputDelivery.cbbStatutChange(Sender: TObject);
begin
  inherited;
  cbbStatut.OnChange:= nil;
  if TState(cbbStatut.ItemIndex)<mOrder.Orders._stateOrder then
  begin
    MessageDLG('vous ne pouvez revenir à un statut ultérieur', mtWarning, [mbOk], 0);
    cbbStatut.ItemIndex:= cbbStatut.Items.IndexOf(strState[mOrder.Orders._stateOrder]);
  end;
  cbbStatut.OnChange:= cbbStatutChange;
end;

class function TformInputDelivery.Execute(const id: Integer): Boolean;
begin
  Application.CreateForm(TformInputDelivery, formInputDelivery);
  try
    formInputDelivery.WriteScreen(id);
    formInputDelivery.TitleForm:= 'Statut de commande';
    result:= formInputDelivery.showModal = mrOk;
    if result then
      formInputDelivery.ReadScreen(id);
  finally
    FreeAndNil(formInputDelivery);
  end;
end;

procedure TformInputDelivery.FormCreate(Sender: TObject);
var i: TState;
begin
  inherited;
  cbbStatut.Items.Clear;
  for i := Low(TState) to High(TState) do
    cbbStatut.Items.Add(StrState[i]);
end;

procedure TformInputDelivery.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(mOrder);
end;

procedure TformInputDelivery.ReadScreen(const id: integer);
begin
  mOrder.Orders._stateOrder:= TState(cbbStatut.ItemIndex);
  mOrder.Write;
end;

procedure TformInputDelivery.WriteScreen(const id: Integer);
begin
  mOrder:= TModule_orders.Create(id);
  mOrder.Read;
  lblCommande.Caption:= 'Commande N°' + mOrder.Orders._Code;
  cbbStatut.ItemIndex:= cbbStatut.Items.IndexOf(strState[mOrder.Orders._stateOrder]);
end;

end.
