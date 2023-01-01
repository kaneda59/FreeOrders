unit uni.frmListItems;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, Datasnap.DBClient,
  uni.frmListBase, uniGUIBaseClasses, uniImageList, Data.DB, uniBitBtn, uniEdit,
  uniToolBar, uniGUIClasses, uniBasicGrid, uniDBGrid, uniButton, uniLabel,
  uniPanel, uniGUIForm;

type
  TformListItems = class(TformBaseList)
  private
    procedure FillTable; override;
    { Private declarations }
  public
    { Public declarations }
    procedure ConfigureGrid; override;
    procedure _ExecuteAction(const id: Integer); override;
    procedure RefreshData(sender: TObject; const id: integer); override;
    class procedure ShowList(const modeList: TModeList; var id: Integer);
  end;

function formListItems: TformListItems;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Logs, consts_,
  uni.frmInputItem,
  uni.cli.datas, classebase;

function formListItems: TformListItems;
begin
  Result := TformListItems(UniMainModule.GetFormInstance(TformListItems));
end;

{ TformBaseList1 }

procedure TformListItems.ConfigureGrid;
begin
  inherited;
  if List.recordCount>0 then
  begin
    dbgrd.Columns[0].Visible:= False;
    dbgrd.Columns[1].Title.Caption:= 'Libellé';
    dbgrd.Columns[1].Width:= 300;
    dbgrd.Columns[2].Title.Caption:= 'PV HT';
    dbgrd.Columns[2].Width:= 100;
    dbgrd.Columns[3].Title.Caption:= 'TVA';
    dbgrd.Columns[3].Width:= 100;
    dbgrd.Columns[4].Title.Caption:= 'Famille';
    dbgrd.Columns[4].Width:= 200;
  end;
end;

procedure TformListItems.FillTable;
begin
  inherited;
  List.Name:= 'items';
  List.FieldDefs.Clear;
  List.FieldDefs.Add('id', ftInteger, 0, True);
  List.FieldDefs.Add('label', ftstring, 120, False);
  List.FieldDefs.Add('pvht', ftFloat, 0, False);
  List.FieldDefs.Add('vats', ftFloat, 0, False);
  List.FieldDefs.Add('code', ftString, 80, False);
  List.CreateDataSet;

  refreshData(Self, 0);
end;

procedure TformListItems.RefreshData(sender: TObject; const id: integer);
begin
  inherited;
  if List.Active then
  begin
    List.First;
    while not List.eof do
      List.Delete;
  end;

  UniMainModule.microService.sqlQuery('SELECT i.id as id, i.label as label, i.pvht as pvht, t.value as vats, f.code as code ' +
                                      'FROM items i, vats t, family f WHERE i.idvat=t.id AND   i.idfamily=f.id', list);
  ds.DataSet:= List;
  ConfigureGrid;
end;

class procedure TformListItems.ShowList(const modeList: TModeList;
  var id: Integer);
begin
  formListItems.TitleForm:= 'Liste des produits';
  formListItems.current_modeList:= modeList;
  formListItems.FillTable;
  formListItems.ShowModal(Procedure(Sender: TComponent; Result:Integer)
    var id: integer;
    begin
      if (Result=mrOk)  and (modeList=mdSelection) then
      begin
        id:= formListItems.List.FieldByName('_id').AsInteger;
        if Assigned(formListItems.OnResultOK) then
        begin
          formListItems.OnResultOK(Sender, id);
        end;
      end;
    end);
end;

procedure TformListItems._ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : TformInputItem.Execute(0, RefreshData);
     200 : TformInputItem.Execute(List.FieldByName('id').AsInteger, RefreshData);
  end;
end;

end.
