unit uni.frmListFamily;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uni.frmListBase, Data.DB, Data.Win.ADODB,
  uniBitBtn, uniEdit, uniButton, uniBasicGrid, uniDBGrid, uniLabel,
  uniGUIBaseClasses, uniPanel, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls, Vcl.ExtCtrls, uni.frmBase, uniImageList, uniToolBar;

type
  TformListFamily = class(TformBaseList)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FillTable; override;
    procedure ConfigureGrid; override;
    procedure _ExecuteAction(const id: Integer); override;
    procedure RefreshData(sender: TObject; const id: integer); override;
    class procedure ShowList(const modeList: TModeList; var id: Integer; const OnResultOK_Event: TOnResultOK = nil);
  end;

function formListFamily: TformListFamily;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Logs, consts_,
  uni.frmInputFamily,
  uni.cli.datas, classebase;

function formListFamily: TformListFamily;
begin
  Result := TformListFamily(UniMainModule.GetFormInstance(TformListFamily));
end;

{ TformBaseList1 }

procedure TformListFamily.ConfigureGrid;
begin
  inherited;
  if Assigned(dbgrd.dataSource.Dataset) then
  begin
    dbgrd.Columns[0].Visible:= False;
    dbgrd.Columns[1].Title.Caption:= 'Code';
    dbgrd.Columns[1].Width:= 100;
    dbgrd.Columns[2].Title.Caption:= 'Libellé';
    dbgrd.Columns[2].Width:= 300;
    dbgrd.Columns[3].Visible:= False;
  end;
end;

procedure TformListFamily.RefreshData(sender: TObject; const id: integer);
begin
  inherited;
  List.First;
  while not List.eof do
    List.Delete;

  UniMainModule.microService.listObject(TFamily, List);
  ds.DataSet:= List;
  ConfigureGrid;
end;

procedure TformListFamily.FillTable;
begin
  inherited;
  List.Name:= 'familly';
  List.FieldDefs.Clear;
  List.FieldDefs.Add('_id', ftInteger, 0, True);
  List.FieldDefs[0].DisplayName:= 'id';
  List.FieldDefs.Add('_code', ftstring, 60, False);
  List.FieldDefs[1].DisplayName:= 'libellé';
  List.FieldDefs.Add('_Label', ftString, 120, False);
  List.FieldDefs[2].DisplayName:= 'valeur';
  List.FieldDefs.Add('_Description', ftString, 120, False);
  List.FieldDefs[3].DisplayName:= 'Description';
  List.CreateDataSet;

  UniMainModule.microService.listObject(TFamily, List);
  ds.DataSet:= List;

  ConfigureGrid;
end;

class procedure TformListFamily.ShowList(const modeList: TModeList;
  var id: Integer; const OnResultOK_Event: TOnResultOK = nil);
begin
    formListFamily.TitleForm:= 'familles de produits';
    formListFamily.current_modeList:= modeList;
    formListFamily.FillTable;
//    formListFamily.qryList.Connection:= uniMainModule.ModuleDonnees.connection;
//    formListFamily.qryList.SQL.Clear;
    if modeList=mdMaj then
         formListFamily.OnResultOK := formListFamily.RefreshData
    else formListFamily.OnResultOK := OnResultOK_Event;
//    formListFamily.qryList.SQL.Add('SELECT id, Code, Label FROM family');
//    formListFamily.qryList.SQL.Add('ORDER BY id');
    formListFamily.ShowModal(Procedure(Sender: TComponent; Result:Integer)
    var id: integer;
    begin
      if (Result=mrOk)  and (modeList=mdSelection) then
      begin
        id:= formListFamily.List.FieldByName('_id').AsInteger;
        if Assigned(formListFamily.OnResultOK) then
        begin
          formListFamily.OnResultOK(Sender, id);
        end;
      end;
    end);;
end;

procedure TformListFamily._ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : TformInputFamily.Execute(0, RefreshData);
     200 : TformInputFamily.Execute(List.FieldByName('_id').AsInteger, RefreshData);
    // 300 : if messageDLG('voulez-vous supprimer ce taux de TVA ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      //       deleteObject(qryList.FieldByName('id').AsInteger, TVat);
  end;
end;

end.
