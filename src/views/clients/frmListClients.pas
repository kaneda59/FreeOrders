unit frmListClients;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmListBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TformListClients = class(TFormBaseList)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ConfigureGrid; override;
    class function ShowList(const modeList: TModeList; var id: Integer): Boolean;
  end;

var
  formListClients: TformListClients;

implementation

{$R *.dfm}
  uses Module;

{ TformListClients }

procedure TformListClients.ConfigureGrid;
begin
  inherited;
  dbgrd.Columns[0].Visible:= False;
  dbgrd.Columns[1].Title.Caption:= 'Prénom';
  dbgrd.Columns[1].Width:= 200;
  dbgrd.Columns[2].Title.Caption:= 'Nom';
  dbgrd.Columns[2].Width:= 200;
  dbgrd.Columns[3].Title.Caption:= 'Adresse';
  dbgrd.Columns[3].Width:= 200;
  dbgrd.Columns[4].Title.Caption:= 'Code Postal';
  dbgrd.Columns[4].Width:= 100;
  dbgrd.Columns[5].Title.Caption:= 'Ville';
  dbgrd.Columns[5].Width:= 200;
end;

class function TformListClients.ShowList(const modeList: TModeList;
  var id: Integer): Boolean;
begin
  Application.CreateForm(TformListClients, formListClients);
  try
    formListClients.TitleForm:= 'Liste des clients';
    formListClients.current_modeList:= modeList;
    formListClients.qryList.Connection:= Donnees.connection;
    formListClients.qryList.SQL.Clear;
    formListClients.qryList.SQL.Add('SELECT id, FirstName, LastName, Address, ZipCode, City FROM Clients');
    Result := formListClients.ShowModal = mrOk;
    if Result and (modeList=mdSelection) then
      id:= formListClients.qryList.FieldByName('id').AsInteger;
  finally
    FreeAndNil(formListClients);
  end;
end;

end.
