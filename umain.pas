unit uMain;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
    ValEdit;

type

    { TfMain }

    TfMain = class(TForm)
        bEncodeEXT:  TButton;
        bEncodeDPP:  TButton;
        bDecodeAddr: TButton;
        Bevel1:      TBevel;
        eAddress:    TLabeledEdit;
        ePage:       TLabeledEdit;
        eOffset:     TLabeledEdit;
        eDPP:        TLabeledEdit;
        listDPP:     TValueListEditor;
        procedure bEncodeDPPClick(Sender: TObject);
        procedure bEncodeEXTClick(Sender: TObject);
        procedure bDecodeAddrClick(Sender: TObject);
        procedure eAddressChange(Sender: TObject);
        procedure eClick(Sender: TObject);
        procedure eDPPChange(Sender: TObject);
        procedure eExtChange(Sender: TObject);
    private

    public

    end;

var
    fMain: TfMain;

implementation

{$R *.lfm}

{ TfMain }

procedure TfMain.bEncodeEXTClick(Sender: TObject);
var
    P, O: integer;
begin
    P := StrToIntDef('$' + ePage.Text, -1);
    if (P < 0) OR (P > $3FF) then
    begin
        ePage.Font.Color := clRed;
        Exit;
    end;
    O := StrToIntDef('$' + eOffset.Text, -1);
    if (O < 0) OR (O > $3FFF) then
    begin
        eOffset.Font.Color := clRed;
        Exit;
    end;
    eAddress.Text       := IntToHex((P SHL 14) OR (O AND $3FFF), 1);
    ePage.Font.Color    := clGreen;
    eOffset.Font.Color  := clGreen;
    eDPP.Font.Color     := clSilver;
    eAddress.Font.Color := clBlack;
end;

procedure TfMain.bEncodeDPPClick(Sender: TObject);
var
    DPP, O, DPP_idx: integer;
begin
    O := StrToIntDef('$' + eDPP.Text, -1);
    if (O < 0) OR (O > $FFFF) then
    begin
        eDPP.Font.Color := clRed;
        Exit;
    end;
    DPP_idx := (O SHR 14);
    if DPP_idx > 3 then
    begin
        eDPP.Font.Color := clRed;
        Exit;
    end;
    DPP := StrToIntDef('$' + listDPP.Strings.ValueFromIndex[DPP_idx], -1);
    if DPP < 0 then
    begin
        eDPP.Font.Color := clRed;
        Exit;
    end;
    eAddress.Text       := IntToHex((DPP SHL 14) OR (O AND $3FFF), 1);
    eDPP.Font.Color     := clGreen;
    ePage.Font.Color    := clSilver;
    eOffset.Font.Color  := clSilver;
    eAddress.Font.Color := clBlack;
end;

procedure TfMain.bDecodeAddrClick(Sender: TObject);
var
    A, DPP_idx, i: integer;
begin
    A := StrToIntDef('$' + eAddress.Text, -1);
    if (A < 0) OR (A > $FFFFFF) then
    begin
        eAddress.Font.Color := clRed;
        Exit;
    end;
    DPP_idx := -1;
    for i := 0 to 3 do
        if listDPP.Values['DPP' + IntToStr(i)] = IntToHex((A SHR 14), 1) then
            DPP_idx := i;
    if (DPP_idx < 0) then
        eDPP.Font.Color := clSilver
    else
    begin
        eDPP.Text       := IntToHex((A AND $3FFF) OR (DPP_idx SHL 14), 1);
        eDPP.Font.Color := clBlack;
    end;
    ePage.Text          := IntToHex((A SHR 14), 1);
    eOffset.Text        := IntToHex((A AND $3FFF), 1);
    eAddress.Font.Color := clGreen;
    ePage.Font.Color    := clBlack;
    eOffset.Font.Color  := clBlack;
end;

procedure TfMain.eClick(Sender: TObject);
begin
    TCustomEdit(Sender).SelectAll;
end;

procedure TfMain.eDPPChange(Sender: TObject);
begin
    if TCustomEdit(Sender).Focused then
        bEncodeDPPClick(Sender);
end;

procedure TfMain.eAddressChange(Sender: TObject);
begin
    if TCustomEdit(Sender).Focused then
        bDecodeAddrClick(Sender);
end;

procedure TfMain.eExtChange(Sender: TObject);
begin
    if TCustomEdit(Sender).Focused then
        bEncodeEXTClick(Sender);
end;

end.
