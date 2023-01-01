unit uni.frmListCustomers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, uni.frmBase, classebase,
  uniGUIClasses, uniGUIForm, uni.frmListBase, uniGUIBaseClasses, uniImageList,
  Data.DB, uniBitBtn, uniEdit, uniToolBar, uniBasicGrid, uniDBGrid, uniButton,
  uniLabel, uniPanel;

type
  TformListCustomers = class(TformBaseList)
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

function formListCustomers: TformListCustomers;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, uni.frmInputCustomer;

function formListCustomers: TformListCustomers;
begin
  Result := TformListCustomers(UniMainModule.GetFormInstance(TformListCustomers));
end;

{ TformListCustomers }

procedure TformListCustomers.ConfigureGrid;
begin
  inherited;
  if Assigned(dbgrd.dataSource.Dataset) then
  begin
    dbgrd.Columns[0].Visible:= False;
    dbgrd.Columns[1].Title.Caption:= 'Nom';
    dbgrd.Columns[1].Width:= 400;

    dbgrd.Columns[2].Title.Caption:= 'Prénom';
    dbgrd.Columns[2].Width:= 400;

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

procedure TformListCustomers.FillTable;
begin
  inherited;
  List.Name:= 'customers';
  List.FieldDefs.Clear;
  List.FieldDefs.Add('_id', ftinteger, 0, True);
  List.FieldDefs.Add('_FirstName', ftstring, 120, False);
  List.FieldDefs.Add('_LastName', ftstring, 120, False);
  List.FieldDefs.Add('_Address', ftstring, 120, False);
  List.FieldDefs.Add('_supplement', ftstring, 120, False);
  List.FieldDefs.Add('_ZipCode', ftstring, 120, False);
  List.FieldDefs.Add('_City', ftstring, 120, False);
  List.FieldDefs.Add('_Country', ftstring, 120, False);
  List.FieldDefs.Add('_Phone', ftstring, 120, False);
  List.FieldDefs.Add('_Mobile', ftstring, 120, False);
  List.FieldDefs.Add('_Account', ftstring, 120, False);
  List.FieldDefs.Add('_mail', ftstring, 120, False);
  List.CreateDataSet;

  UniMainModule.microService.listObject(TClient, formListCustomers.List);
  formListCustomers.ds.DataSet:= formListCustomers.List;

  ConfigureGrid;
end;

procedure TformListCustomers.RefreshData(sender: TObject; const id: integer);
begin
  inherited;
  List.First;
  while not List.eof do
    List.Delete;

  UniMainModule.microService.listObject(TClient, List);
  ds.DataSet:= List;
  ConfigureGrid;
end;

class procedure TformListCustomers.ShowList(const modeList: TModeList;
  var id: Integer; const OnResultOK_Event: TOnResultOK);
begin
  formListCustomers.TitleForm:= 'Liste des clients';
  formListCustomers.current_modeList:= modeList;
  formListCustomers.FillTable;
  if modeList=mdMaj then
       formListCustomers.OnResultOK := formListCustomers.RefreshData
  else formListCustomers.OnResultOK := OnResultOK_Event;
  formListCustomers.ShowModal(Procedure(Sender: TComponent; Result:Integer)
    var id: integer;
    begin
      if (Result=mrOk)  and (modeList=mdSelection) then
      begin
        id:= formListCustomers.List.FieldByName('_id').AsInteger;
        if Assigned(formListCustomers.OnResultOK) then
        begin
          formListCustomers.OnResultOK(Sender, id);
        end;
      end;
    end);
end;

procedure TformListCustomers._ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : TformInputCustomer.Execute(0, RefreshData);
     200 : TformInputCustomer.Execute(List.FieldByName('_id').AsInteger, RefreshData);
//     300 : if messageDLG('voulez-vous supprimer ce fournisseur ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//             deleteObject(qryList.FieldByName('id').AsInteger, TSupplier);
  end;
end;

end.
