unit GerLanche;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    Button5: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    Edit5: TEdit;
    Label8: TLabel;
    Edit6: TEdit;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDStoredProc1: TFDStoredProc;
    CheckBox1: TCheckBox;
    Label9: TLabel;
    Edit7: TEdit;
    Button6: TButton;
    Button7: TButton;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label10: TLabel;
    Edit8: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure OnCreate(Sender: TObject);
  private
    { Private declarations }
  public
    nivel: integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
//inicio do carregamento do form
procedure TForm1.OnCreate(Sender: TObject);
begin
  //conecta
  FDConnection1.Params.Clear;
  FDConnection1.Params.DriverID := 'SQLite';
  FDConnection1.Params.Database := ExtractFilePath(Application.ExeName) + 'gerlanches.db';
  FDConnection1.LoginPrompt := False;
  FDConnection1.Connected := True;

  //cria tabela
  FDQuery1.Connection := FDConnection1;
  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS Login (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'Usuario TEXT, ' + 'Senha TEXT, ' + 'Nivel INTEGER, ' + 'Data TEXT)';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS Cardapio (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' + 'Lanche TEXT, ' +  'ListaIngr TEXT)';

  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS Ingredientes (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'Ingrediente TEXT, ' + 'Preco INTEGER)';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS Pedido (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'NumPedido INTEGER, ' + 'Pedido TEXT)';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS Cliente (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'Nome TEXT, ' + 'Data TEXT)';
  FDQuery1.ExecSQL;

end;

//login
procedure TForm1.Button1Click(Sender: TObject);
var
  usuario, senha: string;
begin
  if Trim(Edit1.Text) = '' then
  begin
    Label4.Caption := 'Msg: Entre com o usuario!';
    Exit;
  end;

  if Trim(Edit2.Text) = '' then
  begin
    Label4.Caption := 'Msg: Entre com a senha!';
    Exit;
  end;

  //verifica se usuario existe
  usuario := Edit1.Text;
  senha := Edit2.Text;
  FDQuery1.SQL.Text := 'SELECT * FROM Login WHERE Usuario = :usuario and Senha = :senha LIMIT 1';
  FDQuery1.ParamByName('Usuario').AsString := usuario;
  FDQuery1.ParamByName('Senha').AsString := senha;
  FDQuery1.Open;

  if FDQuery1.IsEmpty then
  begin
    Label4.Caption := 'Msg: Usuario ou Senha invalido!'
  end
  else
  begin
    FDQuery1.Close;
    //guarda nivel de acesso
    FDQuery1.SQL.Text := 'SELECT * FROM Login WHERE Usuario = :usuario LIMIT 1';
    FDQuery1.ParamByName('Usuario').AsString := usuario;
    FDQuery1.Open;
    if not FDQuery1.IsEmpty then
    begin
      nivel := FDQuery1.FieldByName('Nivel').AsInteger;
    end;
    FDQuery1.Close;

    //habilita controles e login dessabilita
    Label1.Enabled := False;
    Edit1.Enabled := False;
    Label2.Enabled := False;
    Edit2.Enabled := False;
    Label3.Enabled := False;
    Edit3.Enabled := False;
    CheckBox1.Enabled := False;
    Button1.Enabled := False;
    //
    Label6.Enabled := True;
    Edit4.Enabled := True;
    Label7.Enabled := True;
    Edit5.Enabled := True;
    Label8.Enabled := True;
    Edit6.Enabled := True;
    Label9.Enabled := True;
    Edit7.Enabled := True;
    Label5.Enabled := True;
    Label10.Enabled := True;
    Edit8.Enabled := True;

    ListBox1.Enabled := True;
    RadioGroup1.Enabled := True;
    RadioButton1.Enabled := True;
    RadioButton2.Enabled := True;
    RadioButton3.Enabled := True;
    Button6.Enabled := True;

    Label4.Caption := 'Msg: Login Ok!';
  end;
  FDQuery1.Close;
end;

//incluir
procedure TForm1.Button3Click(Sender: TObject);
var
  bFind: Boolean;
  i, j, Tam, numpedido, DifDias, MesOld, Mes, AnoOld, Ano, DiaOld, Dia: integer;
  Texto, TextAux, ingr, lanche, LstIngr, DataStr, nome, datacli, usuario, senha, strAux: string;
  ListaIngr: array of string;
  ListaPreco: array of integer;
  ListaAux: TArray<string>;
  DataIni, DataFim: TDateTime;
  Totpreco: Double;

begin
  //insere usuario ou dados do produto
  if ListBox1.Enabled then
  begin

    if RadioButton1.Checked then
    begin
      if Trim(Edit7.Text) = '' then
      begin
        Label4.Caption := 'Msg: Entre com o Pedido!';
        Exit;
      end
      else if(Trim(Edit8.Text)) = '' then
      begin
        Label4.Caption := 'Msg: Entre com o Cliente!';
        Exit;
      end;
    end;

    if RadioButton1.Checked or RadioButton2.Checked then
    begin
      if Trim(Edit4.Text) = '' then
      begin
        Label4.Caption := 'Msg: Entre com o Lanche!';
        Exit;
      end;
    end;

    if RadioButton2.Checked or RadioButton3.Checked then
    begin
      if Trim(Edit6.Text) = '' then
      begin
        Label4.Caption := 'Msg: Entre com o Ingrediente!';
        Exit;
      end;

      if RadioButton1.Checked or RadioButton3.Checked then
      begin
        if Trim(Edit5.Text) = '' then
        begin
          Label4.Caption := 'Msg: Entre com o Preco!';
          Exit;
        end
      end
    end;

    //inserir dados
    if RadioButton2.Checked then
      begin
        if nivel = 0 then
        begin
          Label4.Caption := 'Msg: Acesso nao autorizado!';
          exit;
        end;

       //verifica se lanche ja existe
      lanche := Edit4.Text;
      FDQuery1.SQL.Text := 'SELECT 1 FROM Cardapio WHERE Lanche = :lanche';
      FDQuery1.ParamByName('Lanche').AsString := lanche;
      FDQuery1.Open;

      if FDQuery1.IsEmpty then
      begin
        FDQuery1.Close;

        //procura ingrediente na tabela Ingredientes
        SetLength(ListaIngr, 50);
        SetLength(ListaPreco, 50);
        i := 0;

        FDQuery1.SQL.Text := 'SELECT * FROM Ingredientes';
        FDQuery1.Open;
        while not FDQuery1.Eof do
        begin
           ListaIngr[i] := FDQuery1.FieldByName('Ingrediente').AsString;
           ListaPreco[i] := FDQuery1.FieldByName('Preco').AsInteger;
           Inc(i,1);
           if i >= 50 then
           begin
             Label4.Caption := 'Msg: Erro interno!';
             exit;
           end;
          FDQuery1.Next;
        end;
	      FDQuery1.Close;
		
        ListBox1.Items.Clear;

        i := 0;
        bFind := False;
        while ListaIngr[i] <> '' do
        begin
          begin
             if Pos(ListaIngr[i], Edit6.Text) > 0 then
             Begin
               bFind := True;
             end;

             Inc(i,1);
             if i >= 50 then
             begin
              Label4.Caption := 'Msg: Erro interno!!';
              exit;
             end;
          End;
        end;
        if not bFind then
        begin
          Label4.Caption := 'Msg: Ingrediente nao encontrado!';
          exit;
        end;

        //
        FDQuery1.SQL.Text := 'INSERT INTO Cardapio (Lanche, ListaIngr)' +
                             'VALUES (:Lanche, :ListaIngr)';
        FDQuery1.ParamByName('Lanche').AsString := Edit4.Text;
        FDQuery1.ParamByName('ListaIngr').AsString := Edit6.Text;
        FDQuery1.ExecSQL;

        Label4.Caption := 'Msg: Inclusao de Lanche Ok!';
      end
      else
        Label4.Caption := 'Msg: Inclusao já efetuada!';
		
	    FDQuery1.Close;
    end
    else if RadioButton1.Checked then
      begin
        //verifica se pedido ja existe
        numpedido := StrToInt(Edit7.Text);
        FDQuery1.SQL.Text := 'SELECT 1 FROM Pedido WHERE NumPedido = :numpedido';
        FDQuery1.ParamByName('NumPedido').AsInteger := numpedido;
        FDQuery1.Open;

        if not FDQuery1.IsEmpty then
        begin
          Label4.Caption := 'Msg: Pedido ja incluido!';
          FDQuery1.Close;
          exit;
        end
        else
        begin
          FDQuery1.Close;
          //veririfca se lanche existe
          lanche := Edit4.Text;
          FDQuery1.SQL.Text := 'SELECT 1 FROM Cardapio WHERE Lanche = :lanche';
          FDQuery1.ParamByName('Lanche').AsString := lanche;
          FDQuery1.Open;
          if FDQuery1.IsEmpty then
          begin
            Label4.Caption := 'Msg: Lanche não existe!';
            FDQuery1.Close;
            exit;
          end;
          FDQuery1.Close;

          //captura ingredientes
          FDQuery1.SQL.Text := 'SELECT * FROM Cardapio WHERE Lanche = :lanche';
          FDQuery1.ParamByName('Lanche').AsString := lanche;
          FDQuery1.Open;
          if not FDQuery1.IsEmpty then
          begin
            ingr := FDQuery1.FieldByName('ListaIngr').AsString;
          end;
          FDQuery1.Close;
          //veririfca se irqa incluir ingrediente extra
          if Edit6.Text <> '' then
          begin
            bFind := False;
            SetLength(ListaAux, 50);
            Texto := Edit6.Text;
            ListaAux := Texto.Split([',']);
            //separa os ingredientes

            i := 0;
            Tam := Length(ListaAux);
            //procura os ingredientes e inclui se existir
            for j := 1 to Tam do
              begin
              FDQuery1.SQL.Text := 'SELECT * FROM Ingredientes';
              FDQuery1.Open;
              while not FDQuery1.Eof do
              begin
                if Pos(ListaAux[i],FDQuery1.FieldByName('Ingrediente').AsString) > 0 then
                begin
                  bFind := True;
                  ingr := ingr + ',' + ListaAux[i];
                  Inc(i, 1);
                  if Tam >= i then
                    break;
                end;
                FDQuery1.Next;
              end;
              FDQuery1.Close;
            end;

            if bFind = False then
            begin
              Label4.Caption := 'Msg: Ingrediente inexistente!';
              exit;
            end;
          end;

          //acessa dados do cliente
          nome := Edit8.text;
          FDQuery1.SQL.Text := 'SELECT * FROM Cliente WHERE Nome = :nome';
          FDQuery1.ParamByName('Nome').AsString := nome;
          FDQuery1.Open;
          if not FDQuery1.IsEmpty then
          begin
            datacli := FDQuery1.FieldByName('Data').AsString;
          end;
          FDQuery1.Close;

          //procura ingrediente na tabela Ingredientes
          SetLength(ListaIngr, 50);
          SetLength(ListaPreco, 50);
          i := 0;

          FDQuery1.SQL.Text := 'SELECT * FROM Ingredientes';
          FDQuery1.Open;
          while not FDQuery1.Eof do
          begin
             ListaIngr[i] := FDQuery1.FieldByName('Ingrediente').AsString;
             ListaPreco[i] := FDQuery1.FieldByName('Preco').AsInteger;
             Inc(i,1);
             if i >= 50 then
             begin
               Label4.Caption := 'Msg: Erro interno!';
               exit;
             end;
            FDQuery1.Next;
          end;
          FDQuery1.Close;
          //
          FDQuery1.SQL.Text := 'SELECT * FROM Cardapio';
          FDQuery1.Open;

          while not FDQuery1.Eof do
          begin
            i := 0;
            bFind := False;
            Totpreco := 0;

            LstIngr := FDQuery1.FieldByName('ListaIngr').AsString;
            while ListaIngr[i] <> '' do
            Begin
               if Pos(ListaIngr[i], Ingr) > 0 then
               Begin
                 bFind := True;
                 Totpreco := Totpreco + ListaPreco[i];
               end;

               Inc(i,1);
               if i >= 50 then
               begin
                Label4.Caption := 'Msg: Erro interno!!';
                exit;
               end;
            End;
            if not bFind then
            begin
              Label4.Caption := 'Msg: Ingrediente nao encontrado!';
              exit;
            end;

            if lanche.Contains('XSalada') and Ingr.Contains('Batata') then
              Ingr := Ingr +',Refrigerante';

            //
            if Totpreco >= 50 then
            begin
              Totpreco := Totpreco * (97 / 100);
            end;

            if datacli <> '' then
            begin
              //calcula tempo total em meses
              DataStr := FormatDateTime('dd/mm/yyyy', Date);
              strAux := Copy(datacli, 1, 2);
              DiaOld := StrtoInt(strAux);
              strAux := Copy(DataStr, 1, 2);
              Dia := StrtoInt(strAux);
              strAux := Copy(datacli, 4, 2);
              MesOld := StrtoInt(strAux);
              strAux := Copy(DataStr, 4, 2);
              Mes := StrtoInt(strAux);
              strAux := Copy(datacli, 9, 2);
              AnoOld := StrtoInt(strAux);
              strAux := Copy(DataStr, 9, 2);
              Ano := StrtoInt(strAux);
              DataIni := EncodeDate(AnoOld, MesOld, DiaOld);
              DataFim   := EncodeDate(Ano, Mes, Dia);
              DifDias := Trunc(DataFim - DataIni);
              if DifDias > 180 then
              begin
                Totpreco := Totpreco * (95 / 100);
              end
            end;
            if bFind = True then
              break;
            FDQuery1.Next;
          end;
          FDQuery1.Close;
          //
          FDQuery1.SQL.Text := 'INSERT INTO Pedido (NumPedido, Pedido)' +
                               'VALUES (:NumPedido, :Pedido)';
          FDQuery1.ParamByName('NumPedido').AsInteger := StrToInt(Edit7.Text);

          Tam := Length(Edit4.Text);
          if numpedido > 999 then
            TextAux :=  '   ' + Edit4.Text
          else if numpedido > 99 then
            TextAux :=  '    ' + Edit4.Text
          else if numpedido > 9 then
            TextAux :=  '     ' + Edit4.Text
          else
            TextAux :=  '      ' + Edit4.Text;

          if Tam < 10 then
          begin
          for i  := 0 to (10 - Tam) do
            TextAux := TextAux + ' ';
          end;

          if TotPreco >= 100 then
          begin
            strAux := TotPreco.ToString;
            if Length(strAux) = 3 then
              Texto := Format('%s%s   %s', [TextAux, strAux, ingr])
            else if Length(strAux) = 4 then
              Texto := Format('%s%s  %s', [TextAux, strAux, ingr])
            else if Length(strAux) = 5 then
              Texto := Format('%s%s %s', [TextAux, strAux, ingr])
            else
              Texto := Format('%s%s%s', [TextAux, strAux, ingr])
          end
          else if TotPreco >= 10 then
          begin
            strAux := TotPreco.ToString;
            if Length(strAux) = 2 then
              Texto := Format('%s%s    %s', [TextAux, strAux, ingr])
            else if Length(strAux) = 3 then
              Texto := Format('%s%s   %s', [TextAux, strAux, ingr])
            else if Length(strAux) = 4 then
              Texto := Format('%s%s  %s', [TextAux, strAux, ingr])
            else
              Texto := Format('%s%s %s', [TextAux, strAux, ingr])
          end
          else
          begin
            strAux := TotPreco.ToString;
            if Length(strAux) = 1 then
              Texto := Format('%s%s     %s', [TextAux, strAux, ingr])
            else if Length(strAux) = 2 then
              Texto := Format('%s%s    %s', [TextAux, strAux, ingr])
            else if Length(strAux) = 3 then
              Texto := Format('%s%s   %s', [TextAux, strAux, ingr])
            else
              Texto := Format('%s%s  %s', [TextAux, strAux, ingr]);
          end;

          FDQuery1.ParamByName('Pedido').AsString := Texto;
          FDQuery1.ExecSQL;

          //verifica e inclui cliente e data
          FDQuery1.SQL.Text := 'SELECT * FROM Cliente WHERE Nome = "' + Edit8.Text + '"';
          FDQuery1.Open;

          if not FDQuery1.IsEmpty then
          begin
            while not FDQuery1.Eof do
            begin
              if FDQuery1.FieldByName('Nome').AsString = Edit8.Text then
              begin
                 datacli := FDQuery1.FieldByName('Data').AsString;
              end;
              FDQuery1.Next;
              end
          end;
          FDQuery1.Close;
          //
          if datacli = '' then
          begin
            DataStr := FormatDateTime('dd/mm/yyyy', Date);
            FDQuery1.SQL.Text := 'INSERT INTO Cliente (Nome, Data)' +
                                  'VALUES (:Nome, :Data)';
            FDQuery1.ParamByName('Nome').AsString := Edit8.Text;
            FDQuery1.ParamByName('Data').AsString := DataStr;
            FDQuery1.ExecSQL;
          end
          else
          begin
            FDQuery1.SQL.Text := 'UPDATE Cliente SET Data = "' + DataStr + '" WHERE Nome = "' + nome + '"';
            FDQuery1.ExecSQL;
          end;

          Label4.Caption := 'Msg: Inclusao de Pedido Ok!';
      end
    end
    else
    begin
      if nivel = 0 then
      begin
        Label4.Caption := 'Msg: Acesso nao autorizado!';
        exit;
      end;
      //verifica se ingrediente ja existe
      ingr := Edit6.Text;
      FDQuery1.SQL.Text := 'SELECT 1 FROM Ingredientes WHERE Ingrediente = "' + ingr + '"';
      FDQuery1.Open;

      if FDQuery1.IsEmpty then
      begin
        FDQuery1.SQL.Text := 'INSERT INTO Ingredientes (Ingrediente, Preco)' +
                             'VALUES (:Ingrediente, :Preco)';
        FDQuery1.ParamByName('Ingrediente').AsString := Edit6.Text;
        FDQuery1.ParamByName('Preco').AsInteger := StrToInt(Edit5.Text);
        FDQuery1.ExecSQL;

        Label4.Caption := 'Msg: Inclusao de Ingredientes Ok!';
      end
      else
        Label4.Caption := 'Msg: Ingrediente ja existe!';
		
	    FDQuery1.Close;
    end;
  end
  else
  begin
    if Trim(Edit1.Text) = '' then
    begin
      Label4.Caption := 'Msg: Entre com o usuario!';
      Exit;
    end;

    if Trim(Edit2.Text) = '' then
    begin
      Label4.Caption := 'Msg: Entre com a senha!';
      Exit;
    end;

    //verifica se usuario existe
    usuario := Edit1.Text;
    senha := Edit2.Text;
    FDQuery1.SQL.Text := 'SELECT * FROM Login WHERE Usuario = :usuario and Senha = :senha LIMIT 1';
    FDQuery1.ParamByName('Usuario').AsString := usuario;
    FDQuery1.ParamByName('Senha').AsString := senha;
    FDQuery1.Open;
    if not FDQuery1.IsEmpty then
    begin
      Label4.Caption := 'Msg: Usuario ja incluido!';
      FDQuery1.Close;
      exit;
    end;
    FDQuery1.Close;

    //inclui usuario
    DataStr := FormatDateTime('dd/mm/yyyy', Date);
    FDQuery1.SQL.Text := 'INSERT INTO Login (Usuario, Senha, Nivel, Data)' +
                         'VALUES (:Usuario, :Senha, :Nivel, :Data)';
    FDQuery1.ParamByName('Usuario').AsString := Edit1.Text;
    FDQuery1.ParamByName('Senha').AsString := Edit2.Text;
    FDQuery1.ParamByName('Nivel').AsInteger := 0;
    if CheckBox1.Checked then
      FDQuery1.ParamByName('Nivel').AsInteger := 1;
    FDQuery1.ParamByName('Data').AsString := DataStr;
    FDQuery1.ExecSQL;

    Label4.Caption := 'Msg: Inclusao de Usuario Ok!';
  end;

end;

//alterar
procedure TForm1.Button2Click(Sender: TObject);
var
  bFind: Boolean;
  usuario, senha, lanche, ingr, Texto, TextAux: string;
  i, numpedido, Tam: integer;
begin
  if ListBox1.Enabled then
  begin
      if RadioButton1.Checked then
      begin
        //verifica se pedido ja existe
        numpedido := StrToInt(Edit7.Text);
        FDQuery1.SQL.Text := 'SELECT 1 FROM Pedido WHERE NumPedido = :numpedido';
        FDQuery1.ParamByName('NumPedido').AsInteger := numpedido;
        FDQuery1.Open;

        if not FDQuery1.IsEmpty then
        begin
          Tam := Length(Edit4.Text);
          TextAux :=  '      ' + Edit4.Text;
          if Tam < 10 then
          begin
          for i  := 0 to (10 - Tam) do
            TextAux := TextAux + ' ';
          end;

          if StrToInt(Edit5.Text) > 99 then
            Texto := Format('%s%s   %s', [TextAux, Edit5.Text, Edit6.Text])
          else if StrToInt(Edit5.Text) > 9 then
            Texto := Format('%s%s    %s', [TextAux, Edit5.Text, Edit6.Text])
          else
            Texto := Format('%s%s     %s', [TextAux, Edit5.Text, Edit6.Text]);

          FDQuery1.SQL.Text := 'UPDATE Pedido SET Pedido = "' + Texto + '" WHERE NumPedido = :numpedido';
          FDQuery1.ExecSQL;

          Label4.Caption := 'Msg: Pedido atualizado!';
        end
        else
          Label4.Caption := 'Msg: Pedido inexistente!';

	      FDQuery1.Close;
      end
      else if RadioButton2.Checked then
      begin
        if nivel = 0 then
        begin
            Label4.Caption := 'Msg: Acesso nao autorizado!';
            exit;
        end;

        lanche := Edit4.Text;
        bFind := False;
        //verifica se ingrediente existe
        FDQuery1.SQL.Text := 'SELECT * FROM Ingredientes';
        FDQuery1.Open;
        while not FDQuery1.Eof do
        begin
           if Edit6.Text = FDQuery1.FieldByName('Ingrediente').AsString then
           begin
             bFind := True;
             break;
           end;
          FDQuery1.Next;
        end;
	      FDQuery1.Close;
        //
        if bFind = True then
        begin
          FDQuery1.SQL.Text := 'UPDATE Cardapio SET ListaIngr = "' + Edit6.Text + '" WHERE Lanche = "' + lanche + '"';
          FDQuery1.ExecSQL;

          Label4.Caption := 'Msg: Lanche atualizado!';
        end
        else
          Label4.Caption := 'Msg: Ingrediente não cadastrado!';
      end
      else
      begin
        if nivel = 0 then
        begin
          Label4.Caption := 'Msg: Acesso nao autorizado!';
          exit;
        end;
        //
        ingr := Edit6.Text;
        bFind := False;
        //verifica se ingrediente existe
        FDQuery1.SQL.Text := 'SELECT * FROM Ingredientes';
        FDQuery1.Open;
        while not FDQuery1.Eof do
        begin
           if Edit6.Text = FDQuery1.FieldByName('Ingrediente').AsString then
           begin
             bFind := True;
             break;
           end;
          FDQuery1.Next;
        end;
	      FDQuery1.Close;

        //
        if bFind = True then
        begin
          FDQuery1.SQL.Text := 'UPDATE Ingredientes SET Preco = "' + Edit5.Text + '" WHERE Ingrediente = "' + ingr + '"';
          FDQuery1.ExecSQL;

          Label4.Caption := 'Msg: Ingredientes atualizado!';
        end
        else
          Label4.Caption := 'Msg: Ingrediente não cadastrado!';
      end;
  end
  else
  begin
    if Trim(Edit1.Text) = '' then
    begin
      Label4.Caption := 'Msg: Entre com o usuario!';
      Exit;
    end;

    if Trim(Edit2.Text) = '' then
    begin
      Label4.Caption := 'Msg: Entre com a senha!';
      Exit;
    end;

    if Trim(Edit3.Text) = '' then
    begin
      Label4.Caption := 'Msg: Entre com a nova senha!';
      Exit;
    end;

    //verifica se usuario existe
    usuario := Edit1.Text;
    senha := Edit2.Text;
    FDQuery1.SQL.Text := 'SELECT 1 FROM Login WHERE Usuario = :usuario and Senha = :senha';
    FDQuery1.ParamByName('Usuario').AsString := usuario;
    FDQuery1.ParamByName('Senha').AsString := senha;
    FDQuery1.Open;

    if not FDQuery1.IsEmpty then
    begin
      senha := Edit3.Text;
      FDQuery1.SQL.Text := 'UPDATE Login SET Senha = ' + senha + ' WHERE Usuario = "' + usuario + '"';
      FDQuery1.ExecSQL;
      if CheckBox1.Checked then
      begin
        FDQuery1.SQL.Text := 'UPDATE Login SET Nivel = 1 WHERE Usuario = "' + usuario + '"';
      end
      else
        FDQuery1.SQL.Text := 'UPDATE Login SET Nivel = 0 WHERE Usuario = "' + usuario + '"';

      FDQuery1.ExecSQL;

      Label4.Caption := 'Msg: Alteração de Usuario Ok!';
    end
    else
    begin
      Label4.Caption := 'Msg: Usuario ou Senha invalido!'
    end;

    FDQuery1.Close;
  end
end;

//excluir
procedure TForm1.Button5Click(Sender: TObject);
var
  bFind: Boolean;
  usuario, senha: string;
  numpedido: integer;
begin
  if ListBox1.Enabled then
  begin
    if RadioButton1.Checked then
    begin
      //verifica se pedido ja existe
      numpedido := StrToInt(Edit7.Text);
      FDQuery1.SQL.Text := 'SELECT 1 FROM Pedido WHERE NumPedido = :numpedido';
      FDQuery1.ParamByName('NumPedido').AsInteger := numpedido;
      FDQuery1.Open;

      if not FDQuery1.IsEmpty then
      begin
        FDQuery1.SQL.Text := 'DELETE FROM Pedido WHERE NumPedido = "' + Edit7.Text + '"';
        FDQuery1.ExecSQL;

        Label4.Caption := 'Msg: Exclusao de pedido Ok!';
      end
      else
        Label4.Caption := 'Msg: Pedido já excluido!';
      end
    else if RadioButton2.Checked then
    begin
      if nivel = 0 then
      begin
          Label4.Caption := 'Msg: Acesso nao autorizado!';
          exit;
      end;

      FDQuery1.SQL.Text := 'DELETE FROM Cardapio WHERE Lanche = "' + Edit4.Text + '"';
      FDQuery1.ExecSQL;

      Label4.Caption := 'Msg: Exclusao de lanche Ok!';
    end
    else
    begin
      if nivel = 0 then
      begin
        Label4.Caption := 'Msg: Acesso nao autorizado!';
        exit;
      end;

      bFind := False;
      //verifica se ingrediente existe
      FDQuery1.SQL.Text := 'SELECT * FROM Ingredientes';
      FDQuery1.Open;
      while not FDQuery1.Eof do
      begin
         if Edit6.Text = FDQuery1.FieldByName('Ingrediente').AsString then
         begin
           bFind := True;
           break;
         end;
        FDQuery1.Next;
      end;
      FDQuery1.Close;

      if bFind = True then
      begin
        FDQuery1.SQL.Text := 'DELETE FROM Ingredientes WHERE Ingrediente = "' + Edit6.Text + '"';
        FDQuery1.ExecSQL;

        Label4.Caption := 'Msg: Exclusao de ingredientes Ok!';
      end
      else
        Label4.Caption := 'Msg: Ingrediente não cadastrado!';
    end;

      FDQuery1.Close;
    end
  else
  begin
    if Trim(Edit1.Text) = '' then
    begin
      Label4.Caption := 'Msg: Entre com o usuario!';
      Exit;
    end;

    if Trim(Edit2.Text) = '' then
    begin
      Label4.Caption := 'Msg: Entre com a senha!';
      Exit;
    end;

    //verifica se usuario existe
    usuario := Edit1.Text;
    senha := Edit2.Text;
    FDQuery1.SQL.Text := 'SELECT 1 FROM Login WHERE Usuario = :usuario and Senha = :senha';
    FDQuery1.ParamByName('Usuario').AsString := usuario;
    FDQuery1.ParamByName('Senha').AsString := senha;
    FDQuery1.Open;

    if not FDQuery1.IsEmpty then
    begin
      FDQuery1.SQL.Text := 'DELETE FROM Login WHERE Usuario = :usuario';
      FDQuery1.ExecSQL;

      Label4.Caption := 'Msg: Exclusao de Usuario Ok!';
    end
    else
    begin
      Label4.Caption := 'Msg: Usuario ou Senha invalido!'
    end;
	
    FDQuery1.Close;
  end;
end;

//exibir
procedure TForm1.Button6Click(Sender: TObject);
var
  bFind: Boolean;
  Texto, TextAux, LstIngr, strAux :string;
  i, Tam, Totpreco :Integer;
  ListaIngr: array of string;
  ListaPreco: array of integer;
begin
  if not ListBox1.Enabled then
  begin
    Label4.Caption := 'Msg: Login não efetuado!'
  end
  else
  begin
    if RadioButton3.Checked then
    begin
      if nivel = 0 then
      begin
        Label4.Caption := 'Msg: Acesso nao autorizado!';
        exit;
      end;

      FDQuery1.SQL.Text := 'SELECT * FROM Ingredientes';
      FDQuery1.Open;

      ListBox1.Items.Clear;
      while not FDQuery1.Eof do
      begin
      if FDQuery1.FieldByName('Preco').AsInteger > 99 then
        Texto := Format('                  %d   %s',
        [FDQuery1.FieldByName('Preco').AsInteger, FDQuery1.FieldByName('Ingrediente').AsString])
      else if FDQuery1.FieldByName('Preco').AsInteger > 9 then
        Texto := Format('                  %d    %s',
        [FDQuery1.FieldByName('Preco').AsInteger, FDQuery1.FieldByName('Ingrediente').AsString])
      else
        Texto := Format('                  %d     %s',
        [FDQuery1.FieldByName('Preco').AsInteger, FDQuery1.FieldByName('Ingrediente').AsString]);

        ListBox1.Items.Add(Texto);
        FDQuery1.Next;
      end;
      Label4.Caption := 'Msg: Exibir Ingredientes efetuado!';
	  
	    FDQuery1.Close;
    end
    else if RadioButton1.Checked then
    begin
      //
      FDQuery1.SQL.Text := 'SELECT * FROM Pedido';
      FDQuery1.Open;

      ListBox1.Items.Clear;
      while not FDQuery1.Eof do
      begin
        Texto := Format('%d%s',
        [FDQuery1.FieldByName('NumPedido').AsInteger, FDQuery1.FieldByName('Pedido').AsString]);

        ListBox1.Items.Add(Texto);
        FDQuery1.Next;
      end;
      Label4.Caption := 'Msg: Exibir Pedidos efetuado!';
	  
	    FDQuery1.Close;
    end
    else
    begin
      if nivel = 0 then
      begin
          Label4.Caption := 'Msg: Acesso nao autorizado!';
          exit;
      end;

      //procura ingrediente na tabela Ingredientes
      SetLength(ListaIngr, 50);
      SetLength(ListaPreco, 50);
      i := 0;

      FDQuery1.SQL.Text := 'SELECT * FROM Ingredientes';
      FDQuery1.Open;
      while not FDQuery1.Eof do
      begin
         ListaIngr[i] := FDQuery1.FieldByName('Ingrediente').AsString;
         ListaPreco[i] := FDQuery1.FieldByName('Preco').AsInteger;
         Inc(i,1);
         if i >= 50 then
         begin
           Label4.Caption := 'Msg: Erro interno!';
           exit;
         end;
        FDQuery1.Next;
      end;
      FDQuery1.Close;
      //
      ListBox1.Items.Clear;

      FDQuery1.SQL.Text := 'SELECT * FROM Cardapio';
      FDQuery1.Open;
      while not FDQuery1.Eof do
      begin
        Totpreco := 0;
        Tam := Length(FDQuery1.FieldByName('Lanche').AsString);
        TextAux :=  '       ' + FDQuery1.FieldByName('Lanche').AsString;
        LstIngr := FDQuery1.FieldByName('ListaIngr').AsString;
        if Tam < 10 then
        begin
          for i  := 0 to (10 - Tam) do
          begin
            TextAux := TextAux + ' ';
          end
        end;

        i := 0;
        while ListaIngr[i] <> '' do
        begin
          if Pos(ListaIngr[i], LstIngr) > 0 then
            Totpreco := Totpreco + ListaPreco[i];
          inc(i, 1);
        end;

        if Totpreco >= 100 then
        begin
          strAux := TotPreco.ToString;
          if Length(strAux) = 3 then
            Texto := Format('%s%d   %s',[TextAux, Totpreco, LstIngr])
          else
            Texto := Format('%s%d  %s',[TextAux, Totpreco, LstIngr])
        end
        else if Totpreco >= 10 then
        begin
          strAux := TotPreco.ToString;
          if Length(strAux) = 2 then
            Texto := Format('%s%d    %s',[TextAux, Totpreco, LstIngr])
          else
            Texto := Format('%s%d   %s',[TextAux, Totpreco, LstIngr])
        end
        else
        begin
          strAux := TotPreco.ToString;
          if Length(strAux) = 1 then
            Texto := Format('%s%d     %s',[TextAux, Totpreco, LstIngr])
          else
            Texto := Format('%s%d    %s',[TextAux, Totpreco, LstIngr]);
        end;
        ListBox1.Items.Add(Texto);
        FDQuery1.Next;
      end;
      Label4.Caption := 'Msg: Exibir Cardapio efetuado!';
	  
	    FDQuery1.Close;
    end;
    end
end;

//cancelar
procedure TForm1.Button4Click(Sender: TObject);
begin
  Close;
end;

//limpar
procedure TForm1.Button7Click(Sender: TObject);
begin
  ListBox1.Items.Clear;
end;

end.
