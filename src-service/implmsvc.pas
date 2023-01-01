unit implmsvc;

interface

  uses Winapi.Windows, SysUtils, Classes, SynCommons, SynLog, mORMot, //SynBidirSock,
       mORMotHttpServer,
       Intfmsvc, System.Variants, DateUtils;

type

   // classe micro services;
   TMessageService = class(TInterfacedObject, IMessageService)
   protected
     fConnected: array of IMessageCallBack; // tableau de client
   public
     procedure Join(const AppID: string; const callBack: IMessageCallBack); // méthode mon interface de connexion

     // requêtes de récupération d'information
     function  getToken(const AppID: RawUTF8): RawJSON;
     function  getVat(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getListVat(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getItem(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getListItems(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getSupplier(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getListSuppliers(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getFamily(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getListFamily(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getCustomer(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getListCustomers(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getOrder(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getListOrders(const AppID: RawUTF8; const AJSonString: RawUTF8): RAWJSON;
     function  getConfiguration(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;

     // permet de faire des select
     function getSQL(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;

     // requête de mise à jour d'information
     procedure setVat(const AppID: RawUTF8; const AJSonString: RawUTF8; const information: RawUTF8);
     procedure setItem(const AppID: RawUTF8; const AJSonString: RawUTF8; const information: RawUTF8);
     procedure setSupplier(const AppID: RawUTF8; const AJSonString: RawUTF8; const information: RawUTF8);
     procedure setFamily(const AppID: RawUTF8; const AJSonString: RawUTF8; const information: RawUTF8);
     procedure setCustomer(const AppID: RawUTF8; const AJSonString: RawUTF8; const information: RawUTF8);
     procedure setOrder(const AppID: RawUTF8; const AJSonString: RawUTF8; const information: RawUTF8);
     procedure setOrderLine(const AppID: RawUTF8; const AJSonString: RawUTF8; const information: RawUTF8);
     procedure setConfiguration(const AppID: RawUTF8; const AJSonString: RawUTF8; const information: RawUTF8);

     // requête de suppression d'information
     function deleteVat(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
     function deleteItem(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
     function deleteSupplier(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
     function deleteFamily(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
     function deleteCustomer(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
     function deleteOrder(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
     function deleteOrderLine(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
     procedure CallBackReleased(const callBack: IInvokable; const interfaceName: RawUTF8);  // quand un client se déconnecte
   end;

   procedure ActiveServer(const active: boolean);

var HttpServer: TSQLHttpServer;
    Server: TSQLRestServerFullMemory;

implementation

 uses classebase, json.tools,
      module.vat, module.items, module.supplier, module.family,
      module.client, module.orders, configuration,
      module, implmsvc.tools;



procedure ActiveServer(const active: boolean);
var svn: string;
    psn: string;
    prefix: string;
    IPHeader: string;
    ConnIDHeader: string;
begin
  with TSQLLog.Family do
  begin
    Level:= LOG_VERBOSE;
    EchoToConsole:= LOG_VERBOSE;
    PerThreadLog:= ptIdentifiedInOnFile;
  end;
  try
    if active then
    begin
      server:= TSQLRestServerFullMemory.CreateWithOwnModel([]);

      // webSocket
      Server.CreateMissingTables();
      Server.ServiceDefine(TMessageService,[IMessageService],sicShared).
      SetOptions([],[optExecLockedPerInterface]). // thread-safe fConnected[]

      ByPassAuthentication := true;


      HttpServer := TSQLHttpServer.Create(REMOTE_PORT,[Server],'+',useBidirSocket);
      HttpServer.AccessControlAllowOrigin:= '*';
      with  HttpServer.WebSocketsEnable(Server, TRANSMISSION) do
      begin
        Settings.SetFullLog;
        psn:= ProcessName;  // root
      end;
//      HttpServer.AddUrlWebSocket('whatever', '8888', False, 'localhost');
    end
    else
    begin
      HttpServer.Free;
    end;
  except
    on e: Exception do
      outputdebugstring(PChar('erreur de connexion au serveur : ' + e.Message));
  end;
end;

{ TMessageService }

procedure TMessageService.CallBackReleased(const callBack: IInvokable;
  const interfaceName: RawUTF8);
begin
  if interfaceName='IMessageCallBack' then
    InterfaceArrayDelete(fConnected,callback);
end;

function TMessageService.deleteCustomer(const AppID, AJSonString: RawUTF8): RawJSON;
begin

end;

function TMessageService.deleteFamily(const AppID, AJSonString: RawUTF8): RawJSON;
var
  I    : Integer;
  iv   : TParamInformation;
  rv   : TResultInformation;
  mFamily: TModule_Family;
  v    : Variant;
begin
  OutputDebugString(pchar('deleteFamily.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mFamily:= TModule_Family.create(iv.id);
         if mFamily.delete then
         begin
           rv.State:= 'ok';
           rv.Response:= '{"information":"Family deleted"}';

           for I := High(fConnected) downto 0 do
           try
             fconnected[i].NotifyFamily(AppID, ResultToJSon(rv));
           except
             InterfaceArrayDelete(fConnected, i);
           end;

         end
         else
         begin
           rv.State:= 'error';
           rv.response:= '{"information":"Family not deleted"}';
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);  // on renvoie la réponse en résultat
     finally
       FreeAndNil(mFamily);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.deleteItem(const AppID, AJSonString: RawUTF8): RawJSON;
var
  I    : Integer;
  iv   : TParamInformation;
  rv   : TResultInformation;
  mitem: TModule_items;
  v    : Variant;
begin
  OutputDebugString(pchar('getVat.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mitem:= TModule_items.create(iv.id);
         if mitem.delete then
         begin
           rv.State:= 'ok';
           rv.Response:= '{"information":"item deleted"}';

           for I := High(fConnected) downto 0 do
           try
             fconnected[i].NotifyItems(AppID, ResultToJSon(rv));
           except
             InterfaceArrayDelete(fConnected, i);
           end;

         end
         else
         begin
           rv.State:= 'error';
           rv.response:= '{"information":"item not deleted"}';
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);  // on renvoie la réponse en résultat
     finally
       FreeAndNil(mitem);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.deleteOrder(const AppID, AJSonString: RawUTF8): RawJSON;
begin

end;

function TMessageService.deleteOrderLine(const AppID, AJSonString: RawUTF8): RawJSON;
begin

end;

function TMessageService.deleteSupplier(const AppID, AJSonString: RawUTF8): RawJSON;
begin

end;

function TMessageService.deleteVat(const AppID, AJSonString: RawUTF8): RawJSON;
var
  I    : Integer;
  iv   : TParamInformation;
  rv   : TResultInformation;
  mtva : TModule_Vat;
  v    : Variant;
begin
  OutputDebugString(pchar('getVat.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mtva:= TModule_vat.create(iv.id);
         if mtva.delete then
         begin
           rv.State:= 'ok';
           rv.Response:= '{"information":"vat deleted"}';

           for I := High(fConnected) downto 0 do
           try
             fconnected[i].NotifyVat(AppID, ResultToJSon(rv));
           except
             InterfaceArrayDelete(fConnected, i);
           end;

         end
         else
         begin
           rv.State:= 'error';
           rv.response:= '{"information":"vat not deleted"}';
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);  // on renvoie la réponse en résultat
     finally
       FreeAndNil(mtva);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getConfiguration(const AppID: RawUTF8;
  const AJSonString: RawUTF8): RawJSON;
var
  I     : Integer;
  config: TConfiguration_informations;
  iv    : TParamInformation;
  rv    : TResultInformation;
  v     : Variant;
begin
  OutputDebugString(pchar('getConfiguration.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     config := TConfiguration_informations.Create;
     iv     := TParamInformation.Create;
     rv     := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         config.DecimalSeparator := configfile.settingFormat.Values['decimalseparator'];
         config.ShortDateFormat  := configfile.settingFormat.Values['shortdateformat'];
         rv.State:= 'ok';
         rv.Response:= ConfigToJSon(config);
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);  // on renvoie la réponse en résultat

     finally
       FreeAndNil(config);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getCustomer(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var
  I        : Integer;
  iv       : TParamInformation;
  rv       : TResultInformation;
  mClient  : TModule_Client;
  v        : Variant;
begin
  OutputDebugString(pchar('getCustomers.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mClient:= TModule_Client.create(iv.id);
         mClient.Read;
         rv.State:= 'ok';
         rv.Response:= ClientToJSon(mClient.client);
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(mClient);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getFamily(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var
  I        : Integer;
  iv       : TParamInformation;
  rv       : TResultInformation;
  mFamily  : TModule_Family;
  v        : Variant;
begin
  OutputDebugString(pchar('getFamily.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mFamily:= TModule_Family.create(iv.id);
         mFamily.Read;
         rv.State:= 'ok';
         rv.Response:= FamilyToJSon(mFamily.Family);
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(mFamily);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getItem(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var
  I     : Integer;
  iv    : TParamInformation;
  rv    : TResultInformation;
  mitems: TModule_Items;
  v     : Variant;
begin
  OutputDebugString(pchar('getItems.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mitems:= TModule_Items.create(iv.id);
         mitems.Read;
         rv.State:= 'ok';
         rv.Response:= ItemsToJSon(mItems.items);
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(mItems);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getListCustomers(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var iv: TParamInformation;
    rv: TResultInformation;
    md: TModule_Client;
    res: RawJSON;
begin
  OutputdebugString(pchar('getListCustomers.reception ' + AppId + ' : ' + AJSonString));
  res:= '[';
  try
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);
       if isTokenValid(AppID, iv.token) then
       begin
         with Donnees.addQuery do
         try
           SQL.Add('SELECT id FROM clients');
           Open;
           while not EOF do
           begin
             md:= TModule_Client.Create(FieldByName('id').AsInteger);
             md.Read;
             res:= res + ClientToJSon(md.client) + ',';
             Next;
           end;
           if RecordCount>0 then
             System.Delete(res, Length(res), 1);
           res:= res + ']';
           Close;
         finally
           Free;
         end;
         rv.State:= 'ok';
         rv.response:= res;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getListFamily(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var iv: TParamInformation;
    rv: TResultInformation;
    md: TModule_Family;
    res: RawJSON;
begin
  OutputdebugString(pchar('getListFamily.reception ' + AppId + ' : ' + AJSonString));
  res:= '[';
  try
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);
       if isTokenValid(AppID, iv.token) then
       begin
         with Donnees.addQuery do
         try
           SQL.Add('SELECT id FROM Family');
           Open;
           while not EOF do
           begin
             md:= TModule_Family.Create(FieldByName('id').AsInteger);
             md.Read;
             res:= res + FamilyToJSon(md.Family) + ',';
             Next;
           end;
           if RecordCount>0 then
             System.Delete(res, Length(res), 1);
           res:= res + ']';
           Close;
         finally
           Free;
         end;
         rv.State:= 'ok';
         rv.response:= res;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getListItems(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var iv: TParamInformation;
    rv: TResultInformation;
    md: TModule_items;
    res: RawJSON;
begin
  OutputdebugString(pchar('getListItems.reception ' + AppId + ' : ' + AJSonString));
  res:= '[';
  try
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);
       if isTokenValid(AppID, iv.token) then
       begin
         with Donnees.addQuery do
         try
           SQL.Add('SELECT id FROM items');
           Open;
           while not EOF do
           begin
             md:= TModule_Items.Create(FieldByName('id').AsInteger);
             md.Read;
             res:= res + ItemsToJSon(md.Items) + ',';
             Next;
           end;
           if RecordCount>0 then
             System.Delete(res, Length(res), 1);
           res:= res + ']';
           Close;
         finally
           Free;
         end;
         rv.State:= 'ok';
         rv.response:= res;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getListOrders(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var iv: TParamInformation;
    rv: TResultInformation;
    md: TModule_orders;
    res: RawJSON;
    subres: RawJSON;
    i : integer;
begin
  OutputdebugString(pchar('getListOrders.reception ' + AppId + ' : ' + AJSonString));
  res:= '[';
  try
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);
       if isTokenValid(AppID, iv.token) then
       begin
         with Donnees.addQuery do
         try
           SQL.Add('SELECT id FROM orders');
           Open;
           while not EOF do
           begin
             md:= TModule_orders.Create(FieldByName('id').AsInteger);
             md.Read;

             subres:= '{"_id":"' + intToStr(md.Orders._id) + '","_Code":"' + md.Orders._Code + '","_idClient":"' +
                              intToStr(md.Orders._idClient) + '","_date":"' + FormatDateTime('yyy-mm-dd', md.Orders._date) + '","_stateOrder":"' +
                              IntToStr(Ord(md.Orders._stateOrder)) + '","_Lines":[';
             for i := Low(md.Orders._Lines) to High(md.Orders._Lines) do
               subres := subres + OrderLineToJSon(md.Orders._Lines[i]) + ',';
             System.Delete(subres, Length(subres), 1);
             subres:= subres + ']}';

             res:= res + subres + ',';
             Next;
           end;
           if RecordCount>0 then
             System.Delete(res, Length(res), 1);
           res:= res + ']';
           Close;
         finally
           Free;
         end;
         rv.State:= 'ok';
         rv.response:= res;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getListSuppliers(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var iv: TParamInformation;
    rv: TResultInformation;
    md: TModule_Suppliers;
    res: RawJSON;
begin
  OutputdebugString(pchar('getListSuppliers.reception ' + AppId + ' : ' + AJSonString));
  res:= '[';
  try
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);
       if isTokenValid(AppID, iv.token) then
       begin
         with Donnees.addQuery do
         try
           SQL.Add('SELECT id FROM suppliers');
           Open;
           while not EOF do
           begin
             md:= TModule_Suppliers.Create(FieldByName('id').AsInteger);
             md.Read;
             res:= res + SupplierToJSon(md.Supplier) + ',';
             Next;
           end;
           if RecordCount>0 then
             System.Delete(res, Length(res), 1);
           res:= res + ']';
           Close;
         finally
           Free;
         end;
         rv.State:= 'ok';
         rv.response:= res;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getSQL(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var iv: TParamInformation;
    rv: TResultInformation;
    md: TModule_Vat;
    res: RawJSON;
    aJsonValue: string;
    i: integer;
    js: string;
begin
 OutputdebugString(pchar('getListVat.reception ' + AppId + ' : ' + AJSonString));
 res:= '[';
 try
   iv := TParamInformation.Create;
   rv := TResultInformation.Create;
   try
     // on récupère les informations passées en paramètres (envoyées par le client)
     iv:= JSonToParam(AJSonString);
     if isTokenValid(AppID, iv.token) then
     begin
       with Donnees.addQuery do
       try
         SQL.Add(iv.information);
         try
           Open;
           AJsonValue:= '[';
           while not Eof do
           begin
             js:= '{';
             for i := 0 to Fields.Count-1 do
             begin
               js := js + '"' + Fields[i].FieldName + '":"' + Fields[i].AsString + '",';
             end;
             if Length(js)>1 then
               System.delete(js, Length(js), 1);
             AJsonValue:= AJsonValue + js + '},';
             Next;
           end;
           Close;
           if AJsonValue[length(AJsonValue)]=',' then
             System.delete(AJsonValue, Length(AJsonValue), 1);
           AJsonValue := AJsonValue + ']';
           rv.State:= 'ok';
           rv.response := aJsonValue;
         except
           on e: Exception do
           begin
             rv.State:= 'error';
             rv.Response:= '{"information":"erreur sql : ' + e.Message + '"}';
           end;
         end;
       finally
         Free;
       end;
     end;
   finally
     FreeAndNil(iv);

   end;
 except
   on e: Exception do
   begin
     rv.State:= 'error';
     rv.Response:= '{"information":"erreur sql : ' + e.Message + '"}';
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
   end;
 end;
 result:= resultToJSon(rv);
 FreeAndNil(rv);
end;

function TMessageService.getListVat(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var iv: TParamInformation;
    rv: TResultInformation;
    md: TModule_Vat;
    res: RawJSON;
begin
  OutputdebugString(pchar('getListVat.reception ' + AppId + ' : ' + AJSonString));
  res:= '[';
  try
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);
       if isTokenValid(AppID, iv.token) then
       begin
         with Donnees.addQuery do
         try
           SQL.Add('SELECT id from VATs');
           Open;
           while not EOF do
           begin
             md:= TModule_Vat.Create(FieldByName('id').AsInteger);
             md.Read;
             res:= res + vatToJSon(md.Vat) + ',';
             Next;
           end;
           if RecordCount>0 then
             System.Delete(res, Length(res), 1);
           res := res + ']';
           Close;
         finally
           Free;
         end;
         rv.State:= 'ok';
         rv.response:= res;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getOrder(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var
  I     : Integer;
  iv    : TParamInformation;
  rv    : TResultInformation;
  mOrder: TModule_Orders;
  v     : Variant;
  res   : RawUTF8;
begin
  OutputDebugString(pchar('getOrders.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     res := '';
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mOrder:= TModule_Orders.create(iv.id);
         mOrder.Read;
         if not mOrder.isEmpty then
         begin
           rv.State:= 'ok';

           res:= '{"_id":"' + intToStr(mOrder.Orders._id) + '","_Code":"' + mOrder.Orders._Code + '","_idClient":"' +
                              intToStr(mOrder.Orders._idClient) + '","_date":"' + FormatDateTime('yyy-mm-dd', mOrder.Orders._date) + '","_stateOrder":"' +
                              IntToStr(Ord(mOrder.Orders._stateOrder)) + '","_Lines":[';
           for i := Low(mOrder.Orders._Lines) to High(mOrder.Orders._Lines) do
             res := res + OrderLineToJSon(mOrder.Orders._Lines[i]) + ',';
           System.Delete(res, Length(res), 1);
           res:= res + ']}';
           OutputDebugString(PChar(res));
         end
         else
         begin
           rv.State:= 'error';
           rv.response :=  '{"information":"order not found"}'
         end;


         rv.Response:= res;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(mOrder);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message + ' :: ' + res));
  end;
end;

function TMessageService.getSupplier(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var
  I        : Integer;
  iv       : TParamInformation;
  rv       : TResultInformation;
  mSupplier: TModule_Suppliers;
  v        : Variant;
begin
  OutputDebugString(pchar('getSuppliers.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv    := TParamInformation.Create;
     rv    := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mSupplier:= TModule_Suppliers.create(iv.id);
         mSupplier.Read;
         rv.State:= 'ok';
         rv.Response:= SupplierToJSon(mSupplier.supplier);
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);
     finally
       FreeAndNil(mSupplier);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

function TMessageService.getToken(const AppID: RawUTF8): RawJSON;
var rv: TResultInformation;
begin
  rv:= TResultInformation.Create;
  try
    if isAppExists(AppId) then
    begin
      rv.response:= getdbToken(AppId);
      if rv.response='' then
      begin
        rv.response:= '{"information":"' + FillGuid(AppId) + '"}';
        if pos('msg', rv.response)>0 then
             rv.state:= 'error'
        else rv.State:= 'ok';
      end
      else rv.State:= 'ok';
    end
    else
    begin
      rv.state:= 'error';
      rv.response:= '{"information":"unknown application"}';
    end;
    result:= ResultToJSon(rv);
  finally
    FreeAndNil(rv);
  end;
end;

function TMessageService.getVat(const AppID: RawUTF8; const AJSonString: RawUTF8): RawJSON;
var
  I    : Integer;
  iv   : TParamInformation;
  rv   : TResultInformation;
  mtva : TModule_Vat;
  v    : Variant;
begin
  OutputDebugString(pchar('getVat.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       begin
         mtva:= TModule_vat.create(iv.id);
         mtva.Read;
         rv.State:= 'ok';
         rv.Response:= vatToJSon(mtva.vat);
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;

       result:= resultToJSon(rv);  // on renvoie la réponse en résultat
     finally
       FreeAndNil(mtva);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

procedure TMessageService.Join(const AppID: string;
  const callBack: IMessageCallBack);
begin
  InterfaceArrayAdd(fConnected, callBack);
end;

procedure TMessageService.setConfiguration(const AppID: RawUTF8;
  const AJSonString: RawUTF8; const information: RawUTF8);
var
  I     : Integer;
  iv    : TParamInformation;
  rv    : TResultInformation;
  v     : Variant;
begin
  OutputDebugString(pchar('getConfiguration.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv     := TParamInformation.Create;
     rv     := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       with  JSonToConfig(information) do
       begin
         configfile.settingFormat.Values['decimalseparator'] := DecimalSeparator;
         configfile.settingFormat.Values['shortdateformat']  := ShortDateFormat;
         rv.State:= 'ok';
         rv.Response:=  '{"information":"update configuration"}';

         for I := High(fConnected) downto 0 do
         try
           fconnected[i].NotifyConfiguration(AppID, ResultToJSon(rv));
         except
           InterfaceArrayDelete(fConnected, i);
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;
     finally
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

procedure TMessageService.setCustomer(const AppID: RawUTF8;
  const AJSonString: RawUTF8; const information: RawUTF8);
var
  I        : Integer;
  iv       : TParamInformation;
  rv       : TResultInformation;
  mCustomer: TModule_Client;
  v        : Variant;
begin
  OutputDebugString(pchar('setCustomers.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       with  JSonToClient(information) do
       begin
         mCustomer:= TModule_Client.create(iv.id);
         mCustomer.Read;
         if not mCustomer.isEmpty then
           mCustomer.client._id       := _id;
         mCustomer.client._FirstName  := _FirstName;
         mCustomer.client._LastName   := _LastName;
         mCustomer.client._Address    := _Address;
         mCustomer.client._supplement := _supplement;
         mCustomer.client._ZipCode    := _ZipCode;
         mCustomer.client._City       := _City;
         mCustomer.client._Country    := _Country;
         mCustomer.client._Phone      := _Phone;
         mCustomer.client._Mobile     := _Mobile;
         mCustomer.client._Account    := _Account;
         mCustomer.client._mail       := _mail;
         mCustomer.Write;

         rv.State:= 'ok';
         rv.Response:= '{"information":"update customers"}';

         for I := High(fConnected) downto 0 do
         try
           fconnected[i].NotifyCustomers(AppID, ResultToJSon(rv));
         except
           InterfaceArrayDelete(fConnected, i);
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;
     finally
       FreeAndNil(mSupplier);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

procedure TMessageService.setFamily(const AppID: RawUTF8;
  const AJSonString: RawUTF8; const information: RawUTF8);
var
  I        : Integer;
  iv       : TParamInformation;
  rv       : TResultInformation;
  mFamily  : TModule_Family;
  v        : Variant;
begin
  OutputDebugString(pchar('setSuppliers.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       with  JSonToFamily(information) do
       begin
         mFamily:= TModule_Family.create(_id);
         mFamily.Read;
         if not mFamily.isEmpty then
           mFamily.Family._id         := _id;
         mFamily.Family._code       := _Code;
         mFamily.Family._Label      := _Label;
         mFamily.Family._description:= _description;
         mFamily.Write;

         rv.State:= 'ok';
         rv.Response:= '{"information":"update Family"}';

         for I := High(fConnected) downto 0 do
         try
           fconnected[i].NotifyFamily(AppID, ResultToJSon(rv));
         except
           InterfaceArrayDelete(fConnected, i);
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;
     finally
       FreeAndNil(mFamily);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

procedure TMessageService.setItem(const AppID: RawUTF8;
  const AJSonString: RawUTF8; const information: RawUTF8);
var
  I     : Integer;
  iv    : TParamInformation;
  rv    : TResultInformation;
  mItems: TModule_Items;
  v     : Variant;
begin
  OutputDebugString(pchar('setItem.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       with  JSonToItems(information) do
       begin
         mItems:= TModule_Items.create(_id);
         mItems.Read;
         if not mItems.isEmpty then
           mItems.Items._id         := _id;
         mItems.Items._Code       := _Code;
         mItems.Items._Label      := _Label;
         mItems.Items._description:= _description;
         mItems.Items._pvht       := _pvht;
         mItems.Items._paht       := _paht;
         mItems.Items._idvat      := _idvat;
         mItems.Items._actif      := _actif;
         mItems.Items._idfamily   := _idfamily;
         mItems.Items._idSupplier := _idSupplier;
         mItems.Write;

         rv.State:= 'ok';
         rv.Response:= '{"information":"update Items"}';

         for I := High(fConnected) downto 0 do
         try
           fconnected[i].NotifyItems(AppID, ResultToJSon(rv));
         except
           InterfaceArrayDelete(fConnected, i);
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;


     finally
       FreeAndNil(mItems);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

procedure TMessageService.setOrderLine(const AppID, AJSonString,
  information: RawUTF8);
begin

end;

procedure TMessageService.setOrder(const AppID: RawUTF8;
  const AJSonString: RawUTF8; const information: RawUTF8);
var
  I        : Integer;
  iv       : TParamInformation;
  rv       : TResultInformation;
  mOrder   : TModule_orders;
  v        : Variant;
begin
  OutputDebugString(pchar('setOrders.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       with  JSonToOrders(information) do
       begin
         mOrder:= TModule_orders.create(iv.id);
         mOrder.Read;
         if not mOrder.isEmpty then
           mOrder.Orders._id         := _id;
         mOrder.Orders._Code       := _Code;
         mOrder.Orders._idClient   := _idClient;
         mOrder.Orders._date       := _date;
         mOrder.Orders._stateOrder := _stateOrder;
         mOrder.Write;

         rv.State:= 'ok';
         rv.Response:= '{"information":"update Orders"}';

         for I := High(fConnected) downto 0 do
         try
           fconnected[i].NotifyOrders(AppID, ResultToJSon(rv));
         except
           InterfaceArrayDelete(fConnected, i);
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;
     finally
       FreeAndNil(mSupplier);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

procedure TMessageService.setSupplier(const AppID: RawUTF8;
  const AJSonString: RawUTF8; const information: RawUTF8);
var
  I        : Integer;
  iv       : TParamInformation;
  rv       : TResultInformation;
  mSupplier: TModule_Suppliers;
  v        : Variant;
begin
  OutputDebugString(pchar('setSuppliers.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       with  JSonToSupplier(information) do
       begin
         mSupplier:= TModule_Suppliers.create(_id);
         mSupplier.Read;
         if not mSupplier.isEmpty  then
           mSupplier.Supplier._id         := _id;
         mSupplier.Supplier._Label      := _Label;
         mSupplier.Supplier._description:= _description;
         mSupplier.Supplier._Address    := _Address;
         mSupplier.Supplier._supplement := _supplement;
         mSupplier.Supplier._ZipCode    := _ZipCode;
         mSupplier.Supplier._City       := _City;
         mSupplier.Supplier._Country    := _Country;
         mSupplier.Supplier._Phone      := _Phone;
         mSupplier.Supplier._Mobile     := _Mobile;
         mSupplier.Supplier._Account    := _Account;
         mSupplier.Supplier._mail       := _mail;
         mSupplier.Write;

         rv.State:= 'ok';
         rv.Response:= '{"information":"update Supplier"}';

         for I := High(fConnected) downto 0 do
         try
           fconnected[i].NotifySuppliers(AppID, ResultToJSon(rv));
         except
           InterfaceArrayDelete(fConnected, i);
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;
     finally
       FreeAndNil(mSupplier);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;
end;

procedure TMessageService.setVat(const AppID: RawUTF8;
  const AJSonString: RawUTF8; const information: RawUTF8);
var
  I    : Integer;
  iv   : TParamInformation;
  rv   : TResultInformation;
  mtva : TModule_Vat;
begin
  OutputDebugString(pchar('setVat.reception ' + AppID + ' : ' + AJSonString));
  try
     // on initialise les objets dont on va avoir besoin
     iv  := TParamInformation.Create;
     rv  := TResultInformation.Create;
     try
       // on récupère les informations passées en paramètres (envoyées par le client)
       iv:= JSonToParam(AJSonString);

       // on vérifie que le token passé est valide
       if isTokenValid(AppID, iv.token) then
       with  JSonTovat(information) do
       begin
         mtva:= TModule_vat.create(_id);
         mtva.Read;
         if not mtva.isEmpty then
           mtva.Vat._id    := _id;
         mtva.Vat._label := _label;
         mtva.Vat._value := _value;
         mtva.Write;

         rv.State:= 'ok';
         rv.Response:= '{"information":"update vat"}';

         for I := High(fConnected) downto 0 do
         try
           fconnected[i].NotifyVat(AppID, ResultToJSon(rv));
         except
           InterfaceArrayDelete(fConnected, i);
         end;
       end
       else
       begin
         rv.State:= 'error';
         rv.Response:= '{"information":"invalid token"}';
       end;
     finally
       FreeAndNil(mtva);
       FreeAndNil(iv);
       FreeAndNil(rv);
     end;
  except
    on e: Exception do
     OutputDebugString(pchar('erreur ' + AppID + ' : ' + AJSonString + ' --> ' + e.Message));
  end;

  //result:= resultToJSon(rv);

end;

initialization

finalization

  if Assigned(Server) then
     FreeAndNil(Server);


end.
