unit Module;

interface

uses
  Windows, System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Dialogs, System.UITypes,
  System.TypInfo, System.Variants, cli.datas, System.DateUtils, Vcl.ExtCtrls, synCommons;



type
  TDonnees = class(TDataModule)
    connection: TADOConnection;
    tmgetToken: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure tmgetTokenTimer(Sender: TObject);
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
    procedure TruncateTable(const tableName: string);
    procedure FillVat(const aJSonString: RawJSON);
    procedure FillItem(const aJSonString: RawJSON);
    procedure FillFamilly(const aJSonString: RawJSON);
    procedure FillSupplier(const aJSonString: RawJSON);
    procedure FillCustomer(const aJSonString: RawJSON);
    procedure FillOrder(const aJSonString: RawJSON);
  public
    /// <summary>
    ///  cette méthode permet de récupérer les données serveur
    /// </summary>
    procedure FillDatas(const fct_update: byte = 63);
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
    /// <summary>
    ///  cette fonction permet de renvoyer le dernier id inséré en base pour une table donnée
    /// </summary>
    function getLastId(const tableName: string): integer;
  end;

var
  Donnees: TDonnees;

implementation

  uses consts_, logs, configuration, classebase, json.tools, Data.DBXJSON, intfmsvc,
       module.vat,
       module.supplier,
       module.items,
       module.family,
       module.orders,
       module.client;

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
    outputdebugstring(pchar('create a new database'));
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
  ConnectToServer(True);
  callback := TMessageService.Create(Client, IMessageService); // abonnement aux notifications
  Service.Join(myIdentify, callback); // on joint le serveur
  tmgetToken.Enabled:= True;

  if not InitDataBase then
    outputdebugstring(Pchar('une erreur est survenue lors de l''initialisation de la base de données'#13#10 +
               'veuillez vérifier les logs'));

  FormatSettings.DecimalSeparator:= varToStr(CheckValues(FormatSettings.DecimalSeparator, configfile.settingFormat.Values['DecimalSeparator']))[1];
  FormatSettings.ShortDateFormat := VarToStr(CheckValues(FormatSettings.ShortDateFormat, configfile.settingFormat.Values['ShortDateFormat']));
  FormatSettings.CurrencyString  := VarToStr(CheckValues(FormatSettings.CurrencyString , configfile.settingFormat.Values['CurrencyString']));
  FormatSettings.DateSeparator   := VarToStr(CheckValues(FormatSettings.DateSeparator, configfile.settingFormat.Values['DateSeparator']))[1];
  FormatSettings.TimeSeparator   := varToStr(CheckValues(FormatSettings.TimeSeparator, configfile.settingFormat.Values['TimeSeparator']))[1];
  outputdebugstring(pchar('end DataModuleCreate'));
end;

// ajoutée
procedure TDonnees.TruncateTable(const tableName: string);
begin
  with Donnees.addQuery do
  try
    SQL.Add('delete from ' + tableName);
    try
      ExecSQL;
    except
      on e: Exception do
        Logs.log.AddError('truncate table ' + tableName, e.Message);
    end;
  finally
    Free;
  end;
end;

procedure TDonnees.FillVat(const aJSonString: RawJSON);
var recordset  : TJSONArray;
    recordvalue: TJSONValue;
    mvat       : TModule_Vat;
    Vat        : TVat;
    Size       : integer;
    i          : Integer;
begin
  recordset :=  TJSONObject.ParseJSONValue(aJSonString) as TJSONArray;

//  with TStringList.Create do
//  try
//    Text:= JSONToXML(aJSonString);
//    SaveToFile(pathTemp + 'vat.xml');
//  finally
//    Free;
//  end;
  if recordset<>nil then
  begin
    TruncateTable('vats');
    Size:= RecordSet.Size;
    for i:= 0 to Pred(Size) do
    begin
      recordValue:= recordset.Get(i);
      vat:= JSonTovat(recordvalue.ToString);
      if Assigned(vat) then
      try
        mvat:= TModule_Vat.Create(Vat._id);
