program svcFreeOrders;

uses
  Vcl.SvcMgr,
  mainsvc in 'mainsvc.pas' {ServiceFreeOrders: TService},
  classebase in '..\common\classes\classebase.pas',
  configuration in '..\common\classes\configuration.pas',
  module.client in '..\common\classes\module.client.pas',
  module.family in '..\common\classes\module.family.pas',
  module.items in '..\common\classes\module.items.pas',
  module.orders in '..\common\classes\module.orders.pas',
  module.supplier in '..\common\classes\module.supplier.pas',
  module.vat in '..\common\classes\module.vat.pas',
  intfmsvc in '..\common\microsvc\intfmsvc.pas',
  json.tools in '..\common\microsvc\json.tools.pas',
  Module in 'Module.pas' {Donnees: TDataModule},
  consts_ in '..\common\consts_.pas',
  Logs in '..\common\Logs.pas',
  implmsvc.tools in 'implmsvc.tools.pas',
  implmsvc in 'implmsvc.pas',
  Tools in '..\common\Tools.pas';

{$R *.RES}

begin
  // Windows 2003 Server nécessite que StartServiceCtrlDispatcher soit
  // appelé avant CoRegisterClassObject, qui peut être appelé indirectement
  // par Application.Initialize. TServiceApplication.DelayInitialize permet
  // l'appel de Application.Initialize depuis TService.Main (après
  // l'appel de StartServiceCtrlDispatcher).
  //
  // L'initialisation différée de l'objet Application peut affecter
  // les événements qui surviennent alors avant l'initialisation, tels que
  // TService.OnCreate. Elle est seulement recommandée si le ServiceApplication
  // enregistre un objet de classe avec OLE et est destinée à une utilisation
  // avec Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TServiceFreeOrders, ServiceFreeOrders);
  Application.CreateForm(TDonnees, Donnees);
  Application.Run;
end.
