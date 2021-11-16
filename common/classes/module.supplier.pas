unit module.supplier;

{$M+}

interface

  uses Winapi.Windows, System.SysUtils, Classes, classebase, Data.Win.ADODB;

type  TModule_Suppliers = class
      private
        qry: TAdoQuery;
        fSuppliers: TSupplier;
        fid: integer;
        fisEmpty: Boolean;
      public
        constructor Create(const id: integer); reintroduce;
        destructor  Destroy; override;
        procedure Read;
        procedure Write;
        function Delete: Boolean;
      published
        property Supplier: TSupplier read fSuppliers write fSuppliers;
        property isEmpty: Boolean read fisEmpty write fisEmpty;
      end;

var mSupplier: TModule_Suppliers;

implementation

{ TModule_Suppliers }
  uses module, Logs, consts_;

constructor TModule_Suppliers.Create(const id: integer);
begin
  fSuppliers:= TSupplier.Create;
  qry:= module.Donnees.addQuery;
  fid:= id;
  fIsEmpty:= True;
end;

function TModule_Suppliers.Delete: Boolean;
begin
  result:= False;
  qry.Close;
  qry.SQL.Clear;
  qry.SQL.Add('delete from SUPPLIERS WHERE id=' + IntToStr(fid));
  try
    qry.ExecSQL;
    result:= True;
  except
    on e: Exception do
      Logs.log.AddError('suppliers.delete', e.Message);
  end;
end;

destructor TModule_Suppliers.Destroy;
begin
  FreeAndNil(fSuppliers);
  FreeAndNil(qry);
  inherited;
end;

procedure TModule_Suppliers.Read;
begin
  fIsEmpty:= True;
  qry.SQL.Add('SELECT * FROM SUPPLIERS WHERE id=' + IntToStr(fid));
  try
    qry.Open;
    if qry.RecordCount>0 then
    begin
      fSuppliers._id         := qry.FieldByName('id').AsInteger;
      fSuppliers._Label      := qry.FieldByName('Label').AsString;
      fSuppliers._Description:= qry.FieldByName('Description').AsString;
      fSuppliers._Address    := qry.FieldByName('address').AsString;
      fSuppliers._supplement := qry.FieldByName('supplement').AsString;
      fSuppliers._ZipCode    := qry.FieldByName('ZipCode').AsString;
      fSuppliers._City       := qry.FieldByName('City').AsString;
      fSuppliers._Country    := qry.FieldByName('Country').AsString;
      fSuppliers._Phone      := qry.FieldByName('Phone').AsString;
      fSuppliers._Mobile     := qry.FieldByName('Mobile').AsString;
      fSuppliers._Account    := qry.FieldByName('Account').AsString;
      fSuppliers._mail       := qry.FieldByName('mail').AsString;
      fIsEmpty:= False;
    end;
    qry.Close;
  except
    on e: Exception do
      Logs.log.AddError('Suppliers.Read', e.Message);
  end;
end;

procedure TModule_Suppliers.Write;
begin
  qry.SQL.Clear;
  if fIsEmpty then
  begin
    qry.SQL.Add('INSERT INTO SUPPLIERS');
    if fid=0 then
    begin
      qry.SQL.Add('(Label, Description, address, supplement, zipcode, city, country, phone, mobile, account, mail)');
      qry.SQL.Add('VALUES');
      qry.SQL.Add('(:Label, :Description, :address, :supplement, :zipcode, :city, :country, :phone, :mobile, :account, :mail)');
    end
    else
    begin
      qry.SQL.Add('(Id, Label, Description, address, supplement, zipcode, city, country, phone, mobile, account, mail)');
      qry.SQL.Add('VALUES');
      qry.SQL.Add('(:Id, :Label, :Description, :address, :supplement, :zipcode, :city, :country, :phone, :mobile, :account, :mail)');
    end;
  end
  else
  begin
    qry.SQL.Add('UPDATE SUPPLIERS');
    qry.SQL.Add('SET Label=:Label, Description=:Description, address=:address, supplement=:supplement, zipcode=:zipcode, city=:city, country=:country, phone=:phone, mobile=:mobile, account=:account, mail=:mail');
    qry.SQL.Add('WHERE');
    qry.SQL.Add('id=:id');
  end;

  if fid<>0 then
    qry.Parameters.ParamByName('id').Value           := fid;
  qry.Parameters.ParamByName('Label').Value        := fSuppliers._Label;
  qry.Parameters.ParamByName('Description').Value  := fSuppliers._Description;
  qry.Parameters.ParamByName('address').Value      := fSuppliers._Address;
  qry.Parameters.ParamByName('supplement').Value   := fSuppliers._supplement;
  qry.Parameters.ParamByName('ZipCode').Value      := fSuppliers._ZipCode;
  qry.Parameters.ParamByName('City').Value         := fSuppliers._City;
  qry.Parameters.ParamByName('Country').Value      := fSuppliers._Country;
  qry.Parameters.ParamByName('Phone').Value        := fSuppliers._Phone;
  qry.Parameters.ParamByName('Mobile').Value       := fSuppliers._Mobile;
  qry.Parameters.ParamByName('Account').Value      := fSuppliers._Account;
  qry.Parameters.ParamByName('mail').Value         := fSuppliers._mail;

  try
    qry.ExecSQL;
  except
    on e: Exception do
      Logs.log.AddError('Suppliers.Write', e.Message);
  end;
end;

end.
