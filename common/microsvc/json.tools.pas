(*********************************************************
 *      JSON TOOLS Unity (c) 2021 FDEvelopment LTD       *
 *********************************************************
 * developped by : Kaneda                                *
 * date          : 10/2021                               *
 *-------------------------------------------------------*
 * this unit contains all function to manipulate JSon    *
 * sample : convert JSon to XML from reading in dataset  *
 *********************************************************)

unit json.tools;

interface

uses System.SysUtils, Classes, classebase, System.Variants, synCommons, DB,
     consts_, Datasnap.DBClient;


      function ParamToJSon(aClasse: TParamInformation): RawJSON;
      function JSonToParam(AJSonString: RawJSON): TParamInformation;

      function ResultToJSon(aClasse: TResultInformation): RawJSON;
      function JSonToResult(AJSonString: RawJSON): TResultInformation;

      function vatToJSon(aClasse: Tvat): RawJSON;
      function JSonTovat(AJSonString: RawJSON): Tvat;

      function SupplierToJSon(aClasse: TSupplier): RawJSON;
      function JSonToSupplier(AJSonString: RawJSON): TSupplier;

      function FamilyToJSon(aClasse: TFamily): RawJSON;
      function JSonToFamily(AJSonString: RawJSON): TFamily;

      function ItemsToJSon(aClasse: TItems): RawJSON;
      function JSonToItems(AJSonString: RawJSON): TItems;

      function ClientToJSon(aClasse: TClient): RawJSON;
      function JSonToClient(AJSonString: RawJSON): TClient;

      function OrderLineToJSon(aClasse: TOrderLine): RawJSON;
      function JSonToOrderLine(AJSonString: RawJSON): TOrderLine;

      function OrdersToJSon(aClasse: TOrders): RawJSON;
      function JSonToOrders(AJSonString: RawJSON): TOrders;

      function ConfigToJSon(aClasse: TConfiguration_informations): RawJSON;
      function JSonToConfig(AJSonString: RawJSON): TConfiguration_informations;

      function arrayJSONToDataSet(const aJSonString: RawJSON; const className: string): TClientDataSet;
      function isByteOn(N: byte; bit_position: integer):boolean;

implementation

uses typinfo, System.Rtti, Data.DBXJSON;

const TypeNames : array[Low(TTypeKind)..High(TTypeKind)] of string =
    ('unknown', 'integer', 'char', 'enumeration', 'float',
     'string', 'set', 'class', 'method', 'Char', 'string', 'string',
     'variant', 'array', 'record', 'interface', 'integer', 'dynarray', 'string',
     'classref', 'pointer', 'procedure');

function isByteOn(N: byte; bit_position: integer):boolean;
begin
  result := N and (1 shl bit_position) = 1 shl bit_position;
end;

function ParamToJSon(aClasse: TParamInformation): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonToParam(AJSonString: RawJSON): TParamInformation;
var v: Variant;
begin
  result:= TParamInformation.Create;
  v:= _Json(AJSonString);

  Result.id:= v.id;
  Result.token:= v.token;
  Result.information:= v.information;
end;

function ResultToJSon(aClasse: TResultInformation): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonToResult(AJSonString: RawJSON): TResultInformation;
var v: Variant;
begin
  result:= TResultInformation.Create;
  v:= _Json(AJSonString);

  Result.State:= v.State;
  Result.response:= v.response;
end;

function vatToJSon(aClasse: Tvat): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonTovat(AJSonString: RawJSON): Tvat;
var v: Variant;
begin
  result:= Tvat.Create;
  v:= _Json(AJSonString);

  Result._id   := v._id;
  Result._label:= v._label;
  Result._value:= v._value;
end;

function SupplierToJSon(aClasse: TSupplier): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonToSupplier(AJSonString: RawJSON): TSupplier;
var v: Variant;
begin
  result:= TSupplier.Create;
  v:= _Json(AJSonString);

  Result._id   := v._id;
  Result._label:= v._label;
  Result._Description:= v._Description;
  Result._Address:= v._Address;
  Result._supplement:= v._supplement;
  Result._City:= v._City;
  Result._ZipCode:= v._ZipCode;
  Result._Country:= v._Country;
  Result._Phone:= v._Phone;
  Result._Mobile:= v._Mobile;
  Result._Account:= v._Account;
  Result._mail:= v._mail;
end;

function FamilyToJSon(aClasse: TFamily): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonToFamily(AJSonString: RawJSON): TFamily;
var v: Variant;
begin
  result:= TFamily.Create;
  v:= _Json(AJSonString);

  Result._id   := v._id;
  Result._label:= v._label;
  Result._Description:= v._Description;
  Result._code := v._code;
end;

function ItemsToJSon(aClasse: TItems): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonToItems(AJSonString: RawJSON): TItems;
var v: Variant;
begin
  result:= TItems.Create;
  v:= _Json(AJSonString);

  Result._id   := v._id;
  Result._label:= v._label;
  Result._Description:= v._Description;
  Result._code := v._code;
  Result._pvht:= v._pvht;
  Result._paht:= v._paht;
  Result._idvat:= v._idvat;
  Result._actif:= v._actif;
  Result._idfamily:= v._idfamily;
  Result._idSupplier:= v._idSupplier;
end;

