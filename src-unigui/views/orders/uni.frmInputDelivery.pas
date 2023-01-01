unit uni.frmInputDelivery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uni.frmBaseInput, uniButton, uniLabel,
  uniGUIBaseClasses, uniPanel;

type
  TformBaseInput2 = class(TformBaseInput)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function formBaseInput2: TformBaseInput2;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function formBaseInput2: TformBaseInput2;
begin
  Result := TformBaseInput2(UniMainModule.GetFormInstance(TformBaseInput2));
end;

end.
