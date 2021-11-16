(*********************************************************
 *      JSON TOOLS Unity (c) 2021 FDEvelopment LTD       *
 *********************************************************
 * developped by : Kaneda                                *
 * date          : 10/2021                               *
 *-------------------------------------------------------*
 * this unit contains all function to manipulate JSon    *
 * sample : convert JSon to XML from reading in dataset  *
 *********************************************************)
unit JSonTools;

interface

  uses  System.SysUtils, System.Classes, SynCommons, mORMot, Data.DBXJSON, ;

(*

  [{"Name":"ABC", "Mobile":"1234", "City":"IN"},
   {"Name":"PQR", "Mobile":"5678", "City":"IN"},
   {"Name":"AAA", "Mobile":"7894", "City":"IN"},
   {"Name":"MNQ", "Mobile":"4569", "City":"IN"},
   {"Name":"ABC", "Mobile":"45685", "City":"IN"}]


<?xml version="1.0" standalone="yes"?>
<DATAPACKET Version="2.0">
<METADATA>
<FIELDS>
<FIELD attrname="Name" fieldtype="string" WIDTH="50"/>
<FIELD attrname="Mobile" fieldtype="string" WIDTH="20"/>
<FIELD attrname="City" fieldtype="string" WIDTH="20"/>
</FIELDS><PARAMS CHANGE_LOG="6 1 8"/>
</METADATA>
<ROWDATA>
<ROW Name="ABC" Mobile="1234" City="IN"/>
<ROW Name="PQR" Mobile="5678" City="IN"/>
<ROW Name="AAA" Mobile="7894" City="IN"/>
<ROW Name="MNO" Mobile="4569" City="IN"/>
<ROW Name="ABC" Mobile="45685" City="IN"/>
</ROWDATA>
</DATAPACKET>
*)

function JSONToXMLDataSet(const aJSonString: RawJSON): string;

implementation


constructor TJSONTOXML.Create(AOwner: TComponent; ALogLevel: Integer);
begin
   inherited Create(AOwner);
   FLogLevel := ALogLevel;
   Self.BuildDOM  := false;
   Self.OnStartElement := InterceptJSONStartElement;
   Self.OnEndElement   := InterceptJSONEndElement;
   Self.OnCharacters   := InterceptCharacters;
   FXML := TipwXML.Create(nil);
end;

procedure TJSONTOXML.InterceptJSONEndElement(Sender: TObject; const Element: string);
begin
   if Element = '' then  // End of array
   begin
      if FLogLevel > 2 then ShowLogLine('JSON parse EndElement - Array');
      FXML.EndElement;
   end
   else
   begin
      if FLogLevel > 2 then ShowLogLine('JSON parse EndElement - Element: ' + Element);
      FXML.EndElement;
   end;
end;

procedure TJSONTOXML.InterceptJSONStartElement(Sender: TObject; const Element: string);
begin
   if Element = '' then  // Start of array
   begin
      if FLogLevel > 2 then ShowLogLine('JSON parse StartElement - Array');
      FXML.StartElement('ARRAY','');
   end
   else
   begin
      if FLogLevel > 2 then ShowLogLine('JSON parse StartElement - Element: ' + Element);
      FXML.StartElement(Uppercase(Element),'');
   end;
end;

procedure TJSONTOXML.ShowLogLine(AMsg: String);
// Use WM_COPYDATA to send log info to form
var CopyDataStruct: TCopyDataStruct;
begin
  CopyDataStruct.dwData := 0;
  CopyDataStruct.cbData := 2 + 2 * Length(AMsg);
  CopyDataStruct.lpData := PChar(AMsg);
  SendMessage((Owner as TForm).Handle, WM_COPYDATA, (Owner as TForm).Handle, lParam(@CopyDataStruct));
end;

function TJSONTOXML.GetXML: String;
begin
   FXML.EndElement;
   Result := FXML.OutputData;
end;

procedure TJSONTOXML.InterceptCharacters(Sender: TObject; const Text: string);
var lText: String;
begin
   // Always surrounded by quotes, remove:
   lText := StripQuotes(Text);
   if FLogLevel > 2 then ShowLogLine('JSON parse characters: ' + lText);
   FXML.PutString(lText);
end;

function JSONToXMLDataSet(const aJSonString: RawJSON): string;
var xml: TStringList;
    JSONValue, jv: TJSONValue;
    JSONArray: TJSONArray;
    jo: TJSONObject;
    pair: TJSONPair;

    tab : Array_JSon_Info;
    i: integer;
    Fields: TStringList;
begin
  xml:= TStringList.Create;
  Fields:= TStringList.Create;

  tab:= ParseJSon(aJSonString);

  try
    xml.Add('<?xml version="1.0" standalone="yes"?>');
    xml.Add('<DATAPACKET Version="2.0">');
    xml.Add('<METADATA>');
    xml.Add('<FIELDS>');

    // parcourt des champs
    for i := Low(tab) to High(tab) do
    begin
      if Fields.IndexOf(tab[i].FieldName)<0 then
      begin
        xml.Add('<FIELD attrname="'+tab[i].FieldName+'" fieldtype="string"/>');
        Fields.Add(tab[i].FieldName);
      end;
    end;

    xml.Add('</FIELDS><PARAMS CHANGE_LOG="6 1 8"/>');
    xml.Add('</METADATA>');
    xml.Add('<ROWDATA>');

    // parcourt des valeurs

    xml.Add('</ROWDATA>');
    xml.Add('</DATAPACKET>');
  finally
    FreeAndNil(xml);
  end;
end;

end.