//        mvat.Read;
        mVat.Vat._id    := Vat._id;
        mvat.Vat._label := Vat._label;
        mvat.Vat._value := Vat._value;
        mVat.Write;
        FreeAndNil(mVat);
      finally
        FreeAndNil(vat);
      end;
    end;
  end;
end;

procedure TDonnees.FillFamilly(const aJSonString: RawJSON);
var recordset  : TJSONArray;
    recordvalue: TJSONValue;
    mFamily    : TModule_Family;
    Family     : TFamily;
    Size       : integer;
    i          : Integer;
begin
  recordset :=  TJSONObject.ParseJSONValue(aJSonString) as TJSONArray;
  if recordset<>nil then
  begin
    TruncateTable('Family');
    Size:= RecordSet.Size;
    for i:= 0 to Pred(Size) do
    begin
      recordValue:= recordset.Get(i);
      Family:= JSonToFamily(recordvalue.ToString);
      if Assigned(Family) then
      try
        mFamily:= TModule_Family.Create(Family._id);
//        mFamily.Read;
        mFamily.Family._id    := Family._id;
        mFamily.Family._label := Family._label;
        mFamily.Family._code  := Family._code;
        mFamily.Family._Description:= Family._Description;
        mFamily.Write;
        FreeAndNil(mFamily);
      finally
        FreeAndNil(Family);
      end;
    end;
  end;
end;


procedure TDonnees.FillItem(const aJSonString: RawJSON);
var recordset  : TJSONArray;
    recordvalue: TJSONValue;
    mitem      : TModule_Items;
    item       : TItems;
    Size       : integer;
    i          : Integer;
begin
  recordset :=  TJSONObject.ParseJSONValue(aJSonString) as TJSONArray;
  if recordset<>nil then
  begin
    TruncateTable('items');
    Size:= RecordSet.Size;
    for i:= 0 to Pred(Size) do
    begin
      recordValue:= recordset.Get(i);
      item:= JSonToItems(recordvalue.ToString);
      if Assigned(item) then
      try
        mitem:= TModule_Items.Create(item._id);
//        mitem.Read;
        mitem.Items._id         := item._id;
        mitem.items._label      := item._label;
        mitem.items._Code       := item._Code;
        mitem.Items._description:= item._description;
        mitem.Items._pvht       := item._pvht;
        mitem.Items._paht       := item._paht;
        mitem.Items._idvat      := item._idvat;
        mitem.Items._actif      := item._actif;
        mitem.Items._idfamily   := item._idfamily;
        mitem.Items._idSupplier := item._idSupplier;
        mitem.Write;
        FreeAndNil(mitem);
      finally
        FreeAndNil(item);
      end;
    end;
  end;
end;

procedure TDonnees.FillSupplier(const aJSonString: RawJSON);
var recordset  : TJSONArray;
    recordvalue: TJSONValue;
    mSupplier  : TModule_Suppliers;
    supplier   : TSupplier;
    Size       : integer;
    i          : Integer;
begin
  recordset :=  TJSONObject.ParseJSONValue(aJSonString) as TJSONArray;
  if recordset<>nil then
  begin
    TruncateTable('Suppliers');
    Size:= RecordSet.Size;
    for i:= 0 to Pred(Size) do
    begin
      recordValue:= recordset.Get(i);
      supplier:= JSonToSupplier(recordvalue.ToString);
      if Assigned(supplier) then
      try
        mSupplier:= TModule_Suppliers.Create(supplier._id);
//        mSupplier.Read;
        mSupplier.Supplier._id         := supplier._id;
        mSupplier.supplier._label      := supplier._label;
        mSupplier.supplier._description:= supplier._description;
        mSupplier.supplier._Address    := supplier._Address;
        mSupplier.supplier._supplement := supplier._supplement;
        mSupplier.supplier._City       := supplier._City;
        mSupplier.supplier._Country    := supplier._Country;
        mSupplier.supplier._Phone      := supplier._Phone;
        mSupplier.supplier._Mobile     := supplier._Mobile;
        mSupplier.supplier._Account    := supplier._Account;
        mSupplier.supplier._mail       := supplier._mail;
        mSupplier.Write;
        FreeAndNil(mSupplier);
      finally
        FreeAndNil(supplier);
      end;
    end;
  end;
