unit configuration;

{$M+}

interface

  uses Winapi.Windows, classes, System.SysUtils, Xml.XMLDoc, Xml.XMLIntf, System.Variants;

type

  TConnection = record
    connectionstring: string;
    parameters: TStringList;
    function fillConnectionString: string;
  end;

  TConnection_Server = record
    host: AnsiString;
    port: AnsiString;
    appid: AnsiString;
  end;

  TConfiguration = class
  private
    Document   : IXMLDocument;
    ffilename  : string;
    fConnection: TConnection;
    fSettingFormat: TStringList;
    fConnection_Server: TConnection_Server;
    procedure readconfiguration;
    procedure writeconfiguration;
    procedure generatedefaultfile;
    procedure fillConfiguration;
  public
    constructor create(const filename: string); reintroduce;
    destructor  Destroy; override;
    property connection       : TConnection        read fConnection        write fConnection;
    property connection_server: TConnection_Server read fConnection_Server write fConnection_Server;
    property settingFormat    : TStringList        read fSettingFormat     write fSettingFormat;
  end;

var configfile: TConfiguration = nil;

implementation

  uses logs, consts_, Winapi.ActiveX;

function ConvertXMLData(const value: string): string;
begin
  result:= stringReplace(value,  '&', '&amp;', [rfReplaceAll]);
  result:= StringReplace(result, '<', '&lt;', [rfReplaceAll]);
  result:= StringReplace(result, '>', '&gt;', [rfReplaceAll]);
end;

{ TConfiguration }

constructor TConfiguration.create(const filename: string);
begin
   inherited create;
   ffilename:= filename;
   readConfiguration;
end;

destructor TConfiguration.Destroy;
begin
  writeconfiguration;
  FreeAndNil(fConnection.parameters);
  FreeAndNil(fSettingFormat);
  Document:= nil;
  inherited;
end;

procedure TConfiguration.generatedefaultfile;
begin
  with TStringList.Create do
  try
    Add('<?xml version="1.0" encoding="UTF-8"?>');
    Add('<configuration>');
    Add('<connection filename="' + convertXMLData(pathData + ChangeFileExt(ExtractFileName(ParamStr(0)), '.db')) + '">' + CNX_SQLITE_STR + '</connection>');
    Add('<settingformat decimalseparator="." shortdateformat="dd/mm/yyyy"/>');
    Add('<connection_server host="127.0.0.1" port="3000" appid="FBA76CA3-6438-4CDD-BB51-344C27B0CD69"/>');
    Add('</configuration>');
    SaveToFile(ffilename);
  finally
    Free;
  end;
end;

procedure TConfiguration.fillConfiguration;
begin
  fConnection.connectionstring:= CNX_SQLITE_STR;
  fConnection.parameters:= TStringList.Create;
  fConnection.parameters.Add('filename=' + pathData + ChangeFileExt(ExtractFileName(ParamStr(0)), '.db'));
  fSettingFormat:= TStringList.Create;
  fSettingFormat.Add('decimalseparator=.');
  fSettingFormat.Add('shotdateformat=dd/mm/yyyy');
end;

procedure TConfiguration.readconfiguration;
var ndroot      : IXMLNode;
    ndconnection: IXMLNode;
    ndConnection_server: IXMLNode;
    ndSetting   : IXMLNode;
    i           : Integer;
