unit ULogging;

interface
uses classes;
type
  TLog=class
    _Disabled:TStringList;
    _LogCache:TStringList;
    _ChatlogFile:System.Text;
    _writechatlog:boolean;
    constructor create;
    procedure OpenChatLog(bot_id:string);
    Procedure Disable(kind:string);
    procedure Enable(kind:string);
    Procedure Log(s:string);overload;
    Procedure Log(kind:string;s:string);overload;
    procedure Flush;
    Procedure ChatLog(who,what:string);
    destructor destroy;override;
  end;
var
  Log:TLog;
implementation
uses UChat,SysUtils;
  constructor TLog.create;
    begin
      inherited Create;
      _LogCache:=TStringList.Create;
      _Disabled:=TStringList.Create;
      _Disabled.Duplicates:=dupIgnore;
      _writechatlog:=false;
    end;
  destructor TLog.Destroy;
    begin
      _Disabled.Free;
      _LogCache.Free;
      if _writechatlog then
        closefile(_chatlogfile);
      inherited destroy;
    end;
  procedure TLog.OpenChatLog(bot_id:string);
    begin
      try
        AssignFile(_ChatlogFile,bot_id+'.chatlog');
        if FileExists(bot_id+'.chatlog') then
          Append(_ChatLogFile)
        else
          rewrite(_ChatLogFile);
        Writeln(_ChatLogFile);
        Writeln(_ChatLogFile,DateTimeToStr(now));

        _writechatlog:=true;
        Log('Log','Os logs do chat ser�o armazenados no arquivo: ' + bot_id + '.chatlog');
      except
        _writechatlog:=false;
        Log('Log','N�o � possivel gravar o log do chat, o log sera desativado');
      end;
    end;
  procedure Tlog.Disable(kind:string);
    begin
      _Disabled.Add(kind);
    end;
  procedure Tlog.Enable(kind:string);
    var
      i:integer;
    begin
      i:=_Disabled.Indexof(kind);
      if i>=0 then
        _Disabled.Delete(i);
    end;
  procedure TLog.Flush;
    var i:integer;
    begin
      if assigned(frmJohnHammond) then begin
        for i:=0 to _LogCache.count-1 do
          frmJohnHammond.AddLogMessage(_LogCache.Strings[i]);
         _LogCache.Clear;
      end;
    end;
  Procedure TLog.Log(kind:string;s:string);
    begin
      if _Disabled.indexof(kind)=-1 then
        Log(kind+': '+s)
    end;
  Procedure TLog.Log(s:string);
    begin
      if assigned(frmJohnHammond) then
       // Comentado para tirar ao informa��es dos arquivos carregados
       // frmJohnHammond.AddLogMessage(s)
      else
        _LogCache.Add(s);
    end;
  Procedure TLog.ChatLog(who,what:string);
    begin
      if _writechatlog then
        Writeln(_chatlogfile,Who,'> ',what);
    end;
end.
