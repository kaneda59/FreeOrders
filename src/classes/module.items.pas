unit module.items;

interface

  uses Winapi.Windows, System.SysUtils, Classes, classebase, Data.Win.ADODB;

type  TModule_items = class
      private
        qry: TAdoQuery;
        fItems: TItems;
        fid: integer;
        fisEmpty: Boolean;
      public
        constructor Create(const id: integer); reintroduce;
        destructor  Destroy; override;
        procedure Read;
        procedure Write;
      published
        property Items: TItems    read fItems   write fItems;
        property isEmpty: Boolean read fisEmpty write fisEmpty;
      end;

var mItems: TModule_Items;

implementation

{ TModule_Suppliers }
  uses module, Logs, consts_;

constructor TModule_items.Create(const id: integer);
begin
  fItems:= TItems.Create;
  qry:= module.Donnees.addQuery;
  fid:= id;
end;

destructor TModule_items.Destroy;
begin
  FreeAndNil(fItems);
  FreeAndNil(qry);
  inherited;
end;

procedure TModule_items.Read;
begin
  fIsEmpty:= True;
  qry.SQL.Add('SELECT * FROM ITEMS WHERE id=' + IntToStr(fid));
  try
    qry.Open;
    if qry.RecordCount>0 then
    begin
      fItems._id         := qry.FieldByName('id').AsInteger;
      fItems._Label      := qry.FieldByName('Label').AsString;
      fItems._description:= qry.FieldByName('Description').AsString;
      fItems._pvht       := qry.FieldByName('pvht').AsFloat;
      fItems._paht       := qry.FieldByName('paht').AsFloat;
      fItems._Code       := qry.FieldByName('Code').AsString;
      fItems._idvat      := qry.FieldByName('idvat').AsInteger;
      fItems._actif      := qry.FieldByName('actif').AsBoolean;
      fItems._idfamily   := qry.FieldByName('idfamily').AsInteger;
      fItems._idSupplier := qry.FieldByName('idSupplier').AsInteger;
      fIsEmpty:= False;
    end;
    qry.Close;
  except
    on e: Exception do
      Logs.log.AddError('Suppliers.Read', e.Message);
  end;
end;

procedure TModule_items.Write;
begin
  qry.SQL.Clear;
  if fIsEmpty then
  begin
    qry.SQL.Add('INSERT INTO ITEMS');
    qry.SQL.Add('(Label, Description, pvht, paht, Code, idvat, actif, idfamily, idsupplier)');
    qry.SQL.Add('VALUES');
    qry.SQL.Add('(:Label, :Description, :pvht, :paht, :Code, :idvat, :actif, :idfamily, :idsupplier)');
  end
  else
  begin
    qry.SQL.Add('UPDATE ITEMS');
    qry.SQL.Add('SET Label=:Label, Description=:Description, pvht=:pvht, paht=:paht, Code=:Code, idvat=:idvat, actif=:actif, idfamily=:idfamily, idSupplier=:idSupplier');
    qry.SQL.Add('WHERE');
    qry.SQL.Add('id=:id');
    if not fIsEmpty then
      qry.Parameters.ParamByName('id').Value:= fid;
  end;

  qry.Parameters.ParamByName('Label').Value       := fItems._Label;
  qry.Parameters.ParamByName('Description').Value := fItems._Description;
  qry.Parameters.ParamByName('pvht').Value        := fItems._pvht;
  qry.Parameters.ParamByName('paht').Value        := fItems._paht;
  qry.Parameters.ParamByName('code').Value        := fItems._Code;
  qry.Parameters.ParamByName('idvat').Value       := fItems._idvat;
  qry.Parameters.ParamByName('actif').Value       := fItems._actif;
  qry.Parameters.ParamByName('idfamily').Value    := fItems._idfamily;
  qry.Parameters.ParamByName('idsupplier').Value  := fItems._idSupplier;

  try
    qry.ExecSQL;
  except
    on e: Exception do
      Logs.log.AddError('Items.Write', e.Message);
  end;
end;
end.