end;

procedure TDonnees.FillCustomer(const aJSonString: RawJSON);
var recordset  : TJSONArray;
    recordvalue: TJSONValue;
    mClient    : TModule_Client;
    client     : TClient;
    Size       : integer;
    i          : Integer;
begin
  recordset :=  TJSONObject.ParseJSONValue(aJSonString) as TJSONArray;
  if recordset<>nil then
  begin
    TruncateTable('Clients');
    Size:= RecordSet.Size;
    for i:= 0 to Pred(Size) do
    begin
      recordValue:= recordset.Get(i);
      client:= JSonToClient(recordvalue.ToString);
      if Assigned(client) then
      try
        mClient:= TModule_Client.Create(client._id);
//        mClient.Read;
        mClient.client._id         := client._id;
        mClient.client._FirstName  := client._FirstName;
        mClient.client._LastName   := client._LastName;
        mClient.client._Address    := client._Address;
        mClient.client._supplement := client._supplement;
        mClient.client._City       := client._City;
        mClient.client._Country    := client._Country;
        mClient.client._Phone      := client._Phone;
        mClient.client._Mobile     := client._Mobile;
        mClient.client._Account    := client._Account;
        mClient.client._mail       := client._mail;
        mClient.Write;
        FreeAndNil(mClient);
      finally
        FreeAndNil(client);
      end;
    end;
  end;
end;

procedure TDonnees.FillOrder(const aJSonString: RawJSON);
var recordset   : TJSONArray;
    subrecordSet: TJSONArray;
    recordvalue : TJSONValue;
    subrecordVal: TJSONValue;
    mOrder      : TModule_orders;
    order       : TOrders;
    Size        : integer;
    SubSize     : Integer;
    i           : Integer;
    ii          : Integer;
begin
  recordset :=  TJSONObject.ParseJSONValue(aJSonString) as TJSONArray;
  if recordset<>nil then
  begin
    TruncateTable('Orders');
    TruncateTable('OrderLines');
    Size:= RecordSet.Size;
    for i:= 0 to Pred(Size) do
    begin
      recordValue:= recordset.Get(i);
      order:= JSonToOrders(recordvalue.ToString);
      if Assigned(order) then
      try
        mOrder:= TModule_orders.Create(order._id);
//        mOrder.Read;
        mOrder.Orders._id         := order._id;
        mOrder.orders._Code       := order._Code;
        mOrder.orders._idClient   := order._idClient;
        mOrder.orders._date       := order._date;
        mOrder.orders._stateOrder := order._stateOrder;
        mOrder.Orders.ClearLines;

        subrecordSet := (TJSONObject(recordValue).GetValue('_Lines')) as TJSONArray;
        SubSize:= subrecordSet.Size;
        for ii := 0 to Pred(SubSize) do
        begin
          subrecordVal:= subrecordSet.Get(ii);
          mOrder.Orders.AddLine(JSonToOrderLine(subrecordVal.ToString));
        end;
        mOrder.Write;

        FreeAndNil(mOrder);
      finally
        FreeAndNil(order);
      end;
    end;
  end;
end;