function ClientToJSon(aClasse: TClient): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonToClient(AJSonString: RawJSON): TClient;
var v: Variant;
begin
  result:= TClient.Create;
  v:= _Json(AJSonString);

  Result._id   := v._id;
  Result._FirstName:= v._FirstName;
  Result._LastName:= v._LastName;
  Result._Address:= v._Address;
  Result._supplement:= v._supplement;
  Result._ZipCode:= v._ZipCode;
  Result._City:= v._City;
  Result._Country:= v._Country;
  Result._Phone:= v._Phone;
  Result._Mobile:= v._Mobile;
  Result._Account:= v._Account;
  Result._mail:= v._mail;
end;

function OrderLineToJSon(aClasse: TOrderLine): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonToOrderLine(AJSonString: RawJSON): TOrderLine;
var v: Variant;
begin
  result:= TOrderLine.Create;
  v:= _Json(AJSonString);

  Result._id     := v._id;
  Result._orderid:= v._orderid;
  Result._idItems:= v._idItems;
  Result._Qte    := v._Qte;
  Result._MtRem  := v._MtRem;
end;

function OrdersToJSon(aClasse: TOrders): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;

function JSonToOrders(AJSonString: RawJSON): TOrders;
var v: Variant;
    AFormatSettings: TFormatSettings;
begin
  result:= TOrders.Create;
  v:= _Json(AJSonString);

  Result._id        := v._id;
  Result._Code      := v._Code;
  Result._idClient  := v._idClient;
  //'1899-12-30'
  AFormatSettings:= FormatSettings;
  AFormatSettings.ShortDateFormat := 'YYYY-MM-DD';
  AFormatSettings.DateSeparator:= '-';
  AFormatSettings.LongDateFormat:= 'yyyy MMMM d dddd';
  Result._date      := StrToDate(v._date, AFormatSettings);
  Result._stateOrder:= v._stateOrder;
  //Result._Lines     := v._Lines;
end;

function ConfigToJSon(aClasse: TConfiguration_informations): RawJSON;
var vaClasse: Variant;
begin
  vaClasse:= ObjectToVariant(aClasse);
  result:= variantSaveJSon(vaClasse);
end;


function JSonToConfig(AJSonString: RawJSON): TConfiguration_informations;
var v: Variant;
begin
  result:= TConfiguration_informations.Create;
  v:= _Json(AJSonString);

  Result.DecimalSeparator:= v.DecimalSeparator;
  Result.ShortDateFormat := v.ShortDateFormat;
end;

function arrayJSONToDataSet(const aJSonString: RawJSON; const className: string): TClientDataSet;
var xml: TStringList;
    C : TRttiContext;
    O : TObject;

    jso: TJsonObject;
    jsa: TJSONArray;
    jsb: TJSONObject;
    ArrayElement: TJSonValue;
    FoundValue: TJSonValue;

    PT  : PTypeData;
    PI  : PTypeInfo;
    I,J,X : Longint;
    PP  : PPropList;
    prI : PPropInfo;
    vat : TVat;
    Str : string;

    FileName: string;
begin
  result:= TClientDataSet.Create(nil);
  xml:= TStringList.Create;
  FileName:= pathTemp + className + intToStr(GetTickCount64) + '.xml';

  try
    xml.Add('<?xml version="1.0" standalone="yes"?>');
    xml.Add('<DATAPACKET Version="2.0">');
    xml.Add('  <METADATA>');
    xml.Add('    <FIELDS>');

    // parcourt des champs

    O := (C.FindType('classebase.' + className) as TRttiInstanceType).MetaClassType.Create;
    PI  := O.ClassInfo;
    PT  := GetTypeData(PI);
    //Writeln('Total property Count : ',PT^.PropCount);
    GetMem (PP,PT^.PropCount*SizeOf(Pointer));
    J:= GetPropList(PI, PP);
    //Writeln('Ordinal property Count : ',J);
    for I:=0 to J-1 do
    begin
      xml.Add('      <FIELD attrname="'+PP^[i]^.name+'" fieldtype="'+ TypeNames[typinfo.PropType(O, PP^[i]^.Name)]+'"/>');
    end;
    FreeMem(PP);
    FreeAndNil(vat);

    xml.Add('</FIELDS><PARAMS CHANGE_LOG="6 1 8"/>');
    xml.Add('</METADATA>');
    xml.Add('<ROWDATA>');

    // parcourt des valeurs
    jso := TJsonObject.ParseJSONValue(aJSonString) as TJsonObject;
    if jso <> nil then
    begin
      jsa := jso.GetValue('result') as TJSONArray;
      if jsa <> nil then
      begin
        for X := 0 to jsa.Size-1 do
        begin
          jsb:=jsa.Get(X) as TJsonObject;
          if jsb <> nil then
          begin
            str:= '<ROW ';
            for I:=0 to J-1 do
               str := str + PP^[i]^.name + '="' + (jsb.GetValue(PP^[i]^.name)).Value + '" ';
            str:= str + '/>';
            xml.Add(str);
          end;
        end;
      end;
    end;

    xml.Add('</ROWDATA>');
    xml.Add('</DATAPACKET>');

    xml.SaveToFile(FileName);
    Result.loadFromFile(FileName);

  finally
    FreeAndNil(xml);
  end;
end;

end.
