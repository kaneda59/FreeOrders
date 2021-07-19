program freeOrders;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  Module in 'Module.pas' {Donnees: TDataModule},
  consts_ in 'consts_.pas',
  classebase in 'classes\classebase.pas',
  Logs in 'Logs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDonnees, Donnees);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
