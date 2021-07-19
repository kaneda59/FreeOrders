program freeOrders;

uses
  Vcl.Forms,
  main in 'main.pas' {formMain},
  Module in 'Module.pas' {Donnees: TDataModule},
  consts_ in 'consts_.pas',
  classebase in 'classes\classebase.pas',
  Logs in 'Logs.pas',
  frmBase in 'views\frmBase.pas' {FormBase},
  frmListBase in 'views\frmListBase.pas' {FormBaseList},
  frmBaseInput in 'views\frmBaseInput.pas' {formBaseInput},
  frmListClients in 'views\clients\frmListClients.pas' {formListClients};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDonnees, Donnees);
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
