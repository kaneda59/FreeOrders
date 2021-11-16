unit module.vat;

{$M+}

interface

  uses Winapi.Windows, System.SysUtils, Classes, classebase, Data.Win.ADODB;

type  TModule_Vat = class
      private
        qry: TAdoQuery;
        fVat: TVat;
        fid: integer;
        fisEmpty: Boolean;
      public
        constructor Create(const id: integer); reintroduce;
        destructor  Destroy; override;
        procedure Read;
        procedure Write;
        function delete: Boolean;
      published
        property Vat: TVat read fVat write fVat;
        property isEmpty: Boolean read fisEmpty write fisEmpty;
      end;

var mVat: TModule_Vat;

implementation

{ TModule_Suppliers }
  uses module, Logs, consts_;

constructor TModule_Vat.Create(const id: integer);
begin
  fVat:= TVat.Create;
  qry:= module.Donnees.addQuery;
  fIsEmpty:= True;
  fid:= id;
end;

function TModule_Vat.delete: Boolean;
begin
  result:= False;
  qry.Close;
  qry.SQL.Clear;
  qry.SQL.Add('delete from VATS WHERE id=' + IntToStr(fid));
  try
    qry.ExecSQL;
    result:= True;
  except
    on e: Exception do
      Logs.log.AddError('vats.delete', e.Message);
  end;
end;

destructor TModule_Vat.Destroy;
begin
  FreeAndNil(fVat);
  FreeAndNil(qry);
  inherited;
end;

procedure TModule_Vat.Read;
begin
  fIsEmpty:= True;
  qry.Close;
  qry.SQL.Clear;
  qry.SQL.Add('SELECT * FROM VATS WHERE id=' + IntToStr(fid));
  try
    qry.Open;
    if qry.RecordCount>0 then
    begin
      fVat._id         := qry.FieldByName('id').AsInteger;
      fVat._Label      := qry.FieldByName('Label').AsString;
      fVat._value      := qry.FieldByName('Value').AsFloat;
      fIsEmpty:= False;
    end;
    qry.Close;
  except
    on e: Exception do
      Logs.log.AddError('vats.Read', e.Message);
  end;
end;

procedure TModule_Vat.Write;
begin
  qry.Close;
  qry.SQL.Clear;
  if fIsEmpty then
  begin
    qry.SQL.Add('INSERT INTO VATS');
    if fid=0 then
    begin
      qry.SQL.Add('(Label, Value)');
      qry.SQL.Add('VALUES');
      qry.SQL.Add('(:Label, :Value)');
    end
    else
    begin
      qry.SQL.Add('(id, Label, Value)');
      qry.SQL.Add('VALUES');
      qry.SQL.Add('(:id, :Label, :Value)');
    end;
  end
  else
  begin
    qry.SQL.Add('UPDATE VATS');
    qry.SQL.Add('SET Label=:Label, Value=:Value');
    qry.SQL.Add('WHERE');
    qry.SQL.Add('id=:id');
  end;

  if fId<>0 then
    qry.Parameters.ParamByName('id').Value:= fid;
  qry.Parameters.ParamByName('Label').Value  := fVat._Label;
  qry.Parameters.ParamByName('Value').Value  := fVat._Value;

  try
    qry.ExecSQL;
  except
    on e: Exception do
      Logs.log.AddError('Vats.Write', e.Message);
  end;
end;

end.
