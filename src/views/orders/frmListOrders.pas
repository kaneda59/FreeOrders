unit frmListOrders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmListBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformListOrders = class(TFormBaseList)
  private
    procedure fltfldListStateGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure fltfldDateGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ConfigureGrid; override;
    procedure ExecuteAction(const id: Integer); override;
    class function ShowList(const modeList: TModeList; var id: Integer): Boolean;
  end;

var
  formListOrders: TformListOrders;

implementation

{$R *.dfm}
  uses module, logs, consts_, classebase, frmInputOrders;

{ TFormBaseList1 }

procedure TformListOrders.ConfigureGrid;
begin
  inherited;
  dbgrd.Columns[0].Visible:= False;
  dbgrd.Columns[1].Title.Caption:= 'Code';
  dbgrd.Columns[1].Width:= 100;
  dbgrd.Columns[2].Visible:= False;
  dbgrd.Columns[3].Title.Caption:= 'Date';
  dbgrd.Columns[3].Width:= 100;
  dbgrd.Columns[4].Title.Caption:= 'Statut';
  dbgrd.Columns[4].Width:= 100;
  dbgrd.Columns[5].Title.Caption:= 'Client';
  dbgrd.Columns[5].Width:= 300;

  qryList.FieldByName('StateOrder').OnGetText:= fltfldListStateGetText;
  qryList.FieldByName('date').OnGetText:= fltfldDateGetText;
end;

procedure TformListOrders.fltfldDateGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text:= FormatDateTime(FormatSettings.ShortDateFormat, Sender.AsDateTime);
end;

procedure TformListOrders.fltfldListStateGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  inherited;
  if qryList.RecordCount>0 then
    Text:= strState[TState(Sender.AsInteger)];
end;

procedure TformListOrders.ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : if TformInputOrders.Execute(0) then UpdateData;
     200 : if TformInputOrders.Execute(qryList.FieldByName('id').AsInteger) then UpdateData;
     300 : if messageDLG('voulez-vous supprimer ce bon de commande ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
             qryList.Delete;
  end;
end;

class function TformListOrders.ShowList(const modeList: TModeList;
  var id: Integer): Boolean;
begin
  Application.CreateForm(TformListOrders, formListOrders);
  try
    formListOrders.TitleForm:= 'Commandes';
    formListOrders.current_modeList:= modeList;
    formListOrders.qryList.Connection:= Donnees.connection;
    formListOrders.qryList.SQL.Clear;
    formListOrders.qryList.SQL.Add('SELECT o.*, c.firstname || '' '' || c.lastname as client from orders o, clients c where c.id=o.idclient');
    Result := formListOrders.ShowModal = mrOk;
    if Result and (modeList=mdSelection) then
      id:= formListOrders.qryList.FieldByName('id').AsInteger;
  finally
    FreeAndNil(formListOrders);
  end;
end;

end.
