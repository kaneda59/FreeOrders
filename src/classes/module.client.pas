unit module.client;

interface

  uses Winapi.Windows, System.SysUtils, Classes, classebase, Data.Win.ADODB;

type  TModule_Client = class
      private
        qry: TAdoQuery;
        fClient: TClient;
        fid: integer;
        fisEmpty: Boolean;
      public
        constructor Create(const id: integer); reintroduce;
        destructor  Destroy; override;
        procedure Read;
        procedure Write;
      published
        property client: TClient  read fClient  write fClient;
        property isEmpty: Boolean read fisEmpty write fisEmpty;
      end;

var mclient: TModule_Client;

implementation

{ TModule_Client }
  uses module, Logs, consts_;

constructor TModule_Client.Create(const id: integer);
begin
  fClient:= TClient.Create;
  qry:= module.Donnees.addQuery;
  fid:= id;
end;

destructor TModule_Client.Destroy;
begin
  FreeAndNil(fClient);
  FreeAndNil(qry);
  inherited;
end;

procedure TModule_Client.Read;
begin
  fIsEmpty:= True;
  qry.SQL.Add('SELECT * FROM CLIENTS WHERE id=' + IntToStr(fid));
  try
    qry.Open;
    if qry.RecordCount>0 then
    begin
      fClient._id        := qry.FieldByName('id').AsInteger;
      fClient._FirstName := qry.FieldByName('firstname').AsString;
      fClient._LastName  := qry.FieldByName('lastname').AsString;
      fClient._Address   := qry.FieldByName('address').AsString;
      fClient._supplement:= qry.FieldByName('supplement').AsString;
      fClient._ZipCode   := qry.FieldByName('ZipCode').AsString;
      fClient._City      := qry.FieldByName('City').AsString;
      fClient._Country   := qry.FieldByName('Country').AsString;
      fClient._Phone     := qry.FieldByName('Phone').AsString;
      fClient._Mobile    := qry.FieldByName('Mobile').AsString;
      fClient._Account   := qry.FieldByName('Account').AsString;
      fClient._mail      := qry.FieldByName('mail').AsString;
      fIsEmpty:= False;
    end;
    qry.Close;
  except
    on e: Exception do
      Logs.log.AddError('Client.Read', e.Message);
  end;
end;

procedure TModule_Client.Write;
begin
  qry.SQL.Clear;
  if fIsEmpty then
  begin
    qry.SQL.Add('INSERT INTO Clients');
    qry.SQL.Add('(firstname, lastname, address, supplement, zipcode, city, country, phone, mobile, account, mail)');
    qry.SQL.Add('VALUES');
    qry.SQL.Add('(:firstname, :lastname, :address, :supplement, :zipcode, :city, :country, :phone, :mobile, :account, :mail)');
  end
  else
  begin
    qry.SQL.Add('UPDATE Clients');
    qry.SQL.Add('SET firstname=:firstname, lastname=:lastname, address=:address, supplement=:supplement, zipcode=:zipcode, city=:city, country=:country, phone=:phone, mobile=:mobile, account=:account, mail=:mail');
    qry.SQL.Add('WHERE');
    qry.SQL.Add('id=:id');
    if not fIsEmpty then
      qry.Parameters.ParamByName('id').Value:= fid;
  end;

  qry.Parameters.ParamByName('firstname').Value := fClient._FirstName;
  qry.Parameters.ParamByName('lastname').Value  := fClient._LastName;
  qry.Parameters.ParamByName('address').Value   := fClient._Address;
  qry.Parameters.ParamByName('supplement').Value:= fClient._supplement;
  qry.Parameters.ParamByName('ZipCode').Value   := fClient._ZipCode;
  qry.Parameters.ParamByName('City').Value      := fClient._City;
  qry.Parameters.ParamByName('Country').Value   := fClient._Country;
  qry.Parameters.ParamByName('Phone').Value     := fClient._Phone;
  qry.Parameters.ParamByName('Mobile').Value    := fClient._Mobile;
  qry.Parameters.ParamByName('Account').Value   := fClient._Account;
  qry.Parameters.ParamByName('mail').Value      := fClient._mail;

  try
    qry.ExecSQL;
  except
    on e: Exception do
      Logs.log.AddError('Client.Write', e.Message);
  end;
end;

end.
