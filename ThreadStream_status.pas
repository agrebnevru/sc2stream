unit ThreadStream_status;

interface

uses
  Classes, ADODB, DB, idhttp, ActiveX, SysUtils;

type
  StreamStatus = class(TThread)
    ADOC1: TADOConnection;
    Streams: TADOTable;
    StreamsDS: TDataSource;
    ADOQ1: TADOQuery;
    ADOQ2: TADOQuery;
    idhttp1: TIdHTTP;
    procedure SetSettings;
    procedure CheckStatus(service: integer; id: string);
    procedure SetStatus(status, id: string);
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  index: integer;

implementation

uses UnitMain;

{ StreamStatus }

procedure StreamStatus.SetSettings;
begin
  ADOC1 := TADOConnection.Create(nil);
  Streams := TADOTable.Create(nil);
  StreamsDS := TDataSource.Create(nil);
  ADOQ1 := TADOQuery.Create(nil);
  ADOQ2 := TADOQuery.Create(nil);
  // ADOConnection
  ADOC1.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=D:\Programming\delphi_2010\__sc2stream\db.mdb;';
  ADOC1.ConnectionString := ADOC1.ConnectionString +
    'Mode=Share Deny None;Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="jw4d2n3g3eohd";';
  ADOC1.ConnectionString := ADOC1.ConnectionString +
    'Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;';
  ADOC1.ConnectionString := ADOC1.ConnectionString +
    'Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don''t Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False;';
  ADOC1.LoginPrompt := false;
  ADOC1.Mode := cmShareDenyNone;
  ADOC1.Provider := 'Microsoft.Jet.OLEDB.4.0';
  ADOC1.Connected := true;
  // ADOTable
  Streams.Connection := ADOC1;
  Streams.CursorType := ctStatic;
  Streams.IndexName := 'PrimaryKey';
  Streams.TableName := 'Streams';
  // DataSource
  StreamsDS.DataSet := Streams;
  StreamsDS.DataSet.Open;
  StreamsDS.Enabled := true;
  // ADOQuery
  ADOQ1.Connection := ADOC1;
  ADOQ1.DataSource := StreamsDS;
  // ADOQuery
  ADOQ2.Connection := ADOC1;
  ADOQ2.DataSource := StreamsDS;
end;

procedure StreamStatus.CheckStatus(service: integer; id: string);
var
  html: string;
begin
  idhttp1 := TIdHTTP.Create(nil);
  idhttp1.ReadTimeout := 3000;
  sleep(1000);
  MainForm.Memo1.Lines.Add('---------------------');
  try
    case service of
      1: // own3d
        begin
          MainForm.Memo1.Lines.Add
            ('http://static.ec.own3d.tv/live_tmp/' + string(id) + '.txt');
          html := idhttp1.Get('http://static.ec.own3d.tv/live_tmp/' + string
              (id) + '.txt');
          if html = 'liveViewers=0&liveStatus=false&liveVerified=1' then
            SetStatus('off', id)
          else
            SetStatus('on', id);
        end;
      2: // justin
        begin
          MainForm.Memo1.Lines.Add
            ('http://api.justin.tv/api/stream/search/' + string(id) + '.json');
          html := idhttp1.Get('http://api.justin.tv/api/stream/search/' + string
              (id) + '.json');
          if length(html) < 5 then
            SetStatus('off', id)
          else
            SetStatus('on', id);
        end;
      3: // regame
        begin
          MainForm.Memo1.Lines.Add(
            'http://www.regame.tv/liveview_xml_multiple.php?stream_ids=' +
              string(id));
          html := idhttp1.Get(
            'http://www.regame.tv/liveview_xml_multiple.php?stream_ids=' +
              string(id));
          if pos('<online>true</online>', html) > 1 then
            SetStatus('on', id)
          else
            SetStatus('off', id);
        end;
    end;
  finally
    idhttp1.Free;
  end;
end;

procedure StreamStatus.SetStatus(status, id: string);
begin
  ADOQ1.SQL.Clear;
  ADOQ1.SQL.Add('UPDATE streams SET status = ''' + status +
      ''' WHERE stream_id = ''' + id + ''' ');
  ADOQ1.ExecSQL;
end;

procedure StreamStatus.Execute;
var
  i, service: integer;
  stream_id: string;
begin
  while not Terminated do
  begin
    CoInitialize(nil);
    // Установка настроек
    SetSettings;
    { Place thread code here }
    ADOQ2.SQL.Clear;
    ADOQ2.SQL.Add('SELECT * FROM streams');
    // ADOQ2.SQL.Add('LIMIT 0,20');
    ADOQ2.Open;
    Streams.Open;
    while not ADOQ2.Eof do
    begin
      service := ADOQ2.Fields[3].AsInteger;
      stream_id := ADOQ2.Fields[9].AsString;
      CheckStatus(service, stream_id);
      ADOQ2.Next;
    end;
    Synchronize(MainForm.RefreshMain);
    ADOC1.Free;
    Streams.Free;
    StreamsDS.Free;
    ADOQ1.Free;
    ADOQ2.Free;
    Terminate;
    if Terminated then
      exit;
  end;
end;

end.
