program freeOrders_unigui;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Main in 'Main.pas' {MainForm: TUniForm},
  intfmsvc in '..\common\microsvc\intfmsvc.pas',
  json.tools in '..\common\microsvc\json.tools.pas',
  classebase in '..\common\classes\classebase.pas',
  configuration in '..\common\classes\configuration.pas',
  uni.cli.datas in 'api\uni.cli.datas.pas',
  consts_ in '..\src-master\consts_.pas',
  Logs in '..\src-master\Logs.pas',
  uni.frmBase in 'views\uni.frmBase.pas' {formBase: TUniForm},
  uni.frmListBase in 'views\uni.frmListBase.pas' {formBaseList: TUniForm},
  uni.frmListVats in 'views\vats\uni.frmListVats.pas' {FormListVats: TUniForm},
  uni.frmInputVat in 'views\vats\uni.frmInputVat.pas' {formInputVat: TUniForm},
  uni.frmListFamily in 'views\family\uni.frmListFamily.pas' {formListFamily: TUniForm},
  uni.frmInputFamily in 'views\family\uni.frmInputFamily.pas' {formInputFamily: TUniForm},
  uni.frmListItems in 'views\items\uni.frmListItems.pas' {formListItems: TUniForm},
  uni.frmBaseInput in 'views\uni.frmBaseInput.pas' {formBaseInput: TUniForm},
  uni.frmInputItem in 'views\items\uni.frmInputItem.pas' {formInputItem: TUniForm},
  uni.frmListSuppliers in 'views\suppliers\uni.frmListSuppliers.pas' {formListSuppliers: TUniForm},
  uni.frmInputSupplier in 'views\suppliers\uni.frmInputSupplier.pas' {forInputSupplier: TUniForm},
  uni.frmListCustomers in 'views\clients\uni.frmListCustomers.pas' {formListCustomers: TUniForm},
  uni.frmInputCustomer in 'views\clients\uni.frmInputCustomer.pas' {formInputCustomer: TUniForm},
  uni.frmInputConfig in 'views\configuration\uni.frmInputConfig.pas' {formBaseConfig: TUniForm},
  uni.frmListOrders in 'views\orders\uni.frmListOrders.pas' {formListOrders: TUniForm},
  uni.frmInputOrder in 'views\orders\uni.frmInputOrder.pas' {formInputOrders: TUniForm},
  uni.frmInputDelivery in 'views\orders\uni.frmInputDelivery.pas' {formBaseInput2: TUniForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Title := 'FreeOrders';
  Application.Run;
end.
