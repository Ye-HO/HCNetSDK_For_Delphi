program RealTimePlayer;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  HCNetSDK in '..\Source\SDK\HCNetSDK.pas',
  uNVR in 'uNVR.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
