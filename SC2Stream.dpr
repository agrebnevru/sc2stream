program SC2Stream;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {MainForm},
  ShockwaveFlashObjects_TLB in 'C:\Users\Алексей\Documents\RAD Studio\7.0\Imports\ShockwaveFlashObjects_TLB.pas',
  UnitViewer in 'UnitViewer.pas' {FormViewer},
  ThreadLoadPrew in 'ThreadLoadPrew.pas',
  ThreadStream_status in 'ThreadStream_status.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormViewer, FormViewer);
  Application.Run;
end.
