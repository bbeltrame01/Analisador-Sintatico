unit uAnalisadorSintatico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,
  System.Generics.Collections, StrUtils, Vcl.ComCtrls;

type
  TfAnalisadorSintatico = class(TForm)
    lbl_sentenca: TLabel;
    edt_sentenca: TEdit;
    stg_gramatica: TStringGrid;
    stg_tabela: TStringGrid;
    stg_first_follow: TStringGrid;
    btn_gerar: TButton;
    btn_total: TButton;
    btn_passo_a_passo: TButton;
    stg_principal: TStringGrid;
    Shape1: TShape;
    lbl_gramatica: TLabel;
    Label1: TLabel;
    lbl_first_follow: TLabel;
    lbl_resposta: TLabel;
    tmr: TTimer;
    tkb_delay: TTrackBar;
    lbl_delay: TLabel;
    lbl_1s: TLabel;
    lbl_02s: TLabel;
    lbl_2s: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure stg_gramaticaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure stg_first_followDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure stg_tabelaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure stg_principalDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btn_passo_a_passoClick(Sender: TObject);
    procedure btn_totalClick(Sender: TObject);
    procedure edt_sentencaKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edt_sentencaChange(Sender: TObject);
    procedure tmrTimer(Sender: TObject);
    procedure btn_gerarClick(Sender: TObject);
  private
    { Private declarations }
    procedure Processar;
    procedure geraLinha;
    procedure Limpar;
  public
    { Public declarations }
    slPilha   : TStringList;
    slEntrada : TStringList;
    slRegra   : TStringList;
    iLinha    : Integer;
    bFirst    : Boolean;
    bLer      : Boolean;
    bFim      : Boolean;
    bTotal    : Boolean;
  end;

var
  fAnalisadorSintatico: TfAnalisadorSintatico;

implementation

{$R *.dfm}

procedure TfAnalisadorSintatico.btn_gerarClick(Sender: TObject);
var
  slSentencas: TStringList;
begin
  slSentencas := TStringList.Create;
  try
    slSentencas.AddStrings(['acab','aaacabbb','aaacabbb','aaaccb','aaaccb','aabb']);
    edt_sentenca.Text := slSentencas[random(6)];
  finally
    slSentencas.Free;
  end;
end;

procedure TfAnalisadorSintatico.btn_passo_a_passoClick(Sender: TObject);
begin
  btn_gerar.Enabled:=false;
  btn_total.Enabled:=false;
  btn_passo_a_passo.Enabled:=true;
  bTotal:=False;
  try
    Processar;
  finally
    btn_gerar.Enabled:=bFim;
    btn_total.Enabled:=not bFim;
    btn_passo_a_passo.Enabled:=not bFim;
  end;
end;

procedure TfAnalisadorSintatico.btn_totalClick(Sender: TObject);
begin
  edt_sentenca.Enabled := false;
  btn_gerar.Enabled := False;
  btn_total.Enabled := False;
  btn_passo_a_passo.Enabled := False;
  bTotal := True;

  tmr.Enabled := True;
end;

procedure TfAnalisadorSintatico.edt_sentencaChange(Sender: TObject);
begin
  btn_passo_a_passo.Enabled := Length(edt_sentenca.Text) > 0;
  btn_total.Enabled         := Length(edt_sentenca.Text) > 0;
  bFirst                    := Length(edt_sentenca.Text) > 0;
end;

procedure TfAnalisadorSintatico.edt_sentencaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in['a'..'d', Chr(8)]) then
    Key := #0;
end;

procedure TfAnalisadorSintatico.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfAnalisadorSintatico.FormCreate(Sender: TObject);
begin
  stg_tabela.Selection := TGridRect(Rect(-1, -1, -1, -1));
  slPilha   := TStringList.create;
  slEntrada := TStringList.create;
  slRegra   := TStringList.create;
  iLinha  := 0;
  bFirst  := True;
  bLer    := False;
  bFim    := False;
  bTotal  := False;

  lbl_resposta.Caption := EmptyStr;
end;

procedure TfAnalisadorSintatico.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift=[ssAlt]) and (Key=50) then  // Alt+P
    btn_passo_a_passo.Click;
end;

