unit uni.frmBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniLabel, uniGUIBaseClasses, uniPanel, uniButton;

type
  TOnResultOK = procedure (Sender: TObject; const id: integer) of object;
  TformBase = class(TUniForm)
    pnlHeader: TUniPanel;
    UniLabel1: TUniLabel;
    lblOrder : TUniLabel;
    lblTitle : TUniLabel;
    pnlBottom: TUniPanel;
    btnValid: TUniButton;
    btnCancel: TUniButton;
  private
    FOnResultOK: TOnResultOK;
    { Private declarations }
    function getTitleForm: string;
    procedure setTitleForm(const Value: string);
  public
    { Public declarations }
    property TitleForm: string read getTitleForm write setTitleForm;
    property OnResultOK: TOnResultOK read FOnResultOK write FOnResultOK;
  end;

function formBase: TformBase;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function formBase: TformBase;
begin
  Result := TformBase(UniMainModule.GetFormInstance(TformBase));
end;

{ TformBase }

function TformBase.getTitleForm: string;
begin
  result:= lblTitle.Caption;
end;

procedure TformBase.setTitleForm(const Value: string);
begin
  lblTitle.Caption:= Value;
  Caption:= '';
end;

end.
