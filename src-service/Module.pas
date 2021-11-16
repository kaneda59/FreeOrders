unit Module;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Dialogs, System.UITypes,
  System.TypInfo, System.Variants;



type
  TDonnees = class(TDataModule)
    connection: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { D�clarations priv�es }
    filedatabasename: string;
    /// <summary>
    ///  cette fonction permet cr�er la base de donn�es a vide si elle n'existe pas
    /// </summary>
    procedure CreateDataBase;
    /// <summary>
    ///  cette fonction permet cr�er les tables
    /// </summary>
    procedure CheckScriptDataBase;
  public
    { D�clarations publiques }
    /// <summary>
    ///  cette fonction permet d'instancier une requ�te directement reli�e � la base de donn�es du projet
    /// </summary>
    function addQuery: TADOQuery;
    /// <summary>
    ///  cette fonction permet d'initialiser la base de donn�es, v�rifier la maj de cette derni�re et
    ///  s'y connecter
    /// </summary>
    function InitDataBase: Boolean;
    /// <summary>
    ///  cette fonction permet de renvoyer le dernier id ins�r� en base pour une table donn�e
    /// </summary>
    function getLastId(const tableName: string): integer;
  end;

var
  Donnees: TDonnees;

implementation

  uses consts_, logs, configuration;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDonnees }

function TDonnees.addQuery: TADOQuery;
begin
  result:= TADOQuery.Create(nil);
  result.Connection:= Connection;
  Result.SQL.Clear;
end;

procedure TDonnees.CreateDataBase;
begin
  with TStringList.create do
  try
    SaveToFile(filedatabasename);
  finally
    Free;
  end;
end;

function CheckValues(const default: Variant; value: Variant): variant;
begin
  result:= default;
  if not varIsNull(value) then
  if varToStr(value)<>'' then
    result:= value;
end;


procedure TDonnees.DataModuleCreate(Sender: TObject);
begin
  if not InitDataBase then
    MessageDLG('une erreur est survenue lors de l''initialisation de la base de donn�es'#13#10 +
               'veuillez v�rifier les logs',  mtError, [mbOK], 0);

  FormatSettings.DecimalSeparator:= varToStr(CheckValues(FormatSettings.DecimalSeparator, configfile.settingFormat.Values['DecimalSeparator']))[1];
  FormatSettings.ShortDateFormat := VarToStr(CheckValues(FormatSettings.ShortDateFormat, configfile.settingFormat.Values['ShortDateFormat']));
  FormatSettings.CurrencyString  := VarToStr(CheckValues(FormatSettings.CurrencyString , configfile.settingFormat.Values['CurrencyString']));
  FormatSettings.DateSeparator   := VarToStr(CheckValues(FormatSettings.DateSeparator, configfile.settingFormat.Values['DateSeparator']))[1];
  FormatSettings.TimeSeparator   := varToStr(CheckValues(FormatSettings.TimeSeparator, configfile.settingFormat.Values['TimeSeparator']))[1];
end;

function TDonnees.getLastId(const tableName: string): integer;
begin
  with addQuery do
  try
    SQL.Add('SELECT MAX(id) as id FROM ' + tableName);
    Open;
    Result:= FieldByName('id').AsInteger;
    Close;
  finally
    Free;
  end;
end;

