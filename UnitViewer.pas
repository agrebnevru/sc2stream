unit UnitViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, acPNG;

type
  TFormViewer = class(TForm)
    StreamViewer: TWebBrowser;
    ImageMoveHand: TImage;
    procedure StreamViewerDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageMoveHandMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StreamViewerBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  FormViewer: TFormViewer;
  chislo: boolean;

implementation

uses UnitMain;
{$R *.dfm}

procedure TFormViewer.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := WS_EX_APPWINDOW;
end;

procedure TFormViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StreamViewer.Navigate('blank');
end;

procedure TFormViewer.FormCreate(Sender: TObject);
begin
  chislo := false;
end;

procedure TFormViewer.FormShow(Sender: TObject);
begin
  if (MainForm.ViewerOnTopButton.Down = true) then
  begin
    SetWindowLong(Handle, GWL_HWNDPARENT, GetDesktopWindow);
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end;
end;

procedure TFormViewer.ImageMoveHandMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TFormViewer.StreamViewerBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if chislo = true then
    Cancel := chislo;
  chislo := true;
end;

procedure TFormViewer.StreamViewerDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  width := width + 1;
  height := height + 1;
end;

end.
