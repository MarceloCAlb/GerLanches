object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'GerLanches - V1.0.0.0'
  ClientHeight = 458
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = OnCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 31
    Top = 19
    Width = 43
    Height = 15
    Caption = 'Usuario:'
  end
  object Label2: TLabel
    Left = 39
    Top = 46
    Width = 35
    Height = 15
    Caption = 'Senha:'
  end
  object Label3: TLabel
    Left = 8
    Top = 74
    Width = 66
    Height = 15
    Caption = 'Senha Nova:'
  end
  object Label4: TLabel
    Left = 8
    Top = 433
    Width = 26
    Height = 15
    Caption = 'Msg:'
  end
  object Label5: TLabel
    Left = 9
    Top = 224
    Width = 239
    Height = 15
    Caption = 'Pedido     Lanche            Preco      Ingredientes'
    Enabled = False
  end
  object Label6: TLabel
    Left = 106
    Top = 145
    Width = 38
    Height = 15
    Caption = 'Lanche'
    Enabled = False
  end
  object Label7: TLabel
    Left = 88
    Top = 172
    Width = 60
    Height = 15
    Caption = 'Ingrediente'
    Enabled = False
  end
  object Label8: TLabel
    Left = 14
    Top = 172
    Width = 30
    Height = 15
    Caption = 'Pre'#231'o'
    Enabled = False
  end
  object Label9: TLabel
    Left = 8
    Top = 145
    Width = 37
    Height = 15
    Caption = 'Pedido'
    Enabled = False
  end
  object Label10: TLabel
    Left = 8
    Top = 197
    Width = 37
    Height = 15
    Caption = 'Cliente'
    Enabled = False
  end
  object Button1: TButton
    Left = 199
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 80
    Top = 11
    Width = 113
    Height = 23
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 80
    Top = 43
    Width = 113
    Height = 23
    TabOrder = 2
  end
  object Edit3: TEdit
    Left = 80
    Top = 74
    Width = 113
    Height = 23
    TabOrder = 3
  end
  object Button2: TButton
    Left = 99
    Top = 106
    Width = 75
    Height = 25
    Caption = 'Alterar'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 106
    Width = 75
    Height = 25
    Caption = 'Incluir'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 285
    Top = 428
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = Button4Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 245
    Width = 351
    Height = 178
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    ScrollWidth = 1000
    TabOrder = 7
  end
  object Button5: TButton
    Left = 191
    Top = 106
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 8
    OnClick = Button5Click
  end
  object Edit4: TEdit
    Left = 152
    Top = 140
    Width = 88
    Height = 23
    Enabled = False
    MaxLength = 10
    TabOrder = 9
  end
  object Edit5: TEdit
    Left = 47
    Top = 168
    Width = 37
    Height = 23
    Enabled = False
    MaxLength = 3
    NumbersOnly = True
    TabOrder = 10
  end
  object Edit6: TEdit
    Left = 152
    Top = 169
    Width = 89
    Height = 23
    Enabled = False
    MaxLength = 50
    TabOrder = 11
  end
  object CheckBox1: TCheckBox
    Left = 200
    Top = 49
    Width = 102
    Height = 17
    Caption = 'Acesso Lanches'
    TabOrder = 12
  end
  object Edit7: TEdit
    Left = 47
    Top = 142
    Width = 37
    Height = 23
    Enabled = False
    MaxLength = 4
    NumbersOnly = True
    TabOrder = 13
  end
  object Button6: TButton
    Left = 284
    Top = 106
    Width = 75
    Height = 25
    Caption = 'Exibir'
    Enabled = False
    TabOrder = 14
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 204
    Top = 428
    Width = 75
    Height = 25
    Caption = 'Limpar'
    TabOrder = 15
    OnClick = Button7Click
  end
  object RadioGroup1: TRadioGroup
    Left = 251
    Top = 135
    Width = 108
    Height = 104
    Caption = 'Op'#231#227'o'
    Enabled = False
    TabOrder = 16
  end
  object RadioButton1: TRadioButton
    Left = 266
    Top = 161
    Width = 81
    Height = 17
    Caption = 'Pedido'
    Checked = True
    Enabled = False
    TabOrder = 17
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 266
    Top = 184
    Width = 65
    Height = 17
    Caption = 'Lanche'
    Enabled = False
    TabOrder = 18
  end
  object RadioButton3: TRadioButton
    Left = 266
    Top = 209
    Width = 81
    Height = 17
    Caption = 'Ingrediente'
    Enabled = False
    TabOrder = 19
  end
  object Edit8: TEdit
    Left = 47
    Top = 194
    Width = 90
    Height = 23
    Enabled = False
    TabOrder = 20
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 208
    Top = 8
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 240
    Top = 8
  end
  object FDStoredProc1: TFDStoredProc
    Connection = FDConnection1
    Left = 272
    Top = 8
  end
end
