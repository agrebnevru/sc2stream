unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, FlashViewers, StdCtrls, fe_flashplayer, HTMLabel, OleCtrls,
  SHDocVw, ComCtrls, ToolWin, ImgList, jpeg, TeCanvas, TeeEdiGrad, Buttons,
  pngimage, Grids, DB, DBGrids, ADODB, Menus, ShellAPI, Clipbrd, acPNG,
  ThreadLoadPrew, ThreadStream_status, JvExControls, JvAnimatedImage,
  JvGIFCtrl, ActiveX;

type
  TMainForm = class(TForm)
    TI1: TTrayIcon;
    IL1: TImageList;
    BiggestPanel: TPanel;
    BigPanel: TPanel;
    LeftMenuPanel: TPanel;
    TopPanel: TPanel;
    TopToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    DownPanel_New_ver: TPanel;
    LabelAboutStream: THTMLabel;
    TrayPM: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    DBGridStream: TDBGrid;
    Streams: TADOTable;
    Streamsid: TAutoIncField;
    StreamsDS: TDataSource;
    ADOC1: TADOConnection;
    Streamsstream_name: TStringField;
    Streamsstatus: TStringField;
    FiltrPanel: TPanel;
    Streamsurl: TStringField;
    ToolBarFiltr: TToolBar;
    OnlyOnButton: TToolButton;
    PanelAboutDown: TPanel;
    AboutLabel: THTMLabel;
    ToolBarGameFiltr: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    PMGrid: TPopupMenu;
    N5: TMenuItem;
    url1: TMenuItem;
    Streamslink_on_stream_page: TStringField;
    OnlyChoseGameButton: TToolButton;
    ToolButton13: TToolButton;
    ImagePrew: TImage;
    Streamsimg_url: TStringField;
    ViewerOnTopButton: TToolButton;
    ToolButton2: TToolButton;
    ToolButton12: TToolButton;
    ToolButton14: TToolButton;
    ToolButtonLangFiltr: TToolButton;
    Streamslang: TStringField;
    Streamsabout: TWideMemoField;
    ToolButtonSettings: TToolButton;
    TRefr: TTimer;
    AnimatedGrid: TJvGIFAnimator;
    ToolButtonSmallFW: TToolButton;
    Memo1: TMemo;
    //
    procedure send_grid_filter;
    procedure send_grid_filter_game(game: string);
    procedure RefreshMain;
    procedure OpenStream;
    //
    procedure TopPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure OnlyOnButtonClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridStreamDblClick(Sender: TObject);
    procedure DBGridStreamCellClick(Column: TColumn);
    procedure N5Click(Sender: TObject);
    procedure url1Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure OnlyChoseGameButtonClick(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ImagePrewClick(Sender: TObject);
    procedure ViewerOnTopButtonClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButtonLangFiltrClick(Sender: TObject);
    procedure TRefrTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolButtonSmallFWClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  thrd1: LoadPrew;
  thrd2: array [0 .. 50] of StreamStatus;
  MainForm: TMainForm;
  pointer: Integer;
  game_filtr, IMGPrewUrl: string;
  str_filter: array [0 .. 2] of string;
  // 0 - game
  // 1 - on/off
  // 1 - language

implementation

uses UnitViewer;
{$R *.dfm}

procedure TMainForm.OpenStream;
begin
  FormViewer := TFormViewer.Create(Application);
  FormViewer.Show;
  FormViewer.StreamViewer.Navigate
    (DBGridStream.DataSource.DataSet.Fields[3].AsString);
end;

procedure TMainForm.RefreshMain;
begin
  sleep(1000);
  Streams.Close;
  sleep(100);
  Streams.Open;
  DBGridStream.Visible := true;
  AnimatedGrid.Visible := false;
end;

procedure TMainForm.send_grid_filter;
begin
  Streams.Filtered := false;
  Streams.Filter := str_filter[1];
  if (length(str_filter[1]) > 1) and (length(str_filter[0]) > 1) then
    Streams.Filter := Streams.Filter + ' AND ';
  Streams.Filter := Streams.Filter + str_filter[0];
  if ((length(str_filter[0]) > 1) or (length(str_filter[1]) > 1)) and
    (length(str_filter[2]) > 1) then
    Streams.Filter := Streams.Filter + ' AND ';
  Streams.Filter := Streams.Filter + str_filter[2];

  Streams.Filtered := true;
end;

procedure TMainForm.send_grid_filter_game(game: string);
begin
  str_filter[0] := '';
  if OnlyChoseGameButton.Down then
    str_filter[0] := 'game = ''' + game + ''''
  else
    str_filter[0] := 'game like ''*' + game + '*''';
  game_filtr := game;
  send_grid_filter;
end;

procedure TMainForm.DBGridStreamCellClick(Column: TColumn);
begin
  AboutLabel.HTMLText.Text := DBGridStream.DataSource.DataSet.Fields[7]
    .AsString;
  IMGPrewUrl := DBGridStream.DataSource.DataSet.Fields[5].AsString;
  thrd1 := LoadPrew.Create(true);
  thrd1.FreeOnTerminate := true;
  thrd1.Priority := tpLower;
  thrd1.Resume;
end;

procedure TMainForm.DBGridStreamDblClick(Sender: TObject);
begin
  OpenStream;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  thrd2[0].Terminate;
  thrd2[0].WaitFor;
  thrd2[0].Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  rgn: HRGN;
begin
  MainForm.Borderstyle := bsNone;
  rgn := CreateRoundRectRgn(0, 0, ClientWidth, ClientHeight, 12, 12);
  SetWindowRgn(Handle, rgn, true);
  CoInitialize(nil);

  thrd2[0] := StreamStatus.Create(true);
  thrd2[0].FreeOnTerminate := false;
  thrd2[0].Priority := tpLower;
  index:= 4;
  thrd2[0].Resume;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  Streams.Open;
end;

procedure TMainForm.ImagePrewClick(Sender: TObject);
begin
  OpenStream;
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
  if DBGridStream.SelectedIndex >= 0 then
    ShellExecute(0, 'Open',
      PChar(DBGridStream.DataSource.DataSet.Fields[4].AsString), nil, nil,
      SW_SHOW);
end;

procedure TMainForm.TopPanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TMainForm.TRefrTimer(Sender: TObject);
begin
  thrd2[0] := StreamStatus.Create(true);
  thrd2[0].FreeOnTerminate := false;
  thrd2[0].Priority := tpLower;
  thrd2[0].Resume;
end;

procedure TMainForm.url1Click(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(DBGridStream.DataSource.DataSet.Fields[4].AsString)
    );
end;

procedure TMainForm.ViewerOnTopButtonClick(Sender: TObject);
begin
  if ViewerOnTopButton.Down then
    FormViewer.FormStyle := fsStayOnTop
  else
    FormViewer.FormStyle := fsNormal;
end;

procedure TMainForm.ToolButton10Click(Sender: TObject);
begin
  send_grid_filter_game('misc');
end;

procedure TMainForm.ToolButton11Click(Sender: TObject);
begin
  send_grid_filter_game('wow');
end;

procedure TMainForm.ToolButton12Click(Sender: TObject);
begin
  send_grid_filter_game('css');
end;

procedure TMainForm.OnlyChoseGameButtonClick(Sender: TObject);
begin
  if length(str_filter[0]) > 1 then
    send_grid_filter_game(game_filtr);
end;

procedure TMainForm.ToolButton13Click(Sender: TObject);
begin
  str_filter[0] := '';
  send_grid_filter;
end;

procedure TMainForm.ToolButton1Click(Sender: TObject);
begin
  Application.Minimize
end;

procedure TMainForm.ToolButton2Click(Sender: TObject);
begin
  send_grid_filter_game('cs');
end;

procedure TMainForm.OnlyOnButtonClick(Sender: TObject);
begin
  if OnlyOnButton.Down then
  begin
    OnlyOnButton.ImageIndex := 4;
    str_filter[1] := 'status = ''on''';
  end
  else
  begin
    OnlyOnButton.ImageIndex := 3;
    str_filter[1] := '';
  end;
  send_grid_filter;
end;

procedure TMainForm.ToolButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ToolButton4Click(Sender: TObject);
begin
  send_grid_filter_game('diablo');
end;

procedure TMainForm.ToolButton5Click(Sender: TObject);
begin
  send_grid_filter_game('scbw');
end;

procedure TMainForm.ToolButton6Click(Sender: TObject);
begin
  send_grid_filter_game('sc2');
end;

procedure TMainForm.ToolButton7Click(Sender: TObject);
begin
  send_grid_filter_game('warcraft');
end;

procedure TMainForm.ToolButton8Click(Sender: TObject);
begin
  send_grid_filter_game('dota');
end;

procedure TMainForm.ToolButton9Click(Sender: TObject);
begin
  send_grid_filter_game('lol');
end;

procedure TMainForm.ToolButtonLangFiltrClick(Sender: TObject);
begin
  if ToolButtonLangFiltr.Down then
  begin
    ToolButtonLangFiltr.ImageIndex := 17;
    str_filter[2] := 'lang = ''ru''';
  end
  else
  begin
    ToolButtonLangFiltr.ImageIndex := 18;
    str_filter[2] := '';
  end;
  send_grid_filter;
end;

procedure TMainForm.ToolButtonSmallFWClick(Sender: TObject);
begin
  if ToolButtonSmallFW.Down then
  begin
    FormViewer.Borderstyle := bsNone;
  end
  else
  begin
    FormViewer.Borderstyle := bsSizeable;
  end;
end;

end.
