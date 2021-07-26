unit module.family;

interface

  uses Winapi.Windows, System.SysUtils, Classes, classebase, Data.Win.ADODB;

type  TModule_Family = class
      private
        qry: TAdoQuery;
        fFamily: TFamily;
        fid: integer;
        fisEmpty: Boolean;
      public
        constructor Create(const id: integer); reintroduce;
        destructor  Destroy; override;
        procedure Read;
        procedure Write;
      published
        property Family: TFamily read fFamily write fFamily;
        property isEmpty: Boolean read fisEmpty write fisEmpty;
      end;

var mFamily: TModule_Family;

implementation

{ TModule_Suppliers }
  uses module, Logs, consts_;

constructor TModule_Family.Create(const id: integer);
begin
  fFamily:= TFamily.Create;
  qry:= module.Donnees.addQuery;
  fid:= id;
end;

destructor TModule_Family.Destroy;
begin
  FreeAndNil(fFamily);
  FreeAndNil(qry);
  inherited;
end;

procedure TModule_Family.Read;
begin
  fIsEmpty:= True;
  qry.SQL.Add('SELECT * FROM Family WHERE id=' + IntToStr(fid));
  try
    qry.Open;
    if qry.RecordCount>0 then
    begin
      fFamily._id         := qry.FieldByName('id').AsInteger;
      fFamily._Label      := qry.FieldByName('Label').AsString;
      fFamily._code       := qry.FieldByName('Code').AsString;
      fFamily._Description:= qry.FieldByName('Description').AsString;
      fIsEmpty:= False;
    end;
    qry.Close;
  except
    on e: Exception do
      Logs.log.AddError('Suppliers.Read', e.Message);
  end;
end;

procedure TModule_Family.Write;
begin
  qry.SQL.Clear;
  if fIsEmpty then
  begin
    qry.SQL.Add('INSERT INTO Family');
    qry.SQL.Add('(Label, Code, Description)');
    qry.SQL.Add('VALUES');
    qry.SQL.Add('(:Label, :Code, :Description)');
  end
  else
  begin
    qry.SQL.Add('UPDATE Family');
    qry.SQL.Add('SET Label=:Label, Code=:Code, Description=:Description');
    qry.SQL.Add('WHERE');
    qry.SQL.Add('id=:id');
    if not fIsEmpty then
      qry.Parameters.ParamByName('id').Value:= fid;
  end;

  qry.Parameters.ParamByName('Code').Value        := fFamily._Code;
  qry.Parameters.ParamByName('Label').Value       := fFamily._Label;
  qry.Parameters.ParamByName('Description').Value := fFamily._Description;

  try
    qry.ExecSQL;
  except
    on e: Exception do
      Logs.log.AddError('Family.Write', e.Message);
  end;
end;

end.
