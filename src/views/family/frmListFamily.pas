unit frmListFamily;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmListBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls, System.UITypes;

type
  TformListFamily = class(TFormBaseList)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ConfigureGrid; override;
    procedure _ExecuteAction(const id: Integer); override;
    class function ShowList(const modeList: TModeList; var id: Integer): Boolean;
  end;

var
  formListFamily: TformListFamily;

implementation

{$R *.dfm}
  uses module, logs, consts_, frmInputFamily;

{ TformListFamily }

procedure TformListFamily.ConfigureGrid;
begin
  inherited;
  dbgrd.Columns[0].Visible:= False;
  dbgrd.Columns[1].Title.Caption:= 'Code';
  dbgrd.Columns[1].Width:= 100;
  dbgrd.Columns[2].Title.Caption:= 'Libellé';
  dbgrd.Columns[2].Width:= 300;
end;

procedure TformListFamily._ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : if TformInputFamily.Execute(0) then UpdateData;
     200 : if TformInputFamily.Execute(qryList.FieldByName('id').AsInteger) then UpdateData;
     300 : if messageDLG('voulez-vous supprimer cette famille ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
             qryList.Delete;
  end;
end;

class function TformListFamily.ShowList(const modeList: TModeList;
  var id: Integer): Boolean;
begin
  Application.CreateForm(TformListFamily, formListFamily);
  try
    formListFamily.TitleForm:= 'familles de produits';
    formListFamily.current_modeList:= modeList;
    formListFamily.qryList.Connection:= Donnees.connection;
    formListFamily.qryList.SQL.Clear;
    formListFamily.qryList.SQL.Add('SELECT id, Code, Label FROM family');
    Result := formListFamily.ShowModal = mrOk;
    if Result and (modeList=mdSelection) then
      id:= formListFamily.qryList.FieldByName('id').AsInteger;
  finally
    FreeAndNil(formListFamily);
  end;
end;

end.
