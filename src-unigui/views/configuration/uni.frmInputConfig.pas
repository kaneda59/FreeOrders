unit uni.frmInputConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, classebase,
  uniGUIClasses, uniGUIForm, uni.frmBaseInput, uniButton, uniLabel,
  uniGUIBaseClasses, uniPanel, uniPageControl, uniEdit, uniBasicGrid,
  uniStringGrid, json.tools;

type
  TformBaseConfig = class(TformBaseInput)
    pageControl: TUniPageControl;
    tbsAPI: TUniTabSheet;
    tbsAllParams: TUniTabSheet;
    UniContainerPanel1: TUniContainerPanel;
    edtHost: TUniEdit;
    edtPort: TUniEdit;
    btnTest: TUniButton;
    grid: TUniStringGrid;
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
    config: TConfiguration_informations;
    procedure ReadScreen;
    procedure WriteScreen;
    procedure CallBack(Sender: TComponent; Result: Integer);
  public
    { Public declarations }
    class procedure Execute;
  end;

function formBaseConfig: TformBaseConfig;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, uni.cli.datas;

function formBaseConfig: TformBaseConfig;
begin
  Result := TformBaseConfig(UniMainModule.GetFormInstance(TformBaseConfig));
end;

procedure TformBaseConfig.btnTestClick(Sender: TObject);
var mtest: TMicroService;
begin
  inherited;
  mtest:= TMicroService.create;
  try
    try
      mtest.ConnectToServer(true, edtHost.Text, edtPort.text);
      if Assigned(mtest.Service) then
           ShowMessage('connexion ok')
      else ShowMessage('connexion impossible');
    except
      on e: Exception do
        ShowMessage('connexion impossible : ' + e.Message);
    end;
  finally
    FreeAndNil(mtest);
  end;
end;

procedure TformBaseConfig.CallBack(Sender: TComponent; Result: Integer);
begin
  if Result=mrOk then
    WriteScreen;
end;

class procedure TformBaseConfig.Execute;
begin
  formBaseConfig.ReadScreen;
  formBaseConfig.ShowModal(formBaseConfig.callBack);
end;

procedure TformBaseConfig.ReadScreen;
var res: TResultInformation;
begin
  edtHost.Text:= UniApplication.Cookies.Values['host'];
  if edtHost.Text='' then
    edtHost.Text:= '127.0.0.1';

  edtPort.Text:= UniApplication.Cookies.Values['port'];
  if edtPort.Text='' then
    edtPort.Text:= '3000';
  MainModule.UniMainModule.tmgetTokenTimer(nil);
  res:= JSonToResult(UniMainModule.microService.Service.getConfiguration(UniMainModule.microService.AppID,
                                      ParamToJSon(UniMainModule.microService.global_param)));

  if compareText(res.State, 'ok')=0 then
  begin
    config := JSonToConfig(res.response);
    grid.RowCount:= 3;
    grid.Cells[0,0]:= 'Paramètre';
    grid.ColWidths[0]:= 120;
    grid.Cells[1,0]:= 'valeur';
    grid.ColWidths[1]:= 300;

    grid.Cells[0,1]:= 'decimalseparator';
    grid.Cells[1,1]:= config.DecimalSeparator;
    grid.Cells[0,2]:= 'shortdateformat';
    grid.Cells[1,2]:= config.shortdateformat;
  end
  else ShowMessage('impossible de lire la configuration : ' + res.response);


end;

procedure TformBaseConfig.WriteScreen;
begin
  UniApplication.Cookies.SetCookie('host', edtHost.Text, 0, True);
  UniApplication.Cookies.SetCookie('port', edtPort.Text, 0, True);
  config.DecimalSeparator:= grid.Cells[1,1];
  config.ShortDateFormat := grid.Cells[1,2];
  MainModule.UniMainModule.tmgetTokenTimer(nil);
  UniMainModule.microService.Service.setConfiguration(UniMainModule.microService.AppID,
                                     ParamToJSon(UniMainModule.microService.global_param),
                                     ConfigToJSon(config));
end;

end.
