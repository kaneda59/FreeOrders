unit Logs;

interface

  uses Winapi.Windows, System.SysUtils, System.Classes;

type

   TLogFile = class
   private
     _file : TStringList;
     filenamelog: string;
     function FormatMsg(const info, _typ: string; const msg: string): string;
   public
     constructor Create(const filename: string); reintroduce;
     destructor  Destroy; override;
     procedure AddInfo(const info: string; const msg: string);
     procedure AddWarning(const info: string; const msg: string);
     procedure AddError(const info: string; const msg: string);
   end;

var log: TLogFile;

implementation

  uses consts_;

{ TLogFile }

procedure TLogFile.AddError(const info, msg: string);
begin
  _file.Add(FormatMsg(info, 'error', msg));
  _file.SaveToFile(filenamelog);
end;

procedure TLogFile.AddInfo(const info, msg: string);
begin
  _file.Add(FormatMsg(info, 'info', msg));
  _file.SaveToFile(filenamelog);
end;

procedure TLogFile.AddWarning(const info, msg: string);
begin
  _file.Add(FormatMsg(info, 'warning', msg));
  _file.SaveToFile(filenamelog);
end;

constructor TLogFile.Create(const filename: string);
begin
  _file:= TStringList.Create;
  filenamelog:= filename;
  if FileExists(filename) then
    _file.LoadFromFile(filename)
  else
    _file.Add('@AuBonPLan - logfile créé le ' + FormatDateTime('dd/mm/yyyy  à hh:nn:ss', now));

end;

destructor TLogFile.Destroy;
begin
  _file.SaveToFile(filenamelog);
  FreeAndNil(_file);
  inherited;
end;

function TLogFile.FormatMsg(const info, _typ, msg: string): string;
begin
  result:= Format('[%s] - %s (%s) : %s', [FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', now), _typ, info, msg]);
end;

initialization

   Log:= TLogFile.Create(pathSystem + 'log_' + FormatDateTime('yyyymmdd', date));

finalization

  FreeAndNil(Log);

end.
