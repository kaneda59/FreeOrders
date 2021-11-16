object ServiceFreeOrders: TServiceFreeOrders
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'svcFreeOrders'
  AfterInstall = ServiceAfterInstall
  OnContinue = ServiceContinue
  OnPause = ServicePause
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 339
  Width = 396
end
