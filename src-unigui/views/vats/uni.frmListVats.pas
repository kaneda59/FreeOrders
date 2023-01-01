unit uni.frmListVats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, Datasnap.DBClient,
  uniGUIClasses, uniGUIForm, uni.frmListBase, Data.DB, Data.Win.ADODB,
  uniBitBtn, uniEdit, uniButton, uniBasicGrid, uniDBGrid, uniLabel,
  uniGUIBaseClasses, uniPanel, uni.frmBase, uniImageList, uniToolBar;

type
  TFormListVats = class(TformBaseList)
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

function FormListVats: TFormListVats;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Logs, consts_,
  uni.frmInputVat, uni.cli.datas
  , classebase;

function FormListVats: TFormListVats;
begin
  Result := TFormListVats(UniMainModule.GetFormInstance(TFormListVats));
end;

{ TformBaseList1 }

procedure TFormListVats.ConfigureGrid;
begin
  inherited;
  if Assigned(dbgrd.dataSource.Dataset) then
  begin
    dbgrd.Columns[0].Visible:= False;
    dbgrd.Columns[1].Title.Caption:= 'Libellé';
    dbgrd.Columns[1].Width:= 200;
    dbgrd.Columns[2].Title.Caption:= 'Taux';
    dbgrd.Columns[2].Width:= 100;
  end;
end;

procedure TFormListVats.RefreshData(sender: TObject; const id: integer);
begin
  inherited;
  List.First;
  while not List.eof do
    List.Delete;

  UniMainModule.microService.listObject(Tvat, FormListVats.List);
  FormListVats.ds.DataSet:= FormListVats.List;
  ConfigureGrid;
end;

procedure TFormListVats.FillTable;
begin
  inherited;
  List.Name:= 'vat';
  List.FieldDefs.Clear;
  List.FieldDefs.Add('_id', ftInteger, 0, True);
  List.FieldDefs[0].DisplayName:= 'id';
  List.FieldDefs.Add('_label', ftstring, 120, False);
  List.FieldDefs[1].DisplayName:= 'libellé';
  List.FieldDefs.Add('_value', ftFloat, 0, False);
  List.FieldDefs[2].DisplayName:= 'valeur';
  List.CreateDataSet;

  UniMainModule.microService.listObject(Tvat, FormListVats.List);
  FormListVats.ds.DataSet:= FormListVats.List;

  ConfigureGrid;
end;

class procedure TFormListVats.ShowList(const modeList: TModeList;
  var id: Integer; const OnResultOK_Event: TOnResultOK = nil);
begin
  //Application.CreateForm(TFormListVats, FormListVats);
  try
    FormListVats.TitleForm:= 'Taux de TVA';
    FormListVats.current_modeList:= modeList;
    FormListVats.FillTable;
    if modeList=mdMaj then
         FormListVats.OnResultOK := FormListVats.RefreshData
    else FormListVats.OnResultOK := OnResultOK_Event;
    FormListVats.ShowModal(Procedure(Sender: TComponent; Result:Integer)
    var id: integer;
    begin
      if (Result=mrOk)  and (modeList=mdSelection) then
      begin
        id:= FormListVats.List.FieldByName('_id').AsInteger;
        if Assigned(formListVats.OnResultOK) then
        begin
          formListVats.OnResultOK(Sender, id);
        end;
      end;
    end);
  finally
  //  FreeAndNil(FormListVats);
  end;
end;

procedure TFormListVats._ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : TformInputVat.Execute(0, RefreshData);
     200 : TformInputVat.Execute(List.FieldByName('_id').AsInteger, RefreshData);
    // 300 : if messageDLG('voulez-vous supprimer ce taux de TVA ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      //       deleteObject(qryList.FieldByName('id').AsInteger, TVat);
  end;
end;

end.
