unit uni.frmInputOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, uni.frmBase,
  uniGUIClasses, uniGUIForm, uni.frmBaseInput, uniButton, uniLabel,
  uniGUIBaseClasses, uniPanel, uniEdit, uniGroupBox, uniBasicGrid, uniStringGrid;

type
  TformInputOrders = class(TformBaseInput)
    UniContainerPanel1: TUniContainerPanel;
    UniPanel1: TUniPanel;
    pnlHeader1: TUniPanel;
    grid: TUniStringGrid;
    pnlHeader2: TUniPanel;
    grpHeader: TUniGroupBox;
    edtCode: TUniEdit;
    edtClient: TUniEdit;
    lbState: TUniLabel;
    lblDate: TUniLabel;
    btnClient: TUniButton;
    grpItems: TUniGroupBox;
    edtItem: TUniEdit;
    btnSearchItem: TUniButton;
    edtQte: TUniEdit;
    edtRemise: TUniEdit;
    btnAdd: TUniButton;
    btnupdate: TUniButton;
    btnDelete: TUniButton;
    edtTotal: TUniEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure Execute(const OderId: integer; ResultOK : TOnResultOK);
  end;

function formInputOrders: TformInputOrders;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function formInputOrders: TformInputOrders;
begin
  Result := TformInputOrders(UniMainModule.GetFormInstance(TformInputOrders));
end;

{ TformBaseInput1 }

class procedure TformInputOrders.Execute(const OderId: integer; ResultOK : TOnResultOK);
begin
  formInputOrders.TitleForm:= 'Commande';
 // formInputOrders.WriteScreen(id);
  formInputOrders.ShowModal(
  Procedure(Sender: TComponent; Result:Integer)
  begin
    if Result=mrOk then
    begin
//      formInputOrders.ReadScreen(id);
      Sleep(1000);
      if Assigned(formInputOrders.OnResultOK) then
      begin
        formInputOrders.OnResultOK(Sender, OderId);
      end;
    end;
  end)
end;

end.