procedure TfAnalisadorSintatico.FormShow(Sender: TObject);
begin
  // Gramática
  stg_gramatica.Cells[0,0]:='S ::='; stg_gramatica.Cells[1,0]:='aCb';
  stg_gramatica.Cells[0,1]:='A ::='; stg_gramatica.Cells[1,1]:='bBd'; stg_gramatica.Cells[2,1]:='aSa';
  stg_gramatica.Cells[0,2]:='B ::='; stg_gramatica.Cells[1,2]:='cAd'; stg_gramatica.Cells[2,2]:='e';
  stg_gramatica.Cells[0,3]:='C ::='; stg_gramatica.Cells[1,3]:='aSb'; stg_gramatica.Cells[2,3]:='cBa';

  // Tabela
                              stg_tabela.Cells[1,0]:='a';   stg_tabela.Cells[2,0]:='b';   stg_tabela.Cells[3,0]:='c';   stg_tabela.Cells[4,0]:='d'; stg_tabela.Cells[5,0]:='$';
  stg_tabela.Cells[0,1]:='S'; stg_tabela.Cells[1,1]:='aCb';
  stg_tabela.Cells[0,2]:='A'; stg_tabela.Cells[1,2]:='aSa'; stg_tabela.Cells[2,2]:='bBd';
  stg_tabela.Cells[0,3]:='B'; stg_tabela.Cells[1,3]:='e';                                 stg_tabela.Cells[3,3]:='cAd'; stg_tabela.Cells[4,3]:='e';
  stg_tabela.Cells[0,4]:='C'; stg_tabela.Cells[1,4]:='aSb';                               stg_tabela.Cells[3,4]:='cBa';

  // FIRST/FOLLOW
  stg_first_follow.Cells[1,0]:='FIRST';
  stg_first_follow.Cells[2,0]:='FOLLOW';
  stg_first_follow.Cells[0,1]:='S ='; stg_first_follow.Cells[1,1]:='{a}';    stg_first_follow.Cells[2,1]:='{$, b, a}';
  stg_first_follow.Cells[0,2]:='A ='; stg_first_follow.Cells[1,2]:='{b, a}'; stg_first_follow.Cells[2,2]:='{d}';
  stg_first_follow.Cells[0,3]:='B ='; stg_first_follow.Cells[1,3]:='{c, E}'; stg_first_follow.Cells[2,3]:='{d, a}';
  stg_first_follow.Cells[0,4]:='C ='; stg_first_follow.Cells[1,4]:='{a, c}'; stg_first_follow.Cells[2,4]:='{b}';

  // Principal
  stg_principal.Cells[0,0]:='#';
  stg_principal.Cells[1,0]:='Pilha';
  stg_principal.Cells[2,0]:='Entrada';
  stg_principal.Cells[3,0]:='Ação';
end;

procedure TfAnalisadorSintatico.geraLinha;
begin
  iLinha := iLinha + 1;

  stg_principal.Cells[0, iLinha] := IntToStr(iLinha);

  if slPilha[slPilha.Count - 1] = '$' then
    stg_principal.Cells[1, iLinha] := slPilha[slPilha.Count - 1]
  else
    stg_principal.Cells[1, iLinha] := '$' + slPilha[slPilha.Count - 1];

  if slEntrada[slEntrada.Count - 1] = '$' then
    stg_principal.Cells[2, iLinha] := slEntrada[slEntrada.Count - 1]
  else
    stg_principal.Cells[2, iLinha] := slEntrada[slEntrada.Count - 1] + '$';

  stg_principal.Cells[3, iLinha] := slRegra[slRegra.Count - 1];

  if bLer then
  begin
    slPilha[slPilha.Count - 1] :=
      Copy(slPilha[slPilha.Count - 1], 1,
           Length(slPilha[slPilha.Count - 1])-1);

    bLer := False;
  end;
end;

procedure TfAnalisadorSintatico.Limpar;
var
  i, j : integer;
begin
  lbl_resposta.Caption := EmptyStr;

  for I := 0 to stg_principal.ColCount-1 do
    for J := 1 to stg_principal.RowCount do
      stg_principal.Cells[i, j] := EmptyStr;

  stg_principal.RowCount := 1;

  iLinha := 0;
  bFirst := True;
  bLer := False;
  bFim := False;

  slPilha.clear;
  slEntrada.clear;
  slRegra.clear;
end;