procedure TDonnees.CheckScriptDataBase;
var qr: TADOQuery;

  procedure CreateApplications;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "applications" (');
      SQL.Add('  "id"     INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add('  "appID"  VARCHAR(125),');
      SQL.Add('  "description" VARCHAR(125)');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
          log.AddError('create table applications', e.message);
      end;
    end;
  end;

  procedure CreateTokens;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "tokens" (');
      SQL.Add('  "id"          INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add('  "appID"       VARCHAR(125),');
      SQL.Add('  "token"       VARCHAR(125),');
      SQL.Add('  "date_create" DATETIME');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
          log.AddError('create table tokens', e.message);
      end;
    end;
  end;

  procedure CreateVats;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Vats" (');
      SQL.Add(' "id"      INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add(' "Label"   VARCHAR(125),');
      SQL.Add(' "Value"   DOUBLE');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
          log.AddError('create table vats', e.message);
      end;
    end;
  end;

  procedure CreateSuppliers;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Suppliers" (');
      SQL.Add(' "id"            INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add(' "Label"         VARCHAR(125),');
      SQL.Add(' "Description"   VARCHAR(125),');
      SQL.Add(' "Address"       VARCHAR(125),');
      SQL.Add(' "supplement"    VARCHAR(125),');
      SQL.Add(' "ZipCode"       VARCHAR(20),');
      SQL.Add(' "City"          VARCHAR(125),');
      SQL.Add(' "Country"       VARCHAR(125),');
      SQL.Add(' "Phone"         VARCHAR(20),');
      SQL.Add(' "Mobile"        VARCHAR(20),');
      SQL.Add(' "Account"       VARCHAR(20),');
      SQL.Add(' "mail"          VARCHAR(125)');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
           log.AddError('create table suppliers', e.message);
      end;
    end;
  end;

  procedure CreateFamily;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Family" (');
      SQL.Add(' "id"            INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add(' "Label"         VARCHAR(125),');
      SQL.Add(' "Code"          VARCHAR(20),');
      SQL.Add(' "Description"   VARCHAR(125)');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
           log.AddError('create table family', e.message);
      end;
    end;
  end;

  procedure CreateItems;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Items" (');
      SQL.Add(' "id"            INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add(' "Label"         VARCHAR(125),');
      SQL.Add(' "Description"   VARCHAR(125),');
      SQL.Add(' "pvht"          DOUBLE,');
      SQL.Add(' "paht"          DOUBLE,');
      SQL.Add(' "Code"          VARCHAR(20),');
      SQL.Add(' "idvat"         INTEGER,');
      SQL.Add(' "actif"         BOOLEAN,');
      SQL.Add(' "idfamily"      VARCHAR(20),');
      SQL.Add(' "idSupplier"    VARCHAR(20)');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
           log.AddError('create table items', e.message);
      end;
    end;
  end;

  procedure CreateClients;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Clients" (');
      SQL.Add(' "id"            INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add(' "FirstName"     VARCHAR(125),');
      SQL.Add(' "LastName"      VARCHAR(125),');
      SQL.Add(' "Address"       VARCHAR(125),');
      SQL.Add(' "supplement"    VARCHAR(125),');
      SQL.Add(' "ZipCode"       VARCHAR(20),');
      SQL.Add(' "City"          VARCHAR(125),');
      SQL.Add(' "Country"       VARCHAR(125),');
      SQL.Add(' "Phone"         VARCHAR(20),');
      SQL.Add(' "Mobile"        VARCHAR(20),');
      SQL.Add(' "Account"       VARCHAR(20),');
      SQL.Add(' "mail"          VARCHAR(125)');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
           log.AddError('create table clients', e.message);
      end;
    end;
  end;

  procedure CreateOrderLines;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "OrderLines" (');
      SQL.Add(' "id"            INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add(' "orderid"       INTEGER,');
      SQL.Add(' "idItems"       INTEGER,');
      SQL.Add(' "Qte"           DOUBLE,');
      SQL.Add(' "MtRem"         DOUBLE');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
           log.AddError('create table orderlines', e.message);
      end;
    end;
  end;

  procedure CreateOrders;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Orders" (');
      SQL.Add(' "id"            INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add(' "Code"          VARCHAR(20),');
      SQL.Add(' "idClient"      INTEGER,');
      SQL.Add(' "date"          DATETIME,');
      SQL.Add(' "stateOrder"    INTEGER');
      SQL.Add(')');
      try
        ExecSQL;
      except
        on e: Exception do
           log.AddError('create table orders', e.message);
      end;
    end;
  end;

begin
  qr:= addQuery;
  try
    CreateVats;
    CreateSuppliers;
    CreateFamily;
    CreateItems;
    CreateClients;
    CreateOrderLines;
    CreateOrders;
    //// webservices
    CreateApplications;
    CreateTokens;
  finally
    FreeAndNil(qr);
  end;
end;

function TDonnees.InitDataBase: Boolean;
begin
  result:= False;
  filedatabasename:= configfile.connection.parameters.Values['filename'];// pathData + ChangeFileExt(ExtractFileName(ParamStr(0)), '.db');
  if not FileExists(filedatabasename) then
    CreateDataBase;

  connection.ConnectionString := configfile.connection.fillConnectionString;//StringReplace(CNX_SQLITE_STR, '[filename]', filedatabasename, [rfReplaceAll]);
  connection.LoginPrompt:= False;
  try
    connection.Open();
    result:= connection.Connected;

    if result then
      CheckScriptDataBase;
  except
    on e: Exception do
      log.AddError('initdatabase', e.Message);
  end;
end;

end.
