unit frmListSuppliers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmListBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformListSuppliers = class(TFormBaseList)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ConfigureGrid; override;
    class function ShowList(const modeList: TModeList; var id: Integer): Boolean;
  end;

var
  formListSuppliers: TformListSuppliers;

implementation

{$R *.dfm}
  uses Module, Logs, consts_;

{ TFormBaseList1 }

procedure TformListSuppliers.ConfigureGrid;
begin
  inherited;
  dbgrd.Columns[0].Visible:= False;
  dbgrd.Columns[1].Title.Caption:= 'Nom';
  dbgrd.Columns[1].Width:= 400;
  dbgrd.Columns[2].Title.Caption:= 'Adresse';
  dbgrd.Columns[2].Width:= 200;
  dbgrd.Columns[3].Title.Caption:= 'Code Postal';
  dbgrd.Columns[3].Width:= 100;
  dbgrd.Columns[4].Title.Caption:= 'Ville';
  dbgrd.Columns[4].Width:= 200;
end;

class function TformListSuppliers.ShowList(const modeList: TModeList;
  var id: Integer): Boolean;
begin
  Application.CreateForm(TformListSuppliers, formListSuppliers);
  try
    formListSuppliers.TitleForm:= 'Liste des fournisseurs';
    formListSuppliers.current_modeList:= modeList;
    formListSuppliers.qryList.Connection:= Donnees.connection;
    formListSuppliers.qryList.SQL.Clear;
    formListSuppliers.qryList.SQL.Add('SELECT id, Label, Address, ZipCode, City FROM Suppliers');
    Result := formListSuppliers.ShowModal = mrOk;
    if Result and (modeList=mdSelection) then
      id:= formListSuppliers.qryList.FieldByName('id').AsInteger;
  finally
    FreeAndNil(formListSuppliers);
  end;
end;

end.
