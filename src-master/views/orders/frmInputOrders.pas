unit frmInputOrders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, classebase,  json.Tools,
  module.client, module.items, module.vat, Data.DBXJSON,//module.orders,
  System.Math, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids, System.UITypes;

type
  TformInputOrders = class(TformBaseInput)
    pnlread: TPanel;
    grid: TStringGrid;
    pnlSummer: TPanel;
    edtTotal: TEdit;
    grpHeader: TGroupBox;
    edtClient: TEdit;
    edtCode: TEdit;
    lblState: TLabel;
    Code: TLabel;
    lblClient: TLabel;
    lblDate: TLabel;
    grpItems: TGroupBox;
    edtCodeProduit: TEdit;
    edtQte: TEdit;
    btnClient: TButton;
    btnProduit: TButton;
    btnAdd: TButton;
    btnUpdate: TButton;
    btnDelete: TButton;
    edtRemise: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnClientClick(Sender: TObject);
    procedure btnProduitClick(Sender: TObject);
    procedure OnLineClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtQteKeyPress(Sender: TObject; var Key: Char);
    procedure gridClick(Sender: TObject);
  private
    { Déclarations privées }
    mclient: TModule_Client;
    mitems: TModule_items;
    mvat: TModule_Vat;
    order: TOrders;
    procedure IniGrid;
    procedure ShowGridInformation;
    procedure WriteScreen(const id: integer);
    procedure ReadScreen(const id: integer);
    function ControleLineIsOK: Boolean;
    procedure EmptyLines;
    procedure ShowLinesInformation;
  public
    { Déclarations publiques }
    class function Execute(const OrderId: integer): Boolean;
  end;

var
  formInputOrders: TformInputOrders;

implementation

{$R *.dfm}
  uses Module, consts_, Logs, cli.datas, configuration,
       frmListBase, frmListClients, frmListItems;

{ TformInputOrders }

procedure TformInputOrders.btnClientClick(Sender: TObject);
var id: integer;
begin
  inherited;
  if TformListClients.ShowList(mdSelection, id) then
  begin
    edtClient.Tag:= id;
    mclient:= TModule_Client.Create(id);
    mclient.Read;
    edtClient.Text:= mclient.client._FirstName + ' ' + mclient.client._LastName;
    FreeAndNil(mclient);
  end;
end;

procedure TformInputOrders.btnProduitClick(Sender: TObject);
var id: integer;
begin
  inherited;
  if TformListItems.ShowList(mdSelection, id) then
  begin
    edtCodeProduit.Tag:= id;
    mitems:= TModule_items.Create(id);
    mitems.Read;
    edtCodeProduit.Text:= mitems.Items._Code;
    FreeAndNil(mitems);
  end;
end;

class function TformInputOrders.Execute(const OrderId: integer): Boolean;
begin
  Application.CreateForm(TformInputOrders, formInputOrders);
  try
    formInputOrders.writeScreen(OrderId);
     formInputOrders.TitleForm:= 'Bon de commandes';
    result:= formInputOrders.ShowModal = mrOk;
    if result then
      formInputOrders.ReadScreen(OrderId);
  finally
    FreeAndNil(formInputOrders);
  end;
end;

procedure TformInputOrders.FormCreate(Sender: TObject);
begin
  inherited;
  IniGrid;
  EmptyLines;
end;

procedure TformInputOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(mClient) then FreeAndNil(mClient);
  if Assigned(mvat)    then FreeAndNil(mvat);
  if Assigned(mItems)  then FreeAndNil(mitems);
  if Assigned(order)   then FreeAndNil(order);
end;

procedure TformInputOrders.gridClick(Sender: TObject);
begin
  inherited;
  ShowLinesInformation;
end;

procedure TformInputOrders.IniGrid;
begin
  grid.RowCount:= 2;
  grid.Cells[0,0]:= 'Code';
  grid.Cells[1,0]:= 'Libellé';
  grid.Cells[2,0]:= 'Prix HT';
  grid.Cells[3,0]:= 'Qte';
  grid.Cells[4,0]:= 'TVA';
  grid.Cells[5,0]:= 'Remise';
  grid.Cells[6,0]:= 'Total HT';
  grid.Cells[7,0]:= 'Total TTC';
end;

procedure TformInputOrders.ShowGridInformation;
var i: Integer;
    totaltotal: double;
    totalTTC: double;
begin
  grid.RowCount:= Max(2, Length(order._Lines)+1);
  totaltotal:= 0;

  for i := Low(Order._Lines) to High(order._Lines) do
  begin
    mitems:= TModule_items.Create(order._Lines[i]._idItems);
    mvat  := TModule_Vat.Create(mitems.Items._idvat);
    try
      mitems.Read;
      mvat.Read;

      grid.Cells[0,i+1]:= mitems.items._Code;
      grid.Cells[1,i+1]:= mitems.Items._Label;
      grid.Cells[2,i+1]:= FormatFloat('0.00', mitems.Items._pvht);
      grid.Cells[3,i+1]:= FormatFloat('0',    order._Lines[i]._Qte);
      grid.Cells[4,i+1]:= FormatFloat('0.00', mvat.Vat._value);
      grid.Cells[5,i+1]:= FormatFloat('0.00', order._Lines[i]._MtRem);
      grid.Cells[6,i+1]:= FormatFloat('0.00', mitems.Items._pvht * order._Lines[i]._Qte);

      totalTTC:= (mitems.Items._pvht * order._Lines[i]._Qte) - order._Lines[i]._MtRem;
      totalTTC:= totalTTC + (totalTTC * mvat.Vat._value/100);
      totaltotal:= totaltotal + totalTTC;
      grid.Cells[7,i+1]:= FormatFloat('0.00', TotalTTC);

    finally
      FreeAndNil(mitems);
      FreeAndNil(mvat);
    end;
  end;

  edtTotal.Text:= FormatFloat('0.00', totaltotal);
  Application.ProcessMessages;
