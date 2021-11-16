unit Tools;

interface

  uses Windows, System.SysUtils, Classes, variants;


function BoolToStr(const cond: Boolean; const sTrue, sFalse: string): string;
function BoolToInt(const cond: Boolean; const iTrue, iFalse: integer): integer;
function BoolToFloat(const cond: Boolean; const fTrue, fFalse: Double): Double;

function varToStr(const value: variant; const default: string='') : string;
function varToInt(const value: variant; const default: Integer=0) : integer;
function varToFloat(const value: variant; const default: double=0.0): double;

implementation

function BoolToStr(const cond: Boolean; const sTrue, sFalse: string): string;
begin
  if cond then result:= sTrue
          else result:= sFalse;
end;

function BoolToInt(const cond: Boolean; const iTrue, iFalse: integer): integer;
begin
  if cond then result:= iTrue
          else result:= iFalse;
end;

function BoolToFloat(const cond: Boolean; const fTrue, fFalse: Double): Double;
begin
  if cond then result:= fTrue
          else result:= fFalse;
end;

function varToStr(const value: variant; const default: string='') : string;
begin
  if not VarIsNull(value) then result:= variants.VarToStr(value)
                          else result:= default;
end;

function varToInt(const value: variant; const default: Integer=0) : integer;
var err: integer;
begin
  val(varToStr(value, IntToStr(default)), result, err);
  if err<>0 then
    result:= default;
end;

function varToFloat(const value: variant; const default: double=0.0): double;
var err: integer;
begin
  val(varToStr(value, FloatToStr(default)), result, err);
  if err<>0 then
    result:= default;
end;

end.
