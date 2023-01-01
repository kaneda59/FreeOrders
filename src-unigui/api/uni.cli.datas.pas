unit uni.cli.datas;

interface

uses
      {$I SynDprUses.inc}
      Classes,
      Forms,
      Messages,
      Windows,
      DB,
      Datasnap.DBClient,
      System.SysUtils,
      SynCommons,
      mORMot,
      mORMotHttpClient,
      classebase,
      intfmsvc;

const FCT_TVA       =  1;
      FCT_ITEM      =  2;
      FCT_FAMILY    =  4;
      FCT_SUPPLIER  =  8;
      FCT_CUSTOMER  = 16;
      FCT_ORDER     = 32;

const WM_NOTIFYEVENT = WM_USER + 1000;

type
      TonNotifyServiceEvent = procedure(objtype: string; const AppId, AJsonString: RawJSON) of object;

      TMessageService = class( TInterfacedCallback, IMessageCallBack)
      private
        fOnNotifyServiceEvent: TonNotifyServiceEvent;
      protected
        procedure NotifyVat(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyItems(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifySuppliers(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyFamily(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyCustomers(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyOrders(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyConfiguration(const AppID: RawUTF8; const ASonString: RawJSON);
      published
        property onNotifyEvent: TonNotifyServiceEvent read fOnNotifyServiceEvent write fonNotifyServiceEvent;
      end;

      TMicroService = class
      private
         fglobal_param: TParamInformation;
         fMyToken: string;
         fService: IMessageService;
         fMyIdentity: string;
         fCallBack: TMessageService;
         fLastToken: TDateTime;
         fClient: TSQLHttpClientWebsockets;
         fAppId: string;
      public
         constructor Create; reintroduce;
         destructor  Destroy; override;
         procedure ConnectToServer(const Connected: Boolean; const server: string = '127.0.0.1'; const remoteport: string = '0');
         function  getObject(const id: Integer; const objClass: TClass): TObject;
         function  setObject(const Obj: TObject; const objClass: TClass): Boolean;
         function  deleteObject(const id: integer; const objClass: TClass): Boolean;
         procedure sqlQuery(const query: string; var tbl: TClientDataSet);
         procedure listObject(const objClass: TClass; var tbl : TClientDataSet);
      published
         property AppId       : string                   read fAppId        write fAppId;
         property client      : TSQLHttpClientWebsockets read fClient       write fClient;
         property CallBack    : TMessageService          read fCallBack     write fCallBack;
         property Service     : IMessageService          read fService      write fService;
         property MyToken     : string                   read fMyToken      write fMyToken;
         property LastToken   : TDateTime                read fLastToken    write fLastToken;
         property myIdentify  : string                   read fMyIdentity   write fMyIdentity;
         property global_param: TParamInformation        read fglobal_param write fglobal_param;
      end;

      function FillTable(const AJSonString: RawJSON; tbl: TClientDataSet): Boolean;


implementation

  uses Data.DBXJSON,
       configuration, main, json.tools, Logs, MainModule;

function newGUID: string;
var GUID: TGUID;
begin
  CreateGUID(GUID);
  result := GUIDToString(GUID);
end;

function JSONObjectToDataRow(const AJson : TJSONObject; const AValue : TDataSet): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to AValue.FieldDefs.Count - 1 do
  begin
    try
      AValue.FieldByName(AValue.FieldDefs[I].Name).value := AJson.Get(AValue.FieldDefs[I].Name).JsonValue.Value;
    except
      try
      case AValue.FieldDefs[I].DataType of
        ftString, ftWideString, ftMemo :
          begin
            AValue.FieldByName(AValue.FieldDefs[I].Name).AsString :=
              AJson.Get(AValue.FieldDefs[I].Name).JsonValue.Value;
          end;
        ftSmallint, ftInteger, ftWord, ftLongWord, ftShortint :
          begin
            AValue.FieldByName(AValue.FieldDefs[I].Name).AsInteger :=
              (AJson.Get(AValue.FieldDefs[I].Name).JsonValue as TJsonNumber).AsInt;
          end;
        ftFloat, ftCurrency :
          begin
            AValue.FieldByName(AValue.FieldDefs[I].Name).AsFloat :=
              (AJson.Get(AValue.FieldDefs[I].Name).JsonValue as TJsonNumber).AsDouble;
          end;
        ftBoolean :
          begin
            AValue.FieldByName(AValue.FieldDefs[I].Name).AsBoolean :=
              StrToBool(AJson.Get(AValue.FieldDefs[I].Name).JsonValue.Value);
          end;
        ftDateTime :
          begin
            AValue.FieldByName(AValue.FieldDefs[i].Name).AsDateTime:= 0;
          end;
      end;
      except

      end;
    end;
  end;
end;

function FillTable(const AJSonString: RawJSON; tbl: TClientDataSet): Boolean;
var Jarray: TJSonArray;
    i: integer;
begin
  Jarray := TJSonObject.ParseJSONValue(AJSonString) as tjsonarray;
  for i := 0 to Jarray.Size - 1 do
  begin
    tbl.Append;
    JSONObjectToDataRow(TJSONObject.ParseJSONValue(Jarray.Get(i).ToString) as TJSONObject, tbl);
    tbl.Post;
  end;
  tbl.First;
end;

procedure TMicroService.sqlQuery(const query: string; var tbl: TClientDataSet);
var js: RawJSON;
    rs: TResultInformation;
    prm: TParamInformation;
begin
  js:= '';
  try
    MainModule.uniMainModule.tmgetTokenTimer(nil);
    prm := TParamInformation.Create;
    try
      prm.id:= 0;
      prm.token:= global_param.token;
      prm.information:= query;
      js:= Service.getSQL(fAppId, paramToJson(prm));
      rs:= JSonToResult(js);
      if rs.State='ok' then
      begin
        if FillTable(rs.response, tbl) then
          tbl.Open;
      end;
    finally
      FreeAndNil(prm);
    end;
  except
    on e: Exception do
      Log.AddError('getQuery ' + query, e.Message);
  end;
end;

procedure TMicroService.listObject(const objClass: TClass; var tbl : TClientDataSet);
var js: RawJSON;
    rs: TResultInformation;
begin
  js:= '';
  try
    MainModule.UniMainModule.tmgetTokenTimer(nil);
    if objClass = TVat then
      js:= Service.getListVat(fAppId, ParamToJSon(global_param))
    else
    if objClass = TClient then
       js:= Service.getListCustomers(fAppId, ParamToJSon(global_param))
    else
    if objClass = TSupplier then
       js:= Service.getListSuppliers(fAppId, ParamToJSon(global_param))
    else
    if objClass = TFamily then
       js:= Service.getListFamily(fAppId, ParamToJSon(global_param))
    else
    if objClass = TItems then
       js:= Service.getListItems(fAppId, ParamToJSon(global_param))
    else
    if objClass = TOrders then
       js:= Service.getListOrders(fAppId, ParamToJSon(global_param));

    rs:= JSonToResult(js);
    if rs.State='ok' then
    begin
      if FillTable(rs.response, tbl) then
        tbl.Open;
    end;
  except
    on e: Exception do
      Log.AddError('set ' + objClass.ClassName, e.Message);
  end;
end;

function TMicroService.setObject(const Obj: TObject; const objClass: TClass): Boolean;
begin
  result:= False;
  try
    MainModule.UniMainModule.tmgetTokenTimer(nil);
    if objClass = TVat then
      Service.setVat(fAppId, ParamToJSon(global_param), VatToJSon(TVat(obj)))
    else
    if objClass = TClient then
      Service.setCustomer(fAppId, ParamToJSon(global_param), ClientToJSon(TClient(obj)))
    else
    if objClass = TSupplier then
      Service.setSupplier(fAppId, ParamToJSon(global_param), SupplierToJSon(TSupplier(obj)))
    else
    if objClass = TFamily then
      Service.setFamily(fAppId, ParamToJSon(global_param), FamilyToJSon(TFamily(obj)))
    else
    if objClass = TItems then
      Service.setItem(fAppId, ParamToJSon(global_param), ItemsToJSon(TItems(obj)))
    else
    if objClass = TOrders then
      Service.setOrder(fAppId, ParamToJSon(global_param), OrdersToJSon(TOrders(obj)))
    else
    if objClass = TOrderLine then
      Service.setOrderLine(fAppId, ParamToJSon(global_param), OrderLineToJSon(TOrderLine(obj)));
    result:= True;
  except
    on e: Exception do
      Log.AddError('set ' + objClass.ClassName, e.Message);
  end;
end;

function TMicroService.getObject(const id: Integer; const objClass: TClass): TObject;
var res: TResultInformation;
begin
  result:= nil;
  if Assigned(Service) then
  begin
    MainModule.UniMainModule.tmgetTokenTimer(nil);
    global_param.id:= id;
    if objClass = TVat then
    begin
      res:= JSonToResult(Service.getvat(fAppId, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToVat(res.response);
    end;
    if objClass = TClient then
    begin
      res:= JSonToResult(Service.getCustomer(fAppId, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToClient(res.response);
    end;
    if objClass = TFamily then
    begin
      res:= JSonToResult(Service.getFamily(fAppId, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToFamily(res.response);
    end;
    if objClass = TSupplier then
    begin
      res:= JSonToResult(Service.getSupplier(fAppId, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToSupplier(res.response);
    end;
    if objClass = TItems then
    begin
      res:= JSonToResult(Service.getItem(fAppId, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToItems(res.response);
    end;
    if objClass = TOrders then
    begin
      res:= JSonToResult(Service.getOrder(fAppId, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToOrders(res.response);
    end;
  end;
end;


constructor TMicroService.Create;
begin
  inherited;
  global_param:= TParamInformation.Create;
  fLastToken  := 0;
  fMyIdentity := newGUID;
  fAppId      := 'FBA76CA3-6438-4CDD-BB51-344C27B0CD69';
end;

function  TMicroService.deleteObject(const id: integer; const objClass: TClass): Boolean;
var res: TResultInformation;
begin
  result:= False;
  if Assigned(Service) then
  begin
    MainModule.UniMainModule.tmgetTokenTimer(nil);
    global_param.id:= id;
    if objClass = TVat then
      res:= JSonToResult(Service.deleteVat(fAppId, ParamToJSon(global_param)))
    else
    if objClass = TClient then
      res:= JSonToResult(Service.deleteCustomer(fAppId, ParamToJSon(global_param)))
    else
    if objClass = TFamily then
      res:= JSonToResult(Service.deleteFamily(fAppId, ParamToJSon(global_param)))
    else
    if objClass = TSupplier then
      res:= JSonToResult(Service.deleteSupplier(fAppId, ParamToJSon(global_param)))
    else
    if objClass = TItems then
      res:= JSonToResult(Service.deleteItem(fAppId, ParamToJSon(global_param)))
    else
    if objClass = TOrders then
      res:= JSonToResult(Service.deleteOrder(fAppId, ParamToJSon(global_param)))
    else
    if objClass = TOrderLine then
      res:= JSonToResult(Service.deleteOrderLine(fAppId, ParamToJSon(global_param)));
    result:= res.State='ok';
    if not result then
      Log.AddError('delete object ' + objClass.ClassName, res.response);
  end;
end;

destructor TMicroService.Destroy;
begin
  FreeAndNil(fglobal_param);
  inherited;
end;

procedure TMicroService.ConnectToServer(const Connected: Boolean; const server: string = '127.0.0.1'; const remoteport: string = '0');
begin
  if Connected then
  begin
    if remoteport<>'0' then
         client:= TSQLHttpClientWebsockets.Create(server, remoteport, TSQLModel.Create([]))
    else client:= TSQLHttpClientWebsockets.Create(server, REMOTE_PORT, TSQLModel.Create([]));
    client.Model.Owner:= client;
    client.WebSocketsUpgrade(TRANSMISSION);
    if not Client.ServerTimeStampSynchronize then  // vérifie qu'on est bien synchro avec le serveur
    begin
      outputdebugstring(Pchar('connectServer ' + UTF8ToString(Client.LastErrorMessage)));
      //FreeAndNil(Client);
      exit;
    end;
    client.ServiceDefine([IMessageService], sicShared);
    if not client.Services.Resolve(IMessageService, fService) then
      raise EServiceException.Create('erreur service non disponible');
  end
  else
  begin
    Service:= nil;
    FreeAndNil(fCallBack);
    FreeAndNil(fClient);
  end;
end;

{ TMessageService }
procedure TMessageService.NotifyConfiguration(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  if Assigned(fOnNotifyServiceEvent) then
    fOnNotifyServiceEvent('configuration', AppID, ASonString);
end;

procedure TMessageService.NotifyCustomers(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  if Assigned(fOnNotifyServiceEvent) then
    fOnNotifyServiceEvent('customers', AppID, ASonString);
end;

procedure TMessageService.NotifyFamily(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  if Assigned(fOnNotifyServiceEvent) then
    fOnNotifyServiceEvent('family', AppID, ASonString);
end;

procedure TMessageService.NotifyItems(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  if Assigned(fOnNotifyServiceEvent) then
    fOnNotifyServiceEvent('items', AppID, ASonString);
end;

procedure TMessageService.NotifyOrders(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  if Assigned(fOnNotifyServiceEvent) then
    fOnNotifyServiceEvent('orders', AppID, ASonString);
end;

procedure TMessageService.NotifySuppliers(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  if Assigned(fOnNotifyServiceEvent) then
    fOnNotifyServiceEvent('suppliers', AppID, ASonString);
end;

procedure TMessageService.NotifyVat(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  if Assigned(fOnNotifyServiceEvent) then
    fOnNotifyServiceEvent('vat', AppID, ASonString);
end;

end.
