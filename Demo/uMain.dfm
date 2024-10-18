object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Real Time Player'
  ClientHeight = 641
  ClientWidth = 1034
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 13
  object PanelHeader: TPanel
    Left = 0
    Top = 0
    Width = 1034
    Height = 41
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object LabelRecorderIP: TLabel
      Left = 11
      Top = 13
      Width = 57
      Height = 13
      Caption = 'Recorder IP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelUserName: TLabel
      Left = 262
      Top = 13
      Width = 49
      Height = 13
      Caption = 'UserName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelPassword: TLabel
      Left = 409
      Top = 13
      Width = 46
      Height = 13
      Caption = 'Password'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelChannalNo: TLabel
      Left = 660
      Top = 13
      Width = 55
      Height = 13
      Caption = 'Channal No'
    end
    object LabelPort: TLabel
      Left = 179
      Top = 12
      Width = 20
      Height = 13
      Caption = 'Port'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 842
      Top = 12
      Width = 83
      Height = 13
      Caption = 'Stream Password'
    end
    object EditRecorderIP: TEdit
      Left = 72
      Top = 9
      Width = 92
      Height = 21
      Alignment = taCenter
      TabOrder = 0
    end
    object EditUserName: TEdit
      Left = 315
      Top = 9
      Width = 80
      Height = 21
      Alignment = taCenter
      TabOrder = 2
      Text = 'admin'
    end
    object EditPassword: TEdit
      Left = 461
      Top = 9
      Width = 87
      Height = 21
      Alignment = taCenter
      PasswordChar = '*'
      TabOrder = 3
    end
    object ComboBoxChannalNo: TComboBox
      Left = 717
      Top = 9
      Width = 59
      Height = 21
      DropDownCount = 32
      TabOrder = 4
      OnChange = ComboBoxChannalNoChange
    end
    object ButtonPrior: TButton
      Left = 782
      Top = 8
      Width = 23
      Height = 23
      Caption = '<'
      TabOrder = 5
      OnClick = ButtonPriorClick
    end
    object ButtonNext: TButton
      Left = 809
      Top = 8
      Width = 23
      Height = 23
      Caption = '>'
      TabOrder = 6
      OnClick = ButtonNextClick
    end
    object ButtonPlay: TButton
      Left = 560
      Top = 6
      Width = 88
      Height = 27
      Caption = 'Play'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = ButtonPlayClick
    end
    object EditPort: TEdit
      Left = 204
      Top = 9
      Width = 43
      Height = 21
      Alignment = taCenter
      TabOrder = 1
      Text = '8000'
    end
    object EditStreamPassword: TEdit
      Left = 931
      Top = 9
      Width = 87
      Height = 21
      Alignment = taCenter
      PasswordChar = '*'
      TabOrder = 8
    end
  end
  object PanelPlay: TPanel
    Left = 0
    Top = 41
    Width = 1034
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 39
  end
end
