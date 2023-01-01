unit uni.frmListSuppliers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uni.frmListBase, Data.DB, Data.Win.ADODB,
  uniBitBtn, uniEdit, uniBasicGrid, uniDBGrid, uniButton, uniLabel,
  uniGUIBaseClasses, uniPanel, uni.frmBase, uniImageList, uniToolBar;

type
  TformListSuppliers = class(TformBaseList)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FillTable; override;
    procedure RefreshData(sender: TObject; const id: integer); override;
    procedure ConfigureGrid; override;
    procedure _ExecuteAction(const id: Integer); override;
    class procedure ShowList(const modeList: TModeList; var id: Integer; const OnResultOK_Event: TOnResultOK = nil);
  end;

function formListSuppliers: TformListSuppliers;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Logs, consts_,
  uni.frmInputSupplier,
  uni.cli.datas, classebase;

function formListSuppliers: TformListSuppliers;
begin
  Result := TformListSuppliers(UniMainModule.GetFormInstance(TformListSuppliers));
end;

{ TformListSuppliers }

procedure TformListSuppliers.RefreshData(sender: TObject; const id: integer);
begin
  inherited;
  List.First;
  while not List.eof do
    List.Delete;

  UniMainModule.microService.listObject(TSupplier, List);
  ds.DataSet:= List;
  ConfigureGrid;
end;

procedure TformListSuppliers.ConfigureGrid;
begin
  inherited;
  if Assigned(dbgrd.dataSource.Dataset) then
  begin
    dbgrd.Columns[0].Visible:= False;
    dbgrd.Columns[1].Title.Caption:= 'Nom';
    dbgrd.Columns[1].Width:= 400;

    dbgrd.Columns[2].Visible:= False;

    dbgrd.Columns[3].Title.Caption:= 'Adresse';
    dbgrd.Columns[3].Width:= 200;

    dbgrd.Columns[4].Visible:= False;

    dbgrd.Columns[5].Title.Caption:= 'Code Postal';
    dbgrd.Columns[5].Width:= 100;

    dbgrd.Columns[6].Title.Caption:= 'Ville';
    dbgrd.Columns[6].Width:= 200;

    dbgrd.Columns[7].Visible:= False;

    dbgrd.Columns[8].Visible:= False;

    dbgrd.Columns[9].Visible:= False;

    dbgrd.Columns[10].Visible:= False;

    dbgrd.Columns[11].Visible:= False;
  end;
end;

procedure TformListSuppliers.FillTable;
begin
  inherited;
  List.Name:= 'suppliers';
  List.FieldDefs.Clear;
  List.FieldDefs.Add('_id', ftInteger, 0, True);            // 0
  List.FieldDefs.Add('_Label', ftstring, 120, False);       // 1
  List.FieldDefs.Add('_Description', ftstring, 120, False);  // 2
  List.FieldDefs.Add('_Address', ftstring, 120, False);      // 3
  List.FieldDefs.Add('_supplement', ftstring, 120, False);   // 4
  List.FieldDefs.Add('_ZipCode', ftstring, 120, False);      // 5
  List.FieldDefs.Add('_City', ftstring, 120, False);         // 6
  List.FieldDefs.Add('_Country', ftstring, 120, False);      // 7
  List.FieldDefs.Add('_Phone', ftstring, 120, False);        // 8
  List.FieldDefs.Add('_Mobile', ftstring, 120, False);       // 9
  List.FieldDefs.Add('_Account', ftstring, 120, False);      // 10
  List.FieldDefs.Add('_mail', ftstring, 120, False);         // 11
  List.CreateDataSet;

  UniMainModule.microService.listObject(TSupplier, List);
  ds.DataSet:= List;

  ConfigureGrid;
end;

class procedure TformListSuppliers.ShowList(const modeList: TModeList;
  var id: Integer; const OnResultOK_Event: TOnResultOK = nil);
begin
  formListSuppliers.TitleForm:= 'Liste des fournisseurs';
  formListSuppliers.current_modeList:= modeList;
  formListSuppliers.FillTable;
//  formListSuppliers.qryList.Connection:= uniMainModule.ModuleDonnees.connection;
//  formListSuppliers.qryList.SQL.Clear;
//  formListSuppliers.qryList.SQL.Add('SELECT id, Label, Address, ZipCode, City FROM Suppliers');
  if modeList=mdMaj then
       formListSuppliers.OnResultOK := formListSuppliers.RefreshData
  else formListSuppliers.OnResultOK := OnResultOK_Event;
  formListSuppliers.ShowModal(Procedure(Sender: TComponent; Result:Integer)
    var id: integer;
    begin
      if (Result=mrOk)  and (modeList=mdSelection) then
      begin
        id:= formListSuppliers.List.FieldByName('_id').AsInteger;
        if Assigned(formListSuppliers.OnResultOK) then
        begin
          formListSuppliers.OnResultOK(Sender, id);
        end;
      end;
    end);
end;

procedure TformListSuppliers._ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : TforInputSupplier.Execute(0, RefreshData);
     200 : TforInputSupplier.Execute(List.FieldByName('_id').AsInteger, RefreshData);
//     300 : if messageDLG('voulez-vous supprimer ce fournisseur ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//             deleteObject(qryList.FieldByName('id').AsInteger, TSupplier);
  end;
end;

end.