end;

procedure TformInputOrders.WriteScreen(const id: integer);
var result: TResultInformation;
    subrecordSet: TJSONArray;
    subrecordVal: TJSONValue;
    SubSize     : Integer;
    ii          : Integer;
    o           : TOrderLine;
    value       : TJSonValue;
begin
  if Assigned(Service) then
  begin
    global_param.id:= id;
    result:= JSonToResult(Service.getOrder(configfile.connection_server.appid, ParamToJSon(global_param)));
    if result.State='ok' then
    begin
      order:= JSonToOrders(result.response);
      if Assigned(order) then
      begin
        edtCode.Text:= order._Code;
        mclient:= TModule_Client.Create(order._idClient);
        mclient.Read;
        edtClient.Text:= mclient.client._FirstName + ' ' + mclient.client._LastName;
        edtClient.Tag:= order._idClient;
      end
      else order._date:= Now;

      value := TJSONObject.ParseJSONValue(result.response) as TJSonValue;

      subrecordSet := (TJSONObject(value).GetValue('_Lines')) as TJSONArray;
      SubSize:= subrecordSet.Size;
      for ii := 0 to Pred(SubSize) do
      begin
        subrecordVal:= subrecordSet.Get(ii);
        o := JSonToOrderLine(subrecordVal.ToString);
        Order.AddLine(o);
      end;
    end;
  end;
  lblDate.Caption:= 'Le ' + FormatDateTime('dd/mm/yyyy', order._date);
  lblState.Caption:= strState[order._stateOrder];
  FreeAndNil(mclient);

  ShowGridInformation;
end;

function TformInputOrders.ControleLineIsOK: Boolean;
begin
  result:= (edtCodeProduit.Text<>'') and (edtQte.Text<>'');
  if result then
   if edtRemise.Text='' then
     edtRemise.Text:= '0.00';
end;

procedure TformInputOrders.edtQteKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not CharInSet(Key, ['0'..'9',#8, #9]) then
    Key:= #0;
end;

procedure TformInputOrders.EmptyLines;
begin
  edtCodeProduit.Tag:= 0;
  edtCodeProduit.Text:= '';
  edtQte.Text:= '';
  edtRemise.Text:= '';
end;

procedure TformInputOrders.ShowLinesInformation;
begin
  if grid.Row>0 then
  begin
    edtCodeProduit.Text:= grid.Cells[0, grid.Row];
    edtCodeProduit.Tag := order._Lines[grid.Row-1]._idItems;
    edtQte.Text        := FormatFloat('0.00', order._Lines[grid.Row-1]._qte);
    edtRemise.Text     := FormatFloat('0.00', order._Lines[grid.Row-1]._MtRem);
  end;
end;

procedure TformInputOrders.OnLineClick(Sender: TObject);
var Lines: TarrayOrderLines;
begin
  inherited;
  case TComponent(Sender).Tag of
    100 : if ControleLineIsOK then
          begin
            Lines:= order._Lines;
            SetLength(Lines, Length(Lines)+1);
            Lines[High(Lines)]:= TOrderLine.Create;
            Lines[High(Lines)]._idItems:= edtCodeProduit.Tag;
            Lines[High(Lines)]._Qte:= StrToFloat(edtQte.Text);
            Lines[High(Lines)]._MtRem:= StrToFloat(edtRemise.Text);
            order._Lines:= Lines;
          end
          else
          begin
            MessageDlg('Vous devez saisir un produit et une qté valide', mtWarning, [mbOk], 0);
            edtCodeProduit.SetFocus;
          end;
    101 : if (grid.Row>0) and (ControleLineIsOK) then
          begin
            Lines:= order._Lines;
            Lines[grid.Row-1]:= TOrderLine.Create;
            Lines[grid.Row-1]._idItems:= edtCodeProduit.Tag;
            Lines[grid.Row-1]._Qte:= StrToFloat(edtQte.Text);
            Lines[grid.Row-1]._MtRem:= StrToFloat(edtRemise.Text);
            order._Lines:= Lines;
          end;
    102 :if (grid.Row>0) then
         if MessageDlg('Voulez-vous supprimer cette ligne ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
         begin

         end;
  end;
  ShowGridInformation;
end;

procedure TformInputOrders.ReadScreen(const id: integer);
begin
  order._id:= id;
  order._Code:= edtCode.Text;
  order._idClient:= edtClient.Tag;
  Service.setOrder(configfile.connection_server.appid, ParamToJSon(global_param), ordersToJSon(order));
end;

end.
