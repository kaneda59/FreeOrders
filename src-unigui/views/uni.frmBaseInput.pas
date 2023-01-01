unit uni.frmBaseInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uni.frmBase, uniLabel, uniGUIBaseClasses,
  uniPanel, uniButton;

type
  TformBaseInput = class(TformBase)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function formBaseInput: TformBaseInput;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function formBaseInput: TformBaseInput;
begin
  Result := TformBaseInput(UniMainModule.GetFormInstance(TformBaseInput));
end;

end.
