unit classebase;

interface

uses windows, System.SysUtils, System.Classes;

type

    // TVA
    Tvat = class
    private
      FId: integer;
      FValue: double;
      FLabel: string;
    public
      property _id: integer read FId write FId;
      property _label: string read FLabel write FLabel;
      property _value: double read FValue write FValue;
    end;

    // fournisseur
    TSupplier = class
    private
      FPhone: string;
      FSupplement: string;
      FId: integer;
      FZipCode: string;
      FCountry: string;
      FDescription: string;
      FMail: string;
      FCity: string;
      FAddress: string;
      FAccount: string;
      FMobile: string;
      FLabel: string;
    public
      property _id: integer read FId write FId;
      property _Label: string read FLabel write FLabel;
      property _Description: string read FDescription write FDescription;
      property _Address: string read FAddress write FAddress;
      property _supplement: string read FSupplement write FSupplement;
      property _ZipCode: string read FZipCode write FZipCode;
      property _City: string read FCity write FCity;
      property _Country: string read FCountry write FCountry;
      property _Phone: string read FPhone write FPhone;
      property _Mobile: string read FMobile write FMobile;
      property _Account: string read FAccount write FAccount;
      property _mail: string read FMail write FMail;
    end;

    // Famille de produit
    TFamily = class
    private
      Fid: integer;
      FDescription: string;
      FLabel: string;
      FCode: string;
    public
      property _id: integer read Fid write Fid;
      property _code: string read FCode write FCode;
      property _Label: string read FLabel write FLabel;
      property _Description: string read FDescription write FDescription;
    end;

    // produit
    TItems = class
    private
      Fid: integer;
      FidTVA: Integer;
      Fpvht: double;
      FDescription: string;
      FActif: Boolean;
      Fpaht: double;
      Fpfht: double;
      FIdSupplier: integer;
      FIdFamily: integer;
      FLabel: string;
    public
      property _id: integer read Fid write Fid;
      property _Label: string read FLabel write FLabel;
      property _description: string read FDescription write FDescription;
      property _pvht : double read Fpvht write Fpvht;  // prix de vente ht
      property _paht : double read Fpaht write Fpaht;  // prix d'achat  ht
      property _pfht : double read Fpfht write Fpfht;  // prix fournisseur ht;
      property _idvat: Integer read FidTVA write FidTVA;
      property _actif: Boolean read FActif write FActif;
      property _idfamily: integer read FIdFamily write FIdFamily;
      property _idSupplier: integer read FIdSupplier write FIdSupplier;
    end;

    // client
    TClient = class
    private
      FPhone: string;
      FSupplement: string;
      FId: integer;
      FZipCode: string;
      FCountry: string;
      FMail: string;
      FCity: string;
      FAddress: string;
      FFirstName: string;
      FAccount: string;
      FLastName: string;
      FMobile: string;
    public
      property _id: integer read FId write FId;
      property _FirstName : string read FFirstName write FFirstName;
      property _LastName: string read FLastName write FLastName;
      property _Address: string read FAddress write FAddress;
      property _supplement: string read FSupplement write FSupplement;
      property _ZipCode: string read FZipCode write FZipCode;
      property _City: string read FCity write FCity;
      property _Country: string read FCountry write FCountry;
      property _Phone: string read FPhone write FPhone;
      property _Mobile: string read FMobile write FMobile;
      property _Account: string read FAccount write FAccount;
      property _mail: string read FMail write FMail;
    end;

    // Ligne de commandes
    TOrderLine = class
    private
      FMtRem: double;
      FId: integer;
      FIdItems: integer;
      FQte: double;
    public
      property _id: integer read FId write FId;
      property _idItems: integer read FIdItems write FIdItems;
      property _Qte: double read FQte write FQte;
      property _MtRem: double read FMtRem write FMtRem;
    end;
    TarrayOrderLines = array of TOrderLine;

    // état des commandes (en préparation, expédiée, en cours de livraison, livrée)
    TState = (stinpreparation, stShipped, stInProcessDelivered, stDelivered);

    // Commandes
    TOrders = class
    private
      FIdClient: integer;
      FId: integer;
      FLines: TarrayOrderLines;
      FState: TState;
      FDate: TDateTime;
    public
      property _id: integer read FId write FId;
      property _idClient: integer read FIdClient write FIdClient;
      property _date: TDateTime read FDate write FDate;
      property _stateOrder: TState read FState write FState;
      property _Lines: TarrayOrderLines read FLines write FLines;
    end;

implementation

end.