procedure TDonnees.FillDatas(const fct_update: byte = 63);
var aJSonString: RAWJSON;
begin
  if Assigned(Service) and (MyToken<>'') then
  begin
    if isByteOn(fct_update, 0) then
    begin
      // récupération des TVA
      aJSonString:= Service.getListVat(configfile.connection_server.appid, ParamToJSon(global_param));
      with JSonToResult(aJSonString) do
      try
        if State='ok' then
             FillVat(response)
        else log.AddError('recupération des tvas', response);
      finally
        Free;
      end;
    end;

    if isByteOn(fct_update, 1) then
    begin
      // récupération des items
      aJSonString:= Service.getListItems(configfile.connection_server.appid, ParamToJSon(global_param));
      with JSonToResult(aJSonString) do
      try
        if State='ok' then
             FillItem(Response)
        else log.AddError('recupération des produits', response);
      finally
        Free;
      end;
    end;

    if isByteOn(fct_update, 2) then
    begin
      // récupération des family
      aJSonString:= Service.getListFamily(configfile.connection_server.appid, ParamToJSon(global_param));
      with JSonToResult(aJSonString) do
      try
        if State='ok' then
             FillFamilly(Response)
        else log.AddError('recupération des Familles', response);
      finally
        Free;
      end;
    end;

    if isByteOn(fct_update, 3) then
    begin
      // récupération des suppliers
      aJSonString:= Service.getListSuppliers(configfile.connection_server.appid, ParamToJSon(global_param));
      with JSonToResult(aJSonString) do
      try
        if State='ok' then
             FillSupplier(Response)
        else log.AddError('recupération des Fournisseurs', response);
      finally
        Free;
      end;
    end;

    if isByteOn(fct_update, 4) then
    begin
      // récupération des clients
      aJSonString:= Service.getListCustomers(configfile.connection_server.appid, ParamToJSon(global_param));
      with JSonToResult(aJSonString) do
      try
        if State='ok' then
             FillCustomer(Response)
        else log.AddError('recupération des clients', response);
      finally
        Free;
      end;
    end;

    if isByteOn(fct_update, 5) then
    begin
      // récupération des orders
      aJSonString:= Service.getListOrders(configfile.connection_server.appid, ParamToJSon(global_param));
      with JSonToResult(aJSonString) do
      try
        if State='ok' then
             FillOrder(Response)
        else log.AddError('recupération des bons', response);
      finally
        Free;
      end;
    end;


  end;
end;

procedure TDonnees.DataModuleDestroy(Sender: TObject);
begin
  tmgetToken.Enabled:= False;
  ConnectToServer(False);
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

  procedure CreateVats;
  begin
    with qr do
    begin
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Vats" (');
      SQL.Add(' "id"      INTEGER PRIMARY KEY,');
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
      SQL.Add(' "id"            INTEGER PRIMARY KEY,');
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
      SQL.Add(' "id"            INTEGER PRIMARY KEY,');
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
      SQL.Add(' "id"            INTEGER PRIMARY KEY,');
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
      SQL.Add(' "id"            INTEGER PRIMARY KEY,');
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
      SQL.Add(' "id"            INTEGER PRIMARY KEY,');
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
      SQL.Add(' "id"            INTEGER PRIMARY KEY,');
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
  finally
    FreeAndNil(qr);
  end;
end;

function TDonnees.InitDataBase: Boolean;
begin
  result:= False;
  outputdebugstring(pchar('initialisation base de données'));
  filedatabasename:= configfile.connection.parameters.Values['filename'];// pathData + ChangeFileExt(ExtractFileName(ParamStr(0)), '.db');
  if not FileExists(filedatabasename) then
    CreateDataBase;

  connection.ConnectionString := configfile.connection.fillConnectionString;//StringReplace(CNX_SQLITE_STR, '[filename]', filedatabasename, [rfReplaceAll]);
  connection.LoginPrompt:= False;
  try
    outputdebugstring(PChar('tentative de connexion'));
    connection.Open();
    result:= connection.Connected;

    if result then
      CheckScriptDataBase;
  except
    on e: Exception do
      log.AddError('initdatabase', e.Message);
  end;
end;

procedure TDonnees.tmgetTokenTimer(Sender: TObject);
var response: TResultInformation;
    information: TJSonObject;
begin
  if HoursBetween(Now, LastToken)>1 then
  if Assigned(Service) then
  begin
    //Service.Join(configfile.connection_server.appid);
    response:= JSonToResult(Service.getToken(configfile.connection_server.appid));
    if Assigned(response) then
    begin
      if response.State = 'ok' then
      begin
        information:= TJSONObject.ParseJSONValue(response.response) as TJSonObject;
        if MyToken='' then
        begin
          myToken:= information.GetValue('information').Value;
          global_param.token:= MyToken;
          FillDatas;
        end
        else
        begin
          myToken:= information.GetValue('information').Value;
          global_param.token:= MyToken;
        end;
        LastToken:= now;
      end;
    end;
  end;
end;

end.
