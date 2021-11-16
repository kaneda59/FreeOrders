unit mainsvc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Registry, implmsvc;

type
  TServiceFreeOrders = class(TService)
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    function GetServiceController: TServiceController; override;
    { Déclarations publiques }
  end;

var
  ServiceFreeOrders: TServiceFreeOrders;

implementation

{$R *.DFM}
  uses module, ActiveX;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceFreeOrders.Controller(CtrlCode);
end;

function TServiceFreeOrders.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServiceFreeOrders.ServiceAfterInstall(Sender: TService);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, false) then
    begin
      Reg.WriteString('Description', 'FreeOrders - Service Dispatcher WebSockets (c)FreeOrders (r)2020');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TServiceFreeOrders.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  ActiveServer(Continued);
end;

procedure TServiceFreeOrders.ServiceCreate(Sender: TObject);
begin
  coInitialize(nil);
  module.Donnees:= TDonnees.Create(nil);
end;

procedure TServiceFreeOrders.ServiceDestroy(Sender: TObject);
begin
  FreeAndNil(module.Donnees);
end;

procedure TServiceFreeOrders.ServicePause(Sender: TService;
  var Paused: Boolean);
begin
  ActiveServer(Paused);
end;

procedure TServiceFreeOrders.ServiceShutdown(Sender: TService);
begin
  ActiveServer(False);
end;

procedure TServiceFreeOrders.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  ActiveServer(Started);
end;

procedure TServiceFreeOrders.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  ActiveServer(Stopped);
end;

end.
