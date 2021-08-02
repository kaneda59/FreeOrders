unit module.orders;

{$M+}

interface

  uses Winapi.Windows, System.SysUtils, Classes, classebase, Data.Win.ADODB;

type  TModule_orders = class
      private
        qry: TAdoQuery;
        fOrders: TOrders;
        fid: integer;
        fisEmpty: Boolean;
      public
        constructor Create(const id: integer); reintroduce;
        destructor  Destroy; override;
        procedure Read;
        procedure Write;
      published
        property Orders: TOrders    read fOrders   write fOrders;
        property isEmpty: Boolean read fisEmpty write fisEmpty;
      end;

var mOrders: TModule_Orders;

implementation

{ TModule_Suppliers }
  uses module, Logs, consts_;

constructor TModule_orders.Create(const id: integer);
begin
  fOrders:= TOrders.Create;
  qry:= module.Donnees.addQuery;
  fid:= id;
end;

destructor TModule_orders.Destroy;
begin
  FreeAndNil(fOrders);
  FreeAndNil(qry);
  inherited;
end;

{
      property _id: integer read FId write FId;
      property _Code: string read FCode write FCode;
      property _idClient: integer read FIdClient write FIdClient;
      property _date: TDateTime read FDate write FDate;
      property _stateOrder: TState read FState write FState;
      property _Lines: TarrayOrderLines read FLines write FLines;

      orderlines
      property _id: integer read FId write FId;
      property _orderid: Integer read ForderId write FOrderId;
      property _idItems: integer read FIdItems write FIdItems;
      property _Qte: double read FQte write FQte;
      property _MtRem: double read FMtRem write FMtRem;
}

procedure TModule_orders.Read;
var Lines: TarrayOrderLines;
begin
  fIsEmpty:= True;
  qry.SQL.Add('SELECT o.id as oid, o.code as ocode, o.idclient as oidclient, o.date as odate, o.stateorder as ostateorder,');
  qry.SQL.Add('       l.id as lid, l.iditems as liditems, l.qte as lqte, l.mtrem as lmtrem');
  qry.SQL.Add('FROM ORDERS o, ORDERLINES l WHERE o.id=' + IntToStr(fid));
  qry.SQL.Add('AND l.orderid=o.id');
  try
    qry.Open;
    if qry.RecordCount>0 then
    begin
      fOrders._id         := qry.FieldByName('oid').AsInteger;
      fOrders._Code       := qry.FieldByName('oCode').AsString;
      fOrders._idClient   := qry.FieldByName('oidclient').AsInteger;
      fOrders._date       := qry.FieldByName('odate').AsDateTime;
      fOrders._stateOrder := TState(qry.FieldByName('ostateorder').AsInteger);

      SetLength(Lines, 0);
      while not qry.Eof do
      begin
        SetLength(Lines, Length(Lines)+1);
        Lines[High(Lines)]:= TOrderLine.Create;
        Lines[High(Lines)]._id     := qry.FieldByName('lid').AsInteger;
        Lines[High(Lines)]._orderid:= qry.FieldByName('oid').AsInteger;
        Lines[High(Lines)]._idItems:= qry.FieldByName('lidItems').AsInteger;
        Lines[High(Lines)]._Qte    := qry.FieldByName('lqte').AsFloat;
        Lines[High(Lines)]._MtRem  := qry.FieldByName('lMtRem').AsFloat;
        qry.Next;
      end;
      fIsEmpty:= False;
    end;
    qry.Close;
    fOrders._Lines:= Lines;
  except
    on e: Exception do
      Logs.log.AddError('orders.Read', e.Message);
  end;
end;

procedure TModule_orders.Write;
var i: integer;
begin
  qry.SQL.Clear;
  if fIsEmpty then
  begin
    qry.SQL.Add('INSERT INTO ORDERS');
    qry.SQL.Add('(code, idclient, date, stateorder)');
    qry.SQL.Add('VALUES');
    qry.SQL.Add('(:code, :idclient, :date, :stateorder)');
  end
  else
  begin
    qry.SQL.Add('UPDATE ORDERS');
    qry.SQL.Add('SET code=:code, idclient=:idclient, date=:date, stateorder=:stateorder');
    qry.SQL.Add('WHERE');
    qry.SQL.Add('id=:id');
    if not fIsEmpty then
      qry.Parameters.ParamByName('id').Value:= fid;
  end;

  qry.Parameters.ParamByName('code').Value       := fOrders._code;
  qry.Parameters.ParamByName('idclient').Value   := fOrders._idclient;
  qry.Parameters.ParamByName('date').Value       := fOrders._date;
  qry.Parameters.ParamByName('stateorder').Value := fOrders._stateOrder;


  try
    qry.ExecSQL;

    if fIsEmpty then
      fOrders._id:= Donnees.getLastId('orders');

    // mise a jour des lignes de commandes
    qry.SQL.Clear;
    if not fIsEmpty then
    begin
      qry.SQL.Add('delete from orderlines where orderid=' + IntToStr(fid));
      try
        qry.ExecSQL;
      except
        on e: Exception do
           Logs.log.AddError('orders.Write - delete lines', e.Message);
      end;
    end;

    qry.SQL.Clear;
    qry.SQL.Add('INSERT INTO ORDERLINES');
    qry.SQL.Add('(orderid, iditems, qte, MtRem)');
    qry.SQL.Add('VALUES');
    qry.SQL.Add('(:orderid, :iditems, :qte, :MtRem)');

    for i := Low(fOrders._Lines) to High(fOrders._Lines) do
    begin
      qry.Parameters.ParamByName('orderid').Value  := fOrders._id;
      qry.Parameters.ParamByName('iditems').Value  := fOrders._Lines[i]._iditems;
      qry.Parameters.ParamByName('qte').Value      := fOrders._Lines[i]._qte;
      qry.Parameters.ParamByName('MtRem').Value    := fOrders._Lines[i]._MtRem;

      try
        qry.ExecSQL;
      except
        on e: Exception do
           Logs.log.AddError('orders.Write - insert line ['+intToStr(i)+']', e.Message);
      end;
    end;

  except
    on e: Exception do
      Logs.log.AddError('orders.Write', e.Message);
  end;
end;

end.
