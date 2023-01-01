unit uni.frmListBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, Datasnap.DBClient, uni.frmBase,
  uniGUIBaseClasses, uniImageList, Data.DB, Data.Win.ADODB, uniBitBtn, uniEdit,
  uniToolBar, uniGUIClasses, uniBasicGrid, uniDBGrid, uniButton, uniLabel,
  uniPanel,  uniGUIForm, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;



type
  TModeList = (mdSelection, mdMaj);
  TformBaseList = class(TformBase)
    dbGrd: TUniDBGrid;
    ds: TDataSource;
    pnlSearch: TUniPanel;
    ToolBar: TUniToolBar;
    btnNew: TUniToolButton;
    btnUpdate: TUniToolButton;
    btnDelete: TUniToolButton;
    UniToolButton1: TUniToolButton;
    UniToolButton2: TUniToolButton;
    edtSearch: TUniEdit;
    UniBitBtn1: TUniBitBtn;
    imgList: TUniImageList;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure dsDataChange(Sender: TObject; Field: TField);
    procedure qryListAfterOpen(DataSet: TDataSet);
    procedure ActionClick(Sender: TObject);
    procedure dbGrdDblClick(Sender: TObject);
    procedure UniBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    FModeList: TModeList;
    FFieldNameSearch: string;
    procedure setModeList(const Value: TModeList);
  public
    { Public declarations }
    List: TClientDataset;
    procedure ConfigureGrid; virtual; abstract;
    procedure _ExecuteAction(const id: integer); virtual; abstract;
    procedure UpdateData;
    procedure RefreshData(sender: TObject; const id: integer); virtual;
    procedure FillDatas; virtual; abstract;
    procedure FillTable; virtual; abstract;

    property current_modeList: TModeList read FModeList write setModeList;
    property fieldNameSearch: string     read FFieldNameSearch write FFieldNameSearch;
  end;

function formBaseList: TformBaseList;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, logs;

function formBaseList: TformBaseList;
begin
  Result := TformBaseList(UniMainModule.GetFormInstance(TformBaseList));
end;

{ TformBaseList }

procedure TformBaseList.ActionClick(Sender: TObject);
begin
  inherited;
  _ExecuteAction(TComponent(Sender).Tag);
end;

procedure TformBaseList.dbGrdDblClick(Sender: TObject);
begin
  inherited;
  if FModeList = mdSelection then
       btnValid.Click
  else ActionClick(btnUpdate);
end;

procedure TformBaseList.dsDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  btnUpdate.Enabled:= ds.DataSet.RecordCount>0;
  btnDelete.Enabled:= ds.DataSet.RecordCount>0;
end;

procedure TformBaseList.qryListAfterOpen(DataSet: TDataSet);
begin
  inherited;
  ConfigureGrid;
end;

procedure TformBaseList.RefreshData(sender: TObject; const id: integer);
begin
  UpdateData;
end;

procedure TformBaseList.setModeList(const Value: TModeList);
begin
  FModeList := Value;
  btnNew.Visible   := Value=mdMaj;
  btnUpdate.Visible:= Value=mdMaj;
  btnDelete.Visible:= Value=mdMaj;

  if Value=mdSelection then
    WindowState := wsMaximized;

  if Value=mdSelection then
  begin
    btnCancel.Visible:= True;
    btnValid.Caption:= 'Choisir';
  end
  else
  begin
    btnCancel.Visible:= False;
    btnValid.Caption:= 'Fermer';
  end;
end;

procedure TformBaseList.UniBitBtn1Click(Sender: TObject);
begin
  inherited;
  if FieldNameSearch<>'' then
    List.Locate(FieldNameSearch, edtSearch.Text, [loPartialKey, loCaseInsensitive]);
end;

procedure TformBaseList.UniFormCreate(Sender: TObject);
begin
  inherited;
  List          := TClientDataSet.create(nil);
  List.AfterOpen:= qryListAfterOpen;
end;

procedure TformBaseList.UniFormDestroy(Sender: TObject);
begin
  inherited;
  if List.Active then List.Close;

  FreeAndNil(List);
end;

procedure TformBaseList.UpdateData;
begin
  List.Close;
  List.Open;
end;

end.
