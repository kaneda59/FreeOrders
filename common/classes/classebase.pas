unit classebase;

interface

uses windows, System.SysUtils, System.Classes, SynCommons, mORMot;

type

     TParamInformation = class(TPersistentWithCustomCreate)
     private
       Fid: integer;
       ftoken: RAWUTF8;
       finformation: RawUTF8;
     published
       property id: integer read fId write FId;
       property token: RAWUTF8 read ftoken write ftoken;
       property information: RawUTF8 read finformation write finformation;
     end;

     TResultInformation = class(TPersistentWithCustomCreate)
     private
       fResponse: RawUTF8;
       fState: RawUTF8;
     published
       property State: RawUTF8 read fState write fState;
       property response: RawUTF8 read fResponse write fResponse;
     end;

    // TVA
    Tvat = class(TPersistentWithCustomCreate)
    private
      FId: integer;
      FValue: double;
      FLabel: RAWUTF8;
    published
      property _id: integer read FId write FId;
      property _label: RAWUTF8 read FLabel write FLabel;
      property _value: double read FValue write FValue;
    end;

    // fournisseur
    TSupplier = class(TPersistentWithCustomCreate)
    private
      FPhone: RAWUTF8;
      FSupplement: RAWUTF8;
      FId: integer;
      FZipCode: RAWUTF8;
      FCountry: RAWUTF8;
      FDescription: RAWUTF8;
      FMail: RAWUTF8;
      FCity: RAWUTF8;
      FAddress: RAWUTF8;
      FAccount: RAWUTF8;
      FMobile: RAWUTF8;
      FLabel: RAWUTF8;
    published
      property _id: integer read FId write FId;
      property _Label: RAWUTF8 read FLabel write FLabel;
      property _Description: RAWUTF8 read FDescription write FDescription;
      property _Address: RAWUTF8 read FAddress write FAddress;
      property _supplement: RAWUTF8 read FSupplement write FSupplement;
      property _ZipCode: RAWUTF8 read FZipCode write FZipCode;
      property _City: RAWUTF8 read FCity write FCity;
      property _Country: RAWUTF8 read FCountry write FCountry;
      property _Phone: RAWUTF8 read FPhone write FPhone;
      property _Mobile: RAWUTF8 read FMobile write FMobile;
      property _Account: RAWUTF8 read FAccount write FAccount;
      property _mail: RAWUTF8 read FMail write FMail;
    end;

    // Famille de produit
    TFamily = class(TPersistentWithCustomCreate)
    private
      Fid: integer;
      FDescription: RAWUTF8;
      FLabel: RAWUTF8;
      FCode: RAWUTF8;
    published
      property _id: integer read Fid write Fid;
      property _code: RAWUTF8 read FCode write FCode;
      property _Label: RAWUTF8 read FLabel write FLabel;
      property _Description: RAWUTF8 read FDescription write FDescription;
    end;

    // produit
    TItems = class(TPersistentWithCustomCreate)
    private
      Fid: integer;
      FidTVA: Integer;
      Fpvht: double;
      FDescription: RAWUTF8;
      FActif: Boolean;
      Fpaht: double;
      FIdSupplier: integer;
      FIdFamily: integer;
      FLabel: RAWUTF8;
      FCode: RAWUTF8;
    published
      property _id: integer read Fid write Fid;
      property _Code: RAWUTF8 read FCode write FCode;
      property _Label: RAWUTF8 read FLabel write FLabel;
      property _description: RAWUTF8 read FDescription write FDescription;
      property _pvht : double read Fpvht write Fpvht;  // prix de vente ht
      property _paht : double read Fpaht write Fpaht;  // prix d'achat  ht
      property _idvat: Integer read FidTVA write FidTVA;
      property _actif: Boolean read FActif write FActif;
      property _idfamily: integer read FIdFamily write FIdFamily;
      property _idSupplier: integer read FIdSupplier write FIdSupplier;
    end;

    // client
    TClient = class(TPersistentWithCustomCreate)
    private
      FPhone: RAWUTF8;
      FSupplement: RAWUTF8;
      FId: integer;
      FZipCode: RAWUTF8;
      FCountry: RAWUTF8;
      FMail: RAWUTF8;
      FCity: RAWUTF8;
      FAddress: RAWUTF8;
      FFirstName: RAWUTF8;
      FAccount: RAWUTF8;
      FLastName: RAWUTF8;
      FMobile: RAWUTF8;
    published
      property _id: integer read FId write FId;
      property _FirstName : RAWUTF8 read FFirstName write FFirstName;
      property _LastName: RAWUTF8 read FLastName write FLastName;
      property _Address: RAWUTF8 read FAddress write FAddress;
      property _supplement: RAWUTF8 read FSupplement write FSupplement;
      property _ZipCode: RAWUTF8 read FZipCode write FZipCode;
      property _City: RAWUTF8 read FCity write FCity;
      property _Country: RAWUTF8 read FCountry write FCountry;
      property _Phone: RAWUTF8 read FPhone write FPhone;
      property _Mobile: RAWUTF8 read FMobile write FMobile;
      property _Account: RAWUTF8 read FAccount write FAccount;
      property _mail: RAWUTF8 read FMail write FMail;
    end;

    // Ligne de commandes
    TOrderLine = class(TPersistentWithCustomCreate)
    private
      FMtRem: double;
      FId: integer;
      FIdItems: integer;
      FQte: double;
      ForderId: Integer;
    published
      property _id: integer read FId write FId;
      property _orderid: Integer read ForderId write FOrderId;
      property _idItems: integer read FIdItems write FIdItems;
      property _Qte: double read FQte write FQte;
      property _MtRem: double read FMtRem write FMtRem;
    end;
    TarrayOrderLines = array of TOrderLine;

    // état des commandes (en préparation, expédiée, en cours de livraison, livrée)
    TState = (stinpreparation, stShipped, stInProcessDelivered, stDelivered);

const
    StrState : array[TState] of string = ('en préparation', 'expédié', 'en livraison', 'livré');

type

    // Commandes
    TOrders = class(TPersistentWithCustomCreate)
    private
      FIdClient: integer;
      FId: integer;
      FLines: TarrayOrderLines;
      FState: TState;
      FDate: TDateTime;
      FCode: RAWUTF8;
    public
      procedure clearLines;
      procedure AddLine(aLine: TOrderLine);
    published
      property _id: integer read FId write FId;
      property _Code: RAWUTF8 read FCode write FCode;
      property _idClient: integer read FIdClient write FIdClient;
      property _date: TDateTime read FDate write FDate;
      property _stateOrder: TState read FState write FState;
      property _Lines: TarrayOrderLines read FLines write FLines;
    end;

    TConfiguration_informations = class(TPersistentWithCustomCreate)
    private
      fShortDateFormat: RawUTF8;
      fDecimalSeparator: RawUTF8;
    published
      property DecimalSeparator : RawUTF8 read fDecimalSeparator write fDecimalSeparator;
      property ShortDateFormat  : RawUTF8 read fShortDateFormat  write fShortDateFormat;
    end;

implementation

{ TOrders }

procedure TOrders.AddLine(aLine: TOrderLine);
begin
  SetLength(fLines, Length(fLines)+1);
  fLines[High(FLines)]:= aLine;
end;

procedure TOrders.clearLines;
var i: Integer;
begin
  for i := Low(fLines) to High(fLines) do
    if Assigned(FLines[i]) then
      fLines[i].Free;
  SetLength(FLines, 0);
end;

end.
