unit frmListVats;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmListBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls, System.UITypes;

type
  TFormListVats = class(TFormBaseList)
    procedure fltfldListtauxGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure ConfigureGrid; override;
    procedure _ExecuteAction(const id: Integer); override;
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
  dbgrd.Columns[0].Visible:= False;
  dbgrd.Columns[1].Title.Caption:= 'Libellé';
  dbgrd.Columns[1].Width:= 200;
  dbgrd.Columns[2].Title.Caption:= 'Taux';
  dbgrd.Columns[2].Width:= 100;
  qryList.FieldByName('value').OnGetText:= fltfldListtauxGetText;
end;

procedure TFormListVats._ExecuteAction(const id: Integer);
begin
  inherited;
  case id of
     100 : if TformInputVat.Execute(0) then UpdateData;
     200 : if TformInputVat.Execute(qryList.FieldByName('id').AsInteger) then UpdateData;
     300 : if messageDLG('voulez-vous supprimer ce taux de TVA ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
             qryList.Delete;
  end;
end;

procedure TFormListVats.fltfldListtauxGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  inherited;
  if qryList.RecordCount>0 then
    Text:= FormatFloat('0.00 %', Sender.Value);
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
