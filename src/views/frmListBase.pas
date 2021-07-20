unit frmListBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBase, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls, Data.Win.ADODB;

type
  TModeList = (mdSelection, mdMaj);
  TFormBaseList = class(TFormBase)
    dbgrd: TDBGrid;
    pnlSearch: TPanel;
    edtSearch: TEdit;
    btnSearch: TButton;
    ds: TDataSource;
    qryList: TADOQuery;
    pnlRight: TPanel;
    btnNew: TButton;
    btnUpdate: TButton;
    btnDelete: TButton;
    pnlBottom: TPanel;
    btnCancel: TButton;
    btnValid: TButton;
    procedure dsDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure qryListAfterOpen(DataSet: TDataSet);
    procedure btnSearchClick(Sender: TObject);
    procedure dbgrdDblClick(Sender: TObject);
  private
    FModeList: TModeList;
    procedure setModeList(const Value: TModeList);
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ConfigureGrid; virtual; abstract;
    property current_modeList: TModeList read FModeList write setModeList;
  end;

var
  FormBaseList: TFormBaseList;

implementation

{$R *.dfm}
  uses Module, logs;

procedure TFormBaseList.btnSearchClick(Sender: TObject);
var i: integer;
begin
  inherited;
  for i := 0 to qryList.FieldCount-1 do
  if qryList.Locate(qryList.Fields[0].FieldName, edtSearch.Text, [loPartialKey, loCaseInsensitive]) then
    Break;
end;

procedure TFormBaseList.dbgrdDblClick(Sender: TObject);
begin
  inherited;
  case FModeList of
    mdSelection : btnValid.Click;
    mdMaj : if btnUpdate.Enabled then
              btnUpdate.Click;
  end;
end;

procedure TFormBaseList.dsDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  btnUpdate.Enabled:= ds.DataSet.RecordCount>0;
  btnDelete.Enabled:= ds.DataSet.RecordCount>0;
end;

procedure TFormBaseList.FormCreate(Sender: TObject);
begin
  inherited;
  qryList.Connection:= Donnees.connection;
  qryList.SQL.Clear;
end;

procedure TFormBaseList.FormDestroy(Sender: TObject);
begin
  inherited;
  if qryList.Active then
    qryList.Close;
end;

procedure TFormBaseList.FormShow(Sender: TObject);
begin
  inherited;
  if qryList.SQL.Text<>'' then
  try
    qryList.Open;
  except
    on e: Exception do
      log.AddError('liste clients', e.Message);
  end;
end;

procedure TFormBaseList.qryListAfterOpen(DataSet: TDataSet);
begin
  inherited;
  ConfigureGrid;
end;

procedure TFormBaseList.setModeList(const Value: TModeList);
begin
  FModeList := Value;
  if Value=mdSelection then
  begin
    btnCancel.Visible:= True;
    btnValid.Caption:= 'Choisir';
    pnlRight.Visible:= False;
  end
  else
  begin
    btnCancel.Visible:= False;
    btnValid.Caption:= 'Fermer';
    pnlRight.Visible:= True;
  end;
end;

end.