begin
  coInitialize(nil);
  FillConfiguration;
  document:= TXMLDocument.Create(nil);
  if not fileExists(ffilename) then generatedefaultfile;
  Document.Active:= True;
  Document.LoadFromFile(ffilename);
  if Document.Active then
  begin
    ndRoot:= Document.ChildNodes.FindNode('configuration');
    if Assigned(ndroot) then
    begin
      ndConnection:= ndroot.ChildNodes.FindNode('connection');
      if assigned(ndconnection) then
      begin
        fConnection.connectionstring:= VarToStr(ndconnection.NodeValue);
        if ndconnection.AttributeNodes.Count>0 then
          fConnection.parameters.Clear;
        for i := 0 to ndconnection.AttributeNodes.Count-1 do
          fConnection.parameters.Add(ndconnection.AttributeNodes[i].NodeName + '=' + varToStr(ndconnection.AttributeNodes[i].NodeValue));
      end;

      ndSetting:= ndroot.ChildNodes.FindNode('settingformat');
      if Assigned(ndSetting) then
      begin
        if ndSetting.AttributeNodes.Count>0 then
          fSettingFormat.Clear;
        for i := 0 to ndSetting.AttributeNodes.Count-1 do
          fSettingFormat.Add(ndSetting.AttributeNodes[i].NodeName + '=' + varToStr(ndSetting.AttributeNodes[i].NodeValue));
      end;

      ndConnection_server:= ndroot.ChildNodes.FindNode('server');
      if Assigned(ndConnection_server) then
      begin
        fConnection_Server.host := VarToStr(ndConnection_server.Attributes['host']);
        fConnection_Server.port := VarToStr(ndConnection_server.Attributes['port']);
        fConnection_Server.appid:= varToStr(ndConnection_server.Attributes['appid']);
      end
      else
      begin
        fConnection_Server.host := '127.0.0.1';
        fConnection_Server.port := '3000';
        fConnection_Server.appid:= 'FBA76CA3-6438-4CDD-BB51-344C27B0CD69'; // key demo
      end;
    end;
  end;
end;

procedure TConfiguration.writeconfiguration;
var ndroot        : IXMLNode;
    ndconnection  : IXMLNode;
    ndConnection_server: IXMLNode;
    atparamconnect: IXMLNode;
    ndSetting     : IXMLNode;
    i             : Integer;
begin
  if fileexists(ffilename) then
    copyfile(Pchar(ffilename), Pchar(ChangeFileExt(ffilename, '.old')), False);
  ndRoot:= Document.ChildNodes.FindNode('configuration');
  if not Assigned(ndroot) then
    ndRoot:= Document.AddChild('configuration');

  ndConnection:= ndroot.ChildNodes.FindNode('connection');
  if not assigned(ndconnection) then
    ndConnection:= ndroot.AddChild('connection');


  ndconnection.NodeValue:= fConnection.connectionstring;
  ndconnection.AttributeNodes.Clear;
  for i := 0 to fConnection.parameters.Count-1 do
    ndconnection.Attributes[fConnection.parameters.Names[i]]:= fConnection.parameters.Values[fConnection.parameters.Names[i]];


  ndSetting:= ndroot.ChildNodes.FindNode('settingformat');
  if not Assigned(ndSetting) then
    ndSetting:= ndroot.AddChild('settingformat');
  ndSetting.AttributeNodes.Clear;

  for i := 0 to fSettingFormat.Count-1 do
    ndSetting.Attributes[fSettingFormat.Names[i]]:= fSettingFormat.Values[fSettingFormat.Names[i]];

  ndConnection_server:= ndroot.ChildNodes.FindNode('server');
  if not Assigned(ndConnection_server) then
    ndconnection_Server:= ndroot.AddChild('server');

  ndConnection_server.Attributes['host'] := fConnection_Server.host;
  ndConnection_server.Attributes['port'] := fConnection_Server.port;
  ndConnection_server.Attributes['appid']:= fConnection_Server.appid;

  Document.SaveToFile(ffilename);

  CoUninitialize;
end;

{ TConnection }

function TConnection.fillConnectionString: string;
var i: Integer;
begin
  assert(assigned(parameters), 'liste des paramètres non initialisé');
  result:= connectionstring;
  for i := 0 to parameters.Count-1 do
    result:= stringReplace(result, '[' + Parameters.Names[i] + ']', parameters.Values[Parameters.Names[i]], [rfReplaceAll]);
end;

initialization

  configfile := TConfiguration.create(pathSystem + 'freeorders.config.xml');

finalization

  FreeAndNil(configfile);

end.
