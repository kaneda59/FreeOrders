unit uni.frmListOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uni.frmListBase, uniGUIBaseClasses, uniImageList,
  Data.DB, uniBitBtn, uniEdit, uniToolBar, uniBasicGrid, uniDBGrid, uniButton,
  uniLabel, uniPanel;

type
  TformListOrders = class(TformBaseList)
  private
    { Private declarations }
    procedure FillTable; override;
    procedure fltfldListStateGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  public
    { Public declarations }
    procedure ConfigureGrid; override;
    procedure _ExecuteAction(const id: Integer); override;
    procedure RefreshData(sender: TObject; const id: integer); override;
    class procedure ShowList(const modeList: TModeList; var id: Integer);
  end;

function formListOrders: TformListOrders;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Logs, consts_,
  uni.frmInputOrder,
  uni.cli.datas, classebase;

function formListOrders: TformListOrders;
begin
  Result := TformListOrders(UniMainModule.GetFormInstance(TformListOrders));
end;

{ TformListOrders }

procedure TformListOrders.ConfigureGrid;
begin
  inherited;
  if List.recordCount>0 then
  begin
    dbgrd.Columns[0].Visible:= False;
    dbgrd.Columns[1].Title.Caption:= 'Code';
    dbgrd.Columns[1].Width:= 300;
    dbgrd.Columns[2].Visible:= False;
    dbgrd.Columns[3].Title.Caption:= 'Date';
    dbgrd.Columns[3].Width:= 100;
    dbgrd.Columns[4].Title.Caption:= 'Statut';
    dbgrd.Columns[4].Width:= 200;
    dbgrd.Columns[5].Title.Caption:= 'Client';
    dbgrd.Columns[5].Width:= 300;
  end;
end;

procedure TformListOrders.FillTable;
begin
  inherited;
  List.Name:= 'orders';
  List.FieldDefs.Clear;
  List.FieldDefs.Add('id',         ftInteger,  0, True);
  List.FieldDefs.Add('Code',       ftstring,  80, False);
  List.FieldDefs.Add('idClient',   ftInteger,  0, False);
  List.FieldDefs.Add('date',       ftDateTime, 0, False);
  List.FieldDefs.Add('stateOrder', ftInteger,  0, False);
  List.FieldDefs.Add('client',     ftstring, 120, False);
  List.CreateDataSet;

  refreshData(Self, 0);
  List.FieldByName('stateOrder').OnGetText:= fltfldListStateGetText;
end;

procedure TformListOrders.fltfldListStateGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  inherited;
  if List.RecordCount>0 then
    Text:= strState[TState(Sender.AsInteger)];
end;

procedure TformListOrders.RefreshData(sender: TObject; const id: integer);
begin
  inherited;
  if List.Active then
  begin
    List.First;
    while not List.eof do
      List.Delete;
  end;

  UniMainModule.microService.sqlQuery('SELECT o.*, c.firstname || '' '' || c.lastname as client from orders o, clients c where c.id=o.idclient', list);
  ds.DataSet:= List;
  ConfigureGrid;
end;

class procedure TformListOrders.ShowList(const modeList: TModeList;
  var id: Integer);
begin
  formListOrders.TitleForm:= 'Liste des commandes';
  formListOrders.current_modeList:= modeList;
  formListOrders.FillTable;
  formListOrders.ShowModal(Procedure(Sender: TComponent; Result:Integer)
    var id: integer;
    begin
      if (Result=mrOk)  and (modeList=mdSelection) then
      begin
        id:= formListOrders.List.FieldByName('id').AsInteger;
        if Assigned(formListOrders.OnResultOK) then
        begin
          formListOrders.OnResultOK(Sender, id);
        end;
      end;
    end);
end;

procedure TformListOrders._ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : TformInputOrders.Execute(0, RefreshData);
     200 : TformInputOrders.Execute(List.FieldByName('id').AsInteger, RefreshData);
  end;
end;

end.
