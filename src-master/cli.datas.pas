unit cli.datas;

interface

uses
      {$I SynDprUses.inc}
      Classes,
      Forms,
      Messages,
      Windows,
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
      TMessageService = class( TInterfacedCallback, IMessageCallBack)
      protected
        procedure NotifyVat(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyItems(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifySuppliers(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyFamily(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyCustomers(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyOrders(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyConfiguration(const AppID: RawUTF8; const ASonString: RawJSON);
      end;

procedure ConnectToServer(const Connected: Boolean);
function  getObject(const id: Integer; const objClass: TClass): TObject;
function  setObject(const Obj: TObject; const objClass: TClass): Boolean;
function  deleteObject(const id: integer; const objClass: TClass): Boolean;

{ simplifions le processus en créant des fonctions d'appel et de réponses qui contiennent déjà les paramètres
  que l'on souhaites et les réponses attendues }

var client: TSQLHttpClientWebsockets;
    CallBack: TMessageService;
    Service: IMessageService; // pour joindre le serveuir (join, et envoyer des messages);
    MyToken: string = '';
    LastToken: TDateTime = 0;
    myIdentify: string = '';
    global_param: TParamInformation = nil;

implementation

  uses configuration, Module, main, json.tools, Logs;



function setObject(const Obj: TObject; const objClass: TClass): Boolean;
begin
  result:= False;
  try
    if objClass = TVat then
      Service.setVat(configfile.connection_server.appid, ParamToJSon(global_param), VatToJSon(TVat(obj)))
    else
    if objClass = TClient then
      Service.setCustomer(configfile.connection_server.appid, ParamToJSon(global_param), ClientToJSon(TClient(obj)))
    else
    if objClass = TSupplier then
      Service.setSupplier(configfile.connection_server.appid, ParamToJSon(global_param), SupplierToJSon(TSupplier(obj)))
    else
    if objClass = TFamily then
      Service.setFamily(configfile.connection_server.appid, ParamToJSon(global_param), FamilyToJSon(TFamily(obj)))
    else
    if objClass = TItems then
      Service.setItem(configfile.connection_server.appid, ParamToJSon(global_param), ItemsToJSon(TItems(obj)))
    else
    if objClass = TOrders then
      Service.setOrder(configfile.connection_server.appid, ParamToJSon(global_param), OrdersToJSon(TOrders(obj)))
    else
    if objClass = TOrderLine then
      Service.setOrderLine(configfile.connection_server.appid, ParamToJSon(global_param), OrderLineToJSon(TOrderLine(obj)));
    result:= True;
  except
    on e: Exception do
      Log.AddError('set ' + objClass.ClassName, e.Message);
  end;
end;

function getObject(const id: Integer; const objClass: TClass): TObject;
var res: TResultInformation;
begin
  result:= nil;
  if Assigned(Service) then
  begin
    global_param.id:= id;
    if objClass = TVat then
    begin
      res:= JSonToResult(Service.getvat(configfile.connection_server.appid, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToVat(res.response);
    end;
    if objClass = TClient then
    begin
      res:= JSonToResult(Service.getCustomer(configfile.connection_server.appid, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToClient(res.response);
    end;
    if objClass = TFamily then
    begin
      res:= JSonToResult(Service.getFamily(configfile.connection_server.appid, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToFamily(res.response);
    end;
    if objClass = TSupplier then
    begin
      res:= JSonToResult(Service.getSupplier(configfile.connection_server.appid, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToSupplier(res.response);
    end;
    if objClass = TItems then
    begin
      res:= JSonToResult(Service.getItem(configfile.connection_server.appid, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToItems(res.response);
    end;
    if objClass = TOrders then
    begin
      res:= JSonToResult(Service.getOrder(configfile.connection_server.appid, ParamToJSon(global_param)));
      if res.State='ok' then
        result:= JSonToOrders(res.response);
    end;
  end;
end;

function  deleteObject(const id: integer; const objClass: TClass): Boolean;
var res: TResultInformation;
begin
  result:= False;
  if Assigned(Service) then
  begin
    global_param.id:= id;
    if objClass = TVat then
      res:= JSonToResult(Service.deleteVat(configfile.connection_server.appid, ParamToJSon(global_param)))
    else
    if objClass = TClient then
      res:= JSonToResult(Service.deleteCustomer(configfile.connection_server.appid, ParamToJSon(global_param)))
    else
    if objClass = TFamily then
      res:= JSonToResult(Service.deleteFamily(configfile.connection_server.appid, ParamToJSon(global_param)))
    else
    if objClass = TSupplier then
      res:= JSonToResult(Service.deleteSupplier(configfile.connection_server.appid, ParamToJSon(global_param)))
    else
    if objClass = TItems then
      res:= JSonToResult(Service.deleteItem(configfile.connection_server.appid, ParamToJSon(global_param)))
    else
    if objClass = TOrders then
      res:= JSonToResult(Service.deleteOrder(configfile.connection_server.appid, ParamToJSon(global_param)))
    else
    if objClass = TOrderLine then
      res:= JSonToResult(Service.deleteOrderLine(configfile.connection_server.appid, ParamToJSon(global_param)));
    result:= res.State='ok';
    if not result then
      Log.AddError('delete object ' + objClass.ClassName, res.response);
  end;
end;

procedure ConnectToServer(const Connected: Boolean);
begin
  if Connected then
  begin
    Client:= TSQLHttpClientWebsockets.Create('127.0.0.1', REMOTE_PORT, TSQLModel.Create([]));
    client.Model.Owner:= client;
    client.WebSocketsUpgrade(TRANSMISSION);
    if not Client.ServerTimeStampSynchronize then  // vérifie qu'on est bien synchro avec le serveur
    begin
      outputdebugstring(Pchar('connectServer ' + UTF8ToString(Client.LastErrorMessage)));
      //FreeAndNil(Client);
      exit;
    end;
    client.ServiceDefine([IMessageService], sicShared);
    if not client.Services.Resolve(IMessageService, Service) then
      raise EServiceException.Create('erreur service non disponible');
  end
  else
  begin
    Service:= nil;
    FreeAndNil(CallBack);
    FreeAndNil(Client);
  end;
end;

{ TMessageService }

procedure TMessageService.NotifyConfiguration(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin

end;

procedure TMessageService.NotifyCustomers(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  {$IFDEF MASTER} postMessage(main.formMain.Handle, WM_NOTIFYEVENT, FCT_CUSTOMER, 0); {$ENDIF}
end;

procedure TMessageService.NotifyFamily(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
   {$IFDEF MASTER} postMessage(main.formMain.Handle, WM_NOTIFYEVENT, FCT_FAMILY, 0); {$ENDIF}
end;

procedure TMessageService.NotifyItems(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  {$IFDEF MASTER} postMessage(main.formMain.Handle, WM_NOTIFYEVENT, FCT_ITEM, 0); {$ENDIF}
end;

procedure TMessageService.NotifyOrders(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
  {$IFDEF MASTER} postMessage(main.formMain.Handle, WM_NOTIFYEVENT, FCT_ORDER, 0); {$ENDIF}
end;

procedure TMessageService.NotifySuppliers(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
 {$IFDEF MASTER} postMessage(main.formMain.Handle, WM_NOTIFYEVENT, FCT_SUPPLIER, 0); {$ENDIF}
end;

procedure TMessageService.NotifyVat(const AppID: RawUTF8;
  const ASonString: RawJSON);
begin
 {$IFDEF MASTER} postMessage(main.formMain.Handle, WM_NOTIFYEVENT, FCT_TVA, 0); {$ENDIF}
 //{$IFDEF UNIGUI} msgIGrow('des données de TVA ont été mise a jour', 'notice'); {$ENDIF}
end;

function newGUID: string;
var GUID: TGUID;
begin
  CreateGUID(GUID);
  result := GUIDToString(GUID);
end;

initialization

  global_param:= TParamInformation.Create;
  myIdentify:= newGUID;

finalization

  FreeAndNil(global_param);

end.
