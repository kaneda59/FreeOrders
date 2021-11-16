unit implmsvc.tools;

interface

  uses Windows, System.SysUtils, module, SynCommons;

  function isTokenValid(const AppId: string; tokenValue: RawUTF8): Boolean;
  function getdbToken(const AppID: string): RawUTF8;
  function isAppExists(const AppId: string): Boolean;
  function FillGuid(const AppId: string): string;

implementation

  uses Logs;

function FillGuid(const AppId: string): string;
var
  newGUID: TGUID;
begin
  CreateGUID(newGUID);
  Result := GUIDToString(newGUID);
  with Donnees.addQuery do
  try
    SQL.Add('INSERT INTO tokens');
    SQL.Add('(appID, token, date_create)');
    SQL.Add('VALUES');
    SQL.Add('(' + QuotedStr(AppId) + ',' + QuotedStr(result) + ',' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', now)) + ')');
    try
      ExecSQL;
    Except
      on e: Exception do
      begin
        result:= 'msg : ' + e.Message;
      end;
    end;
  finally
    Free;
  end;
end;

function isAppExists(const AppId: string): Boolean;
begin
  result:= False;
  with Donnees.addQuery do
  try
    SQL.Add('SELECT * FROM applications WHERE APPID=' + QuotedStr(AppId));
    Open;
    result:= RecordCount>0;
    Close;
  finally
    Free;
  end;
end;

function isTokenValid(const AppId: string; tokenValue: RawUTF8): Boolean;
var end_date: TDateTime;
begin
  outputdebugstring(pchar('AppId = ' + AppId + ', token : '+ tokenValue));
  Result:= False;
  with Donnees.addQuery do
  try
    SQL.Add('SELECT * FROM tokens WHERE APPID=' + QuotedStr(AppId));
    SQL.Add('AND token=' + QuotedStr(tokenValue));
    Open;
    if RecordCount>0 then
    begin
      end_date:= FieldByName('date_create').AsDateTime + EncodeTime(1,0,0,0);
      if end_date>Now then
        result:= True;
    end;
    Close;
  finally
    Free;
  end;
end;

function getdbToken(const AppID: string): RawUTF8;
begin
  Result:= '';
  with Donnees.addQuery do
  try
    SQL.Add('SELECT * FROM tokens WHERE APPID=' + QuotedStr(AppId));
    SQL.Add('AND date_create>' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now-EncodeTime(1,0,0,0))));
    Open;
    if RecordCount>0 then
      Result := '{"information":"' + FieldByName('token').AsString + '"}';
    Close;
  finally
    Free;
  end;
end;

end.
