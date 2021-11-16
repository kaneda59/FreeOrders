unit consts;

interface

  uses System.SysUtils, Classes;

const

  // connexio ADO par défaut à une base SQLite
  CNX_SQLITE_STR : string       = 'Provider=MSDASQL.1;Persist Security Info=False;Extended Properties' +
                                   '="Driver={SQLite3 ODBC Driver};Database=[filename];UTF8Encoding=1;' +
                                   'StepAPI=0;SyncPragma=NORMAL;NoTXN=0;Timeout=;ShortNames=0;LongNames=0;' +
                                   'NoCreat=0;NoWCHAR=0;FKSupport=0;JournalMode=;LoadExt=;"';

var

  pathApp: string = '';
  pathData: string = '';
  pathSystem: string = '';

procedure InitPath;

implementation

procedure InitPath;
begin
  pathApp:= ExtractFilePath(ParamStr(0));
  pathData:= pathApp + 'data\'; ForceDirectories(pathData);
  pathSystem:= pathApp + 'system\'; ForceDirectories(pathSystem);
end;

initialization

  InitPath;

end.
