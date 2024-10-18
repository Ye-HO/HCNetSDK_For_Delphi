unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  uNVR;

type
  TMainForm = class(TForm)
    PanelHeader: TPanel;
    PanelPlay: TPanel;
    EditRecorderIP: TEdit;
    EditUserName: TEdit;
    EditPassword: TEdit;
    ComboBoxChannalNo: TComboBox;
    ButtonPrior: TButton;
    ButtonNext: TButton;
    LabelRecorderIP: TLabel;
    LabelUserName: TLabel;
    LabelPassword: TLabel;
    LabelChannalNo: TLabel;
    ButtonPlay: TButton;
    LabelPort: TLabel;
    EditPort: TEdit;
    Label1: TLabel;
    EditStreamPassword: TEdit;
    procedure ButtonPlayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxChannalNoChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonPriorClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure Play;
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    NVR: TNVR;
    Playing: Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

  Playing := False;
  NVR := TNVR.Create;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Playing then NVR.StopPlaying;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  NVR.Free;
end;

procedure TMainForm.ButtonPriorClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ComboBoxChannalNo.ItemIndex - 1;
  if Index < 0  then
     Index := ComboBoxChannalNo.Items.Count - 1;
  ComboBoxChannalNo.ItemIndex := Index;
  Play;
end;

procedure TMainForm.ButtonNextClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ComboBoxChannalNo.ItemIndex + 1;
  if Index >= ComboBoxChannalNo.Items.Count then
    Index := 0;
  ComboBoxChannalNo.ItemIndex := Index;
  Play;
end;

procedure TMainForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ButtonPriorClick(nil)
end;

procedure TMainForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ButtonNextClick(nil);
end;

procedure TMainForm.ButtonPlayClick(Sender: TObject);
var
  I: Integer;
  RecorderIP, Port, UserName, Password, StreamPassword: String;
begin
  RecorderIP := EditRecorderIP.Text;
  Port := EditPort.Text;
  UserName := EditUserName.Text;
  Password :=  EditPassword.Text;
  StreamPassword :=  EditStreamPassword.Text;
  NVR.Connect(RecorderIP, Port, UserName, Password, StreamPassword);
  if NVR.Connected then
  begin
    ComboBoxChannalNo.Clear;
    for I := 0 to NVR.ChannelList.Count-1 do
    begin
      ComboBoxChannalNo.Items.Add('D' + NVR.ChannelList[I]);
    end;
  end;
  ComboBoxChannalNo.Text := 'D' + NVR.ChannelList[0];
  ComboBoxChannalNoChange(nil);
end;

procedure TMainForm.ComboBoxChannalNoChange(Sender: TObject);
begin
  Play;
end;

procedure TMainForm.Play;
var
  S: String;
  ChNo: UInt16;
begin
  S := ComboBoxChannalNo.Text;
  S := Copy(S, 2, 10);
  ChNo := S.ToInteger;
  if Playing then NVR.StopPlaying;
  NVR.StartPlaying(PanelPlay.Handle, ChNo);
  Playing := True;
end;

end.
