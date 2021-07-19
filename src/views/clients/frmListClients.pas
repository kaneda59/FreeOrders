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
    class function ShowList(const modeList: TModeList; var id: Integer): Boolean;
  end;

var
  formListClients: TformListClients;

implementation

{$R *.dfm}
  uses Module;

{ TformListClients }

class function TformListClients.ShowList(const modeList: TModeList;
  var id: Integer): Boolean;
begin
  Application.CreateForm(TformListClients, formListClients);
  try
    formListClients.TitleForm:= 'Liste des clients';
    formListClients.current_modeList:= modeList;
    formListClients.qryList.Connection:= Donnees.connection;
    formListClients.qryList.SQL.Clear;
    formListClients.qryList.SQL.Add('SELECT * FROM Clients');
    Result := formListClients.ShowModal = mrOk;
    if Result and (modeList=mdSelection) then
      id:= formListClients.qryList.FieldByName('id').AsInteger;
  finally
    FreeAndNil(formListClients);
  end;
end;

end.
