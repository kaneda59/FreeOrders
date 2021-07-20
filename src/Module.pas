unit Module;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Dialogs, System.UITypes;



type
  TDonnees = class(TDataModule)
    connection: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
    filedatabasename: string;
    /// <summary>
    ///  cette fonction permet créer la base de données a vide si elle n'existe pas
    /// </summary>
    procedure CreateDataBase;
    /// <summary>
    ///  cette fonction permet créer les tables
    /// </summary>
    procedure CheckScriptDataBase;
  public
    { Déclarations publiques }
    /// <summary>
    ///  cette fonction permet d'instancier une requête directement reliée à la base de données du projet
    /// </summary>
    function addQuery: TADOQuery;
    /// <summary>
    ///  cette fonction permet d'initialiser la base de données, vérifier la maj de cette dernière et
    ///  s'y connecter
    /// </summary>
    function InitDataBase: Boolean;
  end;

var
  Donnees: TDonnees;

implementation

  uses consts_, logs;

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


procedure TDonnees.DataModuleCreate(Sender: TObject);
begin
  if not InitDataBase then
    MessageDLG('une erreur est survenue lors de l''initialisation de la base de données'#13#10 +
               'veuillez vérifier les logs',  mtError, [mbOK], 0);
end;

procedure TDonnees.CheckScriptDataBase;
var qr: TADOQuery;

  procedure CreateVats;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Vats" (');
      SQL.Add(' "id"      INTEGER PRIMARY KEY AUTOINCREMENT,');
      SQL.Add(' "Label"   VARCHAR(125),');
      SQL.Add(' "Value"   REAL');
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
      SQL.Add(' "pvht"          REAL,');
      SQL.Add(' "paht"          REAL,');
      SQL.Add(' "pfht"          REAL,');
      SQL.Add(' "idvat"         INTEGER,');
      SQL.Add(' "actif"         VARCHAR(125),');
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
      SQL.Add(' "idItems"       INTEGER,');
      SQL.Add(' "Qte"           REAL,');
      SQL.Add(' "MtRem"         REAL');
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
  finally
    FreeAndNil(qr);
  end;
end;

function TDonnees.InitDataBase: Boolean;
begin
  result:= False;
  filedatabasename:= pathData + ChangeFileExt(ExtractFileName(ParamStr(0)), '.db');
  if not FileExists(filedatabasename) then
    CreateDataBase;

  connection.ConnectionString := StringReplace(CNX_SQLITE_STR, '[filename]', filedatabasename, [rfReplaceAll]);
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
