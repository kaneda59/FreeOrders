unit frmListVats;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmListBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormListVats = class(TFormBaseList)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ConfigureGrid; override;
    procedure ExecuteAction(const id: Integer); override;
    class function ShowList(const modeList: TModeList; var id: Integer): Boolean;
  end;

var
  FormListVats: TFormListVats;

implementation

{$R *.dfm}

  uses Module, Logs, consts_, frmInputVat;

{ TFormListVats }

procedure TFormListVats.ConfigureGrid;
begin
  inherited;

end;

procedure TFormListVats.ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : if TformInputVat.Execute(0) then UpdateData;
     200 : if TformInputVat.Execute(qryList.FieldByName('id').AsInteger) then UpdateData;
     300 : if messageDLG('voulez-vous supprimer ce taux de TVA ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
             qryList.Delete;
  end;
end;

class function TFormListVats.ShowList(const modeList: TModeList;
  var id: Integer): Boolean;
begin
  Application.CreateForm(TFormListVats, FormListVats);
  try
    FormListVats.TitleForm:= 'Taux de TVA';
    FormListVats.current_modeList:= modeList;
    FormListVats.qryList.Connection:= Donnees.connection;
    FormListVats.qryList.SQL.Clear;
    FormListVats.qryList.SQL.Add('SELECT id, Label, value FROM Vats');
    Result := FormListVats.ShowModal = mrOk;
    if Result and (modeList=mdSelection) then
      id:= FormListVats.qryList.FieldByName('id').AsInteger;
  finally
    FreeAndNil(FormListVats);
  end;
end;

end.