procedure TfAnalisadorSintatico.Processar;
 function BuscaRegra(sLinha, sColuna: string) : string;
  var
    i, j : integer;
  begin
    if (sLinha = EmptyStr) and (sColuna = EmptyStr) then
    begin
      btn_total.Enabled := False;
      slPilha.Add('$');
      slEntrada.Add('$');
      slRegra.Add('Aceito em ' + IntToStr(iLinha + 1) + ' Iterações' );
      lbl_resposta.Font.Color := clLime;
      lbl_resposta.Caption := 'ACEITO';
      bFim := True;

      Exit;
    end else
    if (sLinha <> EmptyStr) and (sColuna = EmptyStr) then
    begin
      btn_total.Enabled := False;
      slEntrada.Add('$');
      slRegra.Add('Erro em ' + IntToStr(iLinha + 1) + ' Iterações' );
      lbl_resposta.Font.Color := clRed;
      lbl_resposta.Caption := 'ERRO';
      bFim := True;

      Exit;
    end else
    if (sLinha = EmptyStr) and (sColuna <> EmptyStr) then
    begin
      btn_total.Enabled := False;
      slEntrada.Add('$');
      slRegra.Add('Erro em ' + IntToStr(iLinha + 1) + ' Iterações' );
      lbl_resposta.Font.Color := clRed;
      lbl_resposta.Caption := 'ERRO';
      bFim := True;

      Exit;
    end;

    for I := 0 to stg_tabela.ColCount-1 do
      if stg_tabela.Cells[I, 0] = sColuna then
      begin
        stg_tabela.FixedCols := I;
        break;
      end;

    for J := 0 to stg_tabela.RowCount-1 do
      if stg_tabela.Cells[0, J] = sLinha then
      begin
        stg_tabela.FixedRows := J;
        break;
      end;

    Result := stg_tabela.Cells[I, J];

    if Result = EmptyStr then
      stg_tabela.Selection := TGridRect(Rect(-1, -1, -1, -1));
  end;

  function BuscaLinha : String;
  begin
    Result := Copy(AnsiReverseString(slPilha[slPilha.Count - 1]), 1, 1);
  end;

  function BuscaColuna : String;
  begin
    Result := Copy(slEntrada[slEntrada.Count - 1], 1, 1);
  end;

  procedure MontaDerivacao;
  var
    sEps : string;
  begin
    if (Copy(slRegra[slRegra.Count - 1], 1, 2) <> 'Lê') then
    begin
      if slRegra[slRegra.Count - 1] = 'e' then
        sEps := EmptyStr
      else
      if slRegra[slRegra.Count - 1] = '' then
      begin
        btn_total.Enabled := False;
        slEntrada.Add('$');
        slRegra.Add('Erro em ' + IntToStr(iLinha + 1) + ' Iterações' );
        lbl_resposta.Font.Color := clRed;
        lbl_resposta.Caption := 'ERRO';
        bFim := True;

        Exit;
      end
      else
        sEps := AnsiReverseString(slRegra[slRegra.Count - 1]);

      slPilha[slPilha.Count - 1] :=
        Copy(slPilha[slPilha.Count - 1], 1,
             Length(slPilha[slPilha.Count - 1])-1) + sEps;
    end
    else
    begin
      slEntrada[slEntrada.Count - 1] :=
        Copy(slEntrada[slEntrada.Count - 1], 2,
             Length(slEntrada[slEntrada.Count - 1]));

      slRegra.Add(BuscaRegra(BuscaLinha, BuscaColuna));
      if bFim then
        slRegra.Delete(slRegra.Count-1);
    end;

    if (not bFim) and (BuscaLinha = BuscaColuna) then
    begin
      slRegra.Add('Lê ' + BuscaLinha);
      bLer := True;
    end;
  end;

begin
  try
    if bFirst then
    begin
      Limpar;
      slPilha.add('S');
      slEntrada.Add(edt_sentenca.Text);
      bFirst := False;
      slRegra.Add(BuscaRegra(BuscaLinha, BuscaColuna));
    end
    else
      MontaDerivacao;

    stg_principal.RowCount := stg_principal.RowCount + 1;
    stg_principal.Row := stg_principal.RowCount-1;

    geraLinha;
  finally
    btn_gerar.Enabled:=bFim;
    edt_sentenca.Enabled := bFim;
  end;
end;

procedure TfAnalisadorSintatico.stg_first_followDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sTexto: String;
begin
  with TStringGrid(Sender) do
  begin
    Canvas.Brush.Color:=clWhite;
    Canvas.FillRect(Rect); // Limpa o conteúdo da célula.
    sTexto := Cells[ACol, ARow];
    if ARow = 0 then
      Canvas.Font.Style:=[fsBold];
    Canvas.TextRect(Rect, sTexto, [tfWordBreak,tfVerticalCenter,tfCenter]);
  end;
end;

procedure TfAnalisadorSintatico.stg_gramaticaDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sTexto: String;
begin
  with TStringGrid(Sender) do
  begin
    Canvas.Brush.Color:=clWhite;
    Canvas.FillRect(Rect); // Limpa o conteúdo da célula.
    sTexto := Cells[ACol, ARow];
    Canvas.TextRect(Rect, sTexto, [tfWordBreak,tfVerticalCenter,tfCenter]);
  end;
end;

procedure TfAnalisadorSintatico.stg_principalDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sTexto: String;
begin
  if ARow=0 then
  begin
    with TStringGrid(Sender) do
    begin
      Canvas.Brush.Color:=clWhite;
      Canvas.FillRect(Rect); // Limpa o conteúdo da célula.
      sTexto := Cells[ACol, ARow];
      Canvas.Font.Style:=[fsBold];
      Canvas.TextRect(Rect, sTexto, [tfWordBreak,tfVerticalCenter,tfCenter]);
    end;
  end;
end;

procedure TfAnalisadorSintatico.stg_tabelaDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sTexto: String;
begin
  if ARow=0 then
  begin
    with TStringGrid(Sender) do
    begin
      Canvas.Brush.Color:=clWhite;
      Canvas.FillRect(Rect); // Limpa o conteúdo da célula.
      sTexto := Cells[ACol, ARow];
      Canvas.TextRect(Rect, sTexto, [tfWordBreak,tfVerticalCenter,tfCenter]);
    end;
  end;
end;


procedure TfAnalisadorSintatico.tmrTimer(Sender: TObject);
begin
  tmr.Interval:=tkb_delay.Position*200;
  Processar;
  if bFim then
    tmr.Enabled := False;
end;

end.
