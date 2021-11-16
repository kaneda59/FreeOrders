unit consts_;

interface

  uses System.SysUtils, Classes;

const

  // connexio ADO par défaut à une base SQLite
  CNX_SQLITE_STR : string       = 'Provider=MSDASQL.1;Persist Security Info=False;Extended Properties' +
                                   '="Driver={SQLite3 ODBC Driver};Database=[filename];UTF8Encoding=1;' +
                                   'StepAPI=0;SyncPragma=NORMAL;NoTXN=0;Timeout=;ShortNames=0;LongNames=0;' +
                                   'NoCreat=0;NoWCHAR=0;FKSupport=0;JournalMode=;LoadExt=;"';


  // liste des actions
  ACT_LIST_CLIENTS   = 1000;
  ACT_LIST_SUPPLIERS = 1001;
  ACT_LIST_FAMILY    = 1002;
  ACT_LIST_ITEMS     = 1003;
  ACT_ORDERS         = 1004;
  ACT_DELIVERIES     = 1005;
  ACT_CONFIGURATION  = 1006;
  ACT_CLOSE          = 1007;
  ACT_ABOUT          = 1008;
  ACT_LIST_VATS      = 1009;

var

  pathApp   : string = '';
  pathData  : string = '';
  pathSystem: string = '';
  pathTemp  : string = '';

procedure InitPath;

implementation

procedure InitPath;
begin
  pathApp:= ExtractFilePath(ParamStr(0));
  pathData:= pathApp + 'data\'; ForceDirectories(pathData);
  pathTemp:= pathApp + 'temp\'; ForceDirectories(pathTemp);
  pathSystem:= pathApp + 'system\'; ForceDirectories(pathSystem);
end;

initialization

  InitPath;

end.
