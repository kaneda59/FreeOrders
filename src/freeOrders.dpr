program freeOrders;

uses
  Vcl.Forms,
  main in 'main.pas' {formMain},
  consts_ in 'consts_.pas',
  classebase in 'classes\classebase.pas',
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
  module.client in 'classes\module.client.pas',
  module.supplier in 'classes\module.supplier.pas',
  module.vat in 'classes\module.vat.pas',
  module.family in 'classes\module.family.pas',
  module.items in 'classes\module.items.pas',
  frmInputFamily in 'views\family\frmInputFamily.pas' {formInputFamily},
  frmInputSupplier in 'views\suppliers\frmInputSupplier.pas' {formInputSupplier},
  frmInputItem in 'views\items\frmInputItem.pas' {formInputItems},
  frmInputVat in 'views\vats\frmInputVat.pas' {formInputVat},
  frmListOrders in 'views\orders\frmListOrders.pas' {formListOrders},
  frmInputOrders in 'views\orders\frmInputOrders.pas' {formInputOrders},
  module.orders in 'classes\module.orders.pas',
  frmAbout in 'views\frmAbout.pas' {formAbout},
  configuration in 'classes\configuration.pas',
  frmInputConfiguration in 'views\frmInputConfiguration.pas' {formInputConfiguration},
  frmInputDelivery in 'views\orders\frmInputDelivery.pas' {formInputDelivery},
  Module in 'Module.pas' {Donnees: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDonnees, Donnees);
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
