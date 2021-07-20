unit frmListItems;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmListBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformListItems = class(TFormBaseList)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ConfigureGrid; override;
    class function ShowList(const modeList: TModeList; var id: Integer): Boolean;
  end;

var
  formListItems: TformListItems;

implementation

{$R *.dfm}
  uses Module, Logs, Consts_;

{ TformListItems }

procedure TformListItems.ConfigureGrid;
begin
  inherited;
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

class function TformListItems.ShowList(const modeList: TModeList;
  var id: Integer): Boolean;
begin
  Application.CreateForm(TformListItems, formListItems);
  try
    formListItems.TitleForm:= 'Liste des produits';
    formListItems.current_modeList:= modeList;
    formListItems.qryList.Connection:= Donnees.connection;
    formListItems.qryList.SQL.Clear;
    formListItems.qryList.SQL.Add('SELECT i.id as id, i.label as label, i.pvht as pvht, t.value as vats, f.code as code');
    formListItems.qryList.SQL.Add('FROM items i, vats t, family f');
    formListItems.qryList.SQL.Add('WHERE i.idvat=t.id');
    formListItems.qryList.SQL.Add('AND   i.idfamily=f.id');
    Result := formListItems.ShowModal = mrOk;
    if Result and (modeList=mdSelection) then
      id:= formListItems.qryList.FieldByName('id').AsInteger;
  finally
    FreeAndNil(formListItems);
  end;
end;

end.
