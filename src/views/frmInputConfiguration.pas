unit frmInputConfiguration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmBaseInput, Vcl.StdCtrls, Data.Win.ADODB,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids;

type
  TformInputConfiguration = class(TformBaseInput)
    pgConfig: TPageControl;
    tsConnection: TTabSheet;
    tsFormatSettings: TTabSheet;
    grpDatabase: TGroupBox;
    edtFileDataBaseName: TEdit;
    btnSelectFile: TButton;
    btnTest: TButton;
    grpTools: TGroupBox;
    btnExport: TButton;
    btnImport: TButton;
    grid: TStringGrid;
    procedure btnSelectFileClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure edtFileDataBaseNameChange(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure ReadScreen;
    procedure WriteScreen;
  public
    { Déclarations publiques }
    class function Execute: Boolean;
  end;

var
  formInputConfiguration: TformInputConfiguration;

implementation

{$R *.dfm}
  uses Logs, consts_, configuration, Module;

{ TformInputConfiguration }

procedure TformInputConfiguration.btnExportClick(Sender: TObject);
begin
  inherited;
  if MessageDlg('voulez-vous exporter la base de données ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  with TSaveDialog.Create(nil) do
  try
    Title:= 'choisir l''emplacement de la sauvegarde';
    Filter:= 'fichier base de données (*.db; *.sqlite)|*.db;*.sqlite|Tous fichiers (*.*)|*.*';
    InitialDir:= '';
    DefaultExt:= ExtractFileExt(configfile.connection.parameters.Values['filename']);
    Filename:= ExtractFileName(ChangeFileExt(configfile.connection.parameters.Values['filename'], FormatDateTime('.ddmmyyyy', Date)));
    if Execute then
      CopyFile(Pchar(configfile.connection.parameters.Values['filename']), Pchar(filename), True);
  finally
    Free;
  end;
end;

procedure TformInputConfiguration.btnImportClick(Sender: TObject);
begin
  inherited;
  if MessageDlg('voulez-vous importer une base de données ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  with TOpenDialog.Create(nil) do
  try
    Title:= 'choisir l''emplacement de la sauvegarde';
    Filter:= 'fichier base de données (*.db; *.sqlite)|*.db;*.sqlite|Tous fichiers (*.*)|*.*';
    InitialDir:= '';
    DefaultExt:= ExtractFileExt(configfile.connection.parameters.Values['filename']);
    Filename:= ExtractFileName(ChangeFileExt(configfile.connection.parameters.Values['filename'], FormatDateTime('.ddmmyyyy', Date)));
    if Execute then
    begin
      if fileExists(configfile.connection.parameters.Values['filename']) then
        CopyFile(Pchar(configfile.connection.parameters.Values['filename']), Pchar(ChangeFileExt(configfile.connection.parameters.Values['filename'], '.old')), True);
      CopyFile(Pchar(filename), Pchar(configfile.connection.parameters.Values['filename']), True);
      Module.Donnees.connection.Close;
      try
        Module.Donnees.connection.ConnectionString:= configfile.connection.fillConnectionString;
        Module.Donnees.connection.Open;
        if Module.Donnees.connection.Connected then
           MessageDlg('La base de données est restaurée', mtInformation, [mbOk], 0);
      except
        on e: Exception do
        begin
          MessageDlg('impossible de se connecter a cette base de données, la précédente db sera restaurée : ' + e.Message, mtError, [mbOk], 0);
          CopyFile(Pchar(configfile.connection.parameters.Values['filename']), Pchar(ChangeFileExt(configfile.connection.parameters.Values['filename'], '.err')), True);
          CopyFile(Pchar(ChangeFileExt(configfile.connection.parameters.Values['filename'], '.old')), Pchar(configfile.connection.parameters.Values['filename']), True);
        end;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TformInputConfiguration.btnSelectFileClick(Sender: TObject);
begin
  inherited;
  with TOpenDialog.Create(nil) do
  try
    Title:= 'Choisir un fichier de base de données';
    Filter:= 'fichier sqlite (*.db;*.sqlite|*.db;*.sqlite|Tous fichiers (*.*)|*.*';
    InitialDir:= ExtractFilePath(configfile.connection.parameters.Values['filename']);
    DefaultExt:= ExtractFileExt(configfile.connection.parameters.Values['filename']);
    Filename:= ExtractFileName(configfile.connection.parameters.Values['filename']);
    if Execute then
      edtFileDataBaseName.Text:= FileName;
  finally
    Free;
  end;
end;

procedure TformInputConfiguration.btnTestClick(Sender: TObject);
begin
  inherited;
  with TADOConnection.Create(nil) do
  try
    LoginPrompt:= False;
    ConnectionString:= StringReplace(configfile.connection.connectionstring, '[filename]', edtFileDataBaseName.Text, [rfReplaceAll]);
    try
      open;
      if Connected then MessageDlg('connexion à la base réussie', TMsgDlgType.mtInformation, [mbOk], 0)
                   else MessageDlg('connexion à la base impossible : ' + SysErrorMessage(getLastError), TMsgDlgType.mtWarning, [mbOk], 0)
    except
      on e: Exception do
        MessageDlg('connexion à la base de données impossible : ' + e.Message, TMsgDlgType.mtError, [mbOk], 0);
    end;
  finally
    Free;
  end;
end;

procedure TformInputConfiguration.edtFileDataBaseNameChange(Sender: TObject);
begin
  inherited;
  btnTest.Enabled:= FileExists(edtFileDataBaseName.Text);
end;

class function TformInputConfiguration.Execute: Boolean;
begin
  Application.CreateForm(TformInputConfiguration, formInputConfiguration);
  try
    formInputConfiguration.WriteScreen;
    result:= formInputConfiguration.ShowModal = mrOk;
    if result then
      formInputConfiguration.ReadScreen;
  finally
    FreeAndNil(formInputConfiguration);
  end;
end;

procedure TformInputConfiguration.ReadScreen;
var i: Integer;
begin
  configfile.connection.parameters.Values['filename']:= edtFileDataBaseName.Text;
  for i := 1 to grid.RowCount do
    configfile.settingFormat.Values[grid.Cells[0, i]]:= grid.Cells[1,i];
end;

procedure TformInputConfiguration.WriteScreen;
var i: integer;
begin
  edtFileDataBaseName.Text:= configfile.connection.parameters.Values['filename'];
  grid.Cells[0,0]:= 'paramètre';
  grid.Cells[1,0]:= 'valeur';
  grid.RowCount:= configfile.settingFormat.Count + 1;
  for i := 0 to configfile.settingFormat.Count-1 do
  begin
    grid.Cells[0,i+1]:= configfile.settingFormat.Names[i];
    grid.Cells[1,i+1]:= configfile.settingFormat.Values[configfile.settingFormat.Names[i]];
  end;
end;

end.
