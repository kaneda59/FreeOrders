unit MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, uni.cli.datas, uniGUIBaseClasses,
  uniGUIClasses, uniTimer, synCommons;

type
  TUniMainModule = class(TUniGUIMainModule)
    tmgetToken: TUniTimer;
    procedure UniGUIMainModuleCreate(Sender: TObject);
    procedure UniGUIMainModuleDestroy(Sender: TObject);
    procedure tmgetTokenTimer(Sender: TObject);
  private
    { Private declarations }
    procedure onNotifyService(objtype: string; const AppId, AJsonString: RawJSON);
    procedure onUpdateInformation(objtype: string; const AppId,
      AJsonString: RawJSON);
  public
    { Public declarations }
    microService: TMicroService;
    //Moduledonnees: TDonnees;
    procedure RefreshData(const FCT: integer);
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication, intfmsvc, ActiveX, DateUtils,
   classebase, json.tools, Data.DBXJSON, configuration, main, uni.frmListVats;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule);
end;

procedure TUniMainModule.onNotifyService(objtype: string; const AppId,
  AJsonString: RawJSON);
begin
  if AppId<>microService.myIdentify then // si c'est un message qui ne vient pas de moi
  if compareText(objtype, 'configuration')=0 then // et qu'une modification de la configuration à été effectuée
  begin

  end;
end;

procedure TUniMainModule.RefreshData(const FCT: integer);
begin
  //Moduledonnees.FillDatas(FCT);
end;


procedure TUniMainModule.tmgetTokenTimer(Sender: TObject);
var response: TResultInformation;
    information: TJSonObject;
begin
  if HoursBetween(Now, uniMainModule.microservice.LastToken)>1 then
  if Assigned(uniMainModule.microservice.Service) then
  begin
    //Service.Join(configfile.connection_server.appid);
    response:= JSonToResult(uniMainModule.microservice.Service.getToken(configfile.connection_server.appid));
    if Assigned(response) then
    begin
      if response.State = 'ok' then
      begin
        information:= TJSONObject.ParseJSONValue(response.response) as TJSonObject;
        if uniMainModule.microservice.MyToken='' then
        begin
          uniMainModule.microservice.myToken:= information.GetValue('information').Value;
          uniMainModule.microservice.global_param.token:= uniMainModule.microservice.MyToken;
//          ModuleDonnees.FillDatas;
        end
        else
        begin
          uniMainModule.microservice.myToken:= information.GetValue('information').Value;
          uniMainModule.microservice.global_param.token:= uniMainModule.microservice.MyToken;
        end;
        uniMainModule.microservice.LastToken:= now;
      end;
    end;
  end;
end;

procedure TUniMainModule.onUpdateInformation(objtype: string; const AppId, AJsonString: RawJSON);
begin
end;

procedure TUniMainModule.UniGUIMainModuleCreate(Sender: TObject);
begin
  coInitialize(nil);
  microService:= TMicroService.create;
  microService.ConnectToServer(True);
  microService.callback := TMessageService.Create(microservice.client, IMessageService); // abonnement aux notifications
  microService.Service.Join(microService.myIdentify, microservice.callback); // on joint le serveur pour s'identifier
  microService.CallBack.onNotifyEvent:= onUpdateInformation;
//  Moduledonnees := TDonnees.Create(nil);
  if Assigned(microService) then
    tmgetToken.Enabled:= True;
end;

procedure TUniMainModule.UniGUIMainModuleDestroy(Sender: TObject);
begin
  tmgetToken.Enabled:= False;
  microService.ConnectToServer(False);
  FreeAndNil(microService);
  //FreeAndNil(ModuleDonnees);
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
