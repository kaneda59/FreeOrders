program freeOrders_client;

uses
  Vcl.Forms,
  main in 'main.pas' {formMain},
  consts_ in 'consts_.pas',
  Logs in 'Logs.pas',
  frmBase in 'views\frmBase.pas' {FormBase},
  frmListBase in 'views\frmListBase.pas' {FormBaseList},
  frmBaseInput in 'views\frmBaseInput.pas' {formBaseInput},
  frmListClients in 'views\clients\frmListClients.pas' {formListClients},
  frmListSuppliers in 'views\suppliers\frmListSuppliers.pas' {formListSuppliers},
  frmListFamily in 'views\family\frmListFamily.pas' {formListFamily},
  frmListItems in 'views\items\frmListItems.pas' {formListItems},
  frmListVats in 'views\vats\frmListVats.pas' {FormListVats},
  frmInputClient in 'views\clients\frmInputClient.pas' {formInputClient},
  frmInputFamily in 'views\family\frmInputFamily.pas' {formInputFamily},
  frmInputSupplier in 'views\suppliers\frmInputSupplier.pas' {formInputSupplier},
  frmInputItem in 'views\items\frmInputItem.pas' {formInputItems},
  frmInputVat in 'views\vats\frmInputVat.pas' {formInputVat},
  frmListOrders in 'views\orders\frmListOrders.pas' {formListOrders},
  frmInputOrders in 'views\orders\frmInputOrders.pas' {formInputOrders},
  frmAbout in 'views\frmAbout.pas' {formAbout},
  frmInputConfiguration in 'views\frmInputConfiguration.pas' {formInputConfiguration},
  frmInputDelivery in 'views\orders\frmInputDelivery.pas' {formInputDelivery},
  Module in 'Module.pas' {Donnees: TDataModule},
  cli.datas in 'cli.datas.pas',
  intfmsvc in '..\common\microsvc\intfmsvc.pas',
  json.tools in '..\common\microsvc\json.tools.pas',
  classebase in '..\common\classes\classebase.pas',
  configuration in '..\common\classes\configuration.pas',
  module.client in '..\common\classes\module.client.pas',
  module.family in '..\common\classes\module.family.pas',
  module.items in '..\common\classes\module.items.pas',
  module.orders in '..\common\classes\module.orders.pas',
  module.supplier in '..\common\classes\module.supplier.pas',
  module.vat in '..\common\classes\module.vat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDonnees, Donnees);
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
