unit intfmsvc;

interface

  uses System.SysUtils, SynCommons, mORMot, Windows;

type

      // interrface d'échange de messages; (broadcast)  DxDevice
      IMessageCallBack = interface(IInvokable)
      ['{5C7E6F3B-BCC3-472D-8B6A-ED79BD9D7B1E}']
        procedure NotifyVat(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyItems(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifySuppliers(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyFamily(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyCustomers(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyOrders(const AppID: RawUTF8; const ASonString: RawJSON);
        procedure NotifyConfiguration(const AppID: RawUTF8; const ASonString: RawJSON);
      end;

     // interface de connexion coté client    exacto/dxCentrale/DxSAM, .....
     IMessageService = interface(IServiceWithCallBackReleased)
     ['{1489B6C5-D617-4CA1-97E7-59067F9FF90F}']
       procedure Join(const AppID: string; const callBack: IMessageCallBack);

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
     end;

const TRANSMISSION = 'E84029D8-1CF6-43EB-A689-EF6B55D2A721';
      REMOTE_PORT = '3000';

implementation

initialization
    TInterfaceFactory.RegisterInterfaces([TypeInfo(IMessageService), TypeInfo(IMessageCallBack)]);

end.
