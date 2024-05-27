unit ThreadLoadPrew;

interface

uses
  Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  LoadPrew = class(TThread)
    IdHTTP1: TIdHTTP;
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  realImageUrl: string;

implementation

uses UnitMain;

{ LoadPrew }

procedure LoadPrew.Execute;
Var
  S: TMemoryStream;
  len: integer;
  str: string;
begin
  { Place thread code here }
  Try
    S := TMemoryStream.Create;
    IdHTTP1 := TIdHTTP.Create;
    IdHTTP1.HandleRedirects := true;
    IdHTTP1.Get(IMGPrewUrl, S);
    realImageUrl := IdHTTP1.Request.url;
    len := length(realImageUrl);
    str := realImageUrl[len - 2] + realImageUrl[len - 1] + realImageUrl[len];
    S.SaveToFile('prew.' + str);
    MainForm.ImagePrew.Picture.LoadFromFile('prew.' + str);
  Finally
    S.Free;
  End;
  Terminate;
  if Terminated then
    exit;
end;

end.
