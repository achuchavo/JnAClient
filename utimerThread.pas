unit utimerThread;

interface
  uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    //
    dateutils,
    //TMyCOnnection Units
    Data.DB, DBAccess, MyAccess,
    //TMyQuery Units
    MemDS,
    //
    IdBaseComponent, IdComponent,
    IdTCPConnection, IdTCPClient, IdHTTP,
    //
    System.IOUtils,
    System.JSON,
    Dialogs;
  type
  TTimerThread = class(TThread)
  private
    FTickEvent: THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(someText : String);
    destructor Destroy; override;
    procedure FinishThreadExecution;
    procedure moveVote_toJna(around : Integer);

    function aloopRound : String;
    var
      aText : String;
      isRoundNine,isRoundZero : Boolean;
      voters_list : TStringlist;
  end;
implementation
  uses
    uMain,uvoteforjna;

{ TTimerThread }

function TTimerThread.aloopRound: String;
var
  json: string;
  lHTTP: TIdHTTP;
  lParamList: TStringList;
  DataToSend : TStringStream;
  tim_hex_val : String;
  obj, data: TJSONObject;
  aloop_raw : extended;
  response : string;
  aloop : string;
begin


     result := '';
     try
        json := sLineBreak  +
                ' {' + sLineBreak  +
                ' "jsonrpc":"2.0",' + sLineBreak  +
                ' "method":"alien_getSnapshot", ' + sLineBreak  +
                '   "params":[],' + sLineBreak  +
                ' "id":67}' ;
        DataToSend := TStringStream.Create(json, TEncoding.UTF8);
        lParamList := TStringList.Create;
        lParamList.Add(json);
        try
          try
            lHTTP := TIdHTTP.Create(nil);
            lHTTP.request.useragent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; MAAU)';
            lHTTP.ConnectTimeout := 4000;
            lHTTP.ReadTimeout    := 3000;  // 2 seconds
            try
              lHTTP.Request.ContentType := 'application/json';
              response := lHTTP.Post('http://rpc-tokyo.ttcnet.io', DataToSend);
            finally
              freeandnil(lHTTP);
            end;
            except on e : exception do
              begin
                 freeandnil(lParamList);
                 FreeAndnil(DataToSend);
              end;

          end;
        finally
          freeandnil(lParamList);
          FreeAndnil(DataToSend);
        end;

        obj := TJSONObject.Create;
        obj := TJSONObject.ParseJSONValue(response) as TJSONObject;
        try
           data := obj.Values['result'] as TJSONObject;
           aloop_raw := strtofloat(data.Values['loopStartTime'].Value);
           aloop := formatfloat('0.0',frac((aloop_raw-1563817680)/630));
           result := aloop;
        finally
          obj.Free;
        end;
     except on e : exception do
       begin
         result := '';
       end;

     end;
end;

constructor TTimerThread.Create(someText : String);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FTickEvent := CreateEvent(nil, True, False, nil);
  atext := someText;
end;

destructor TTimerThread.Destroy;
begin
  CloseHandle(FTickEvent);
  inherited;
end;

procedure TTimerThread.Execute;
var
  aRound : String;
  i : Integer;
  aaddr,aenhance : String;
begin
  voters_list := TStringlist.Create;
  voters_list.Duplicates := dupAccept;
  while not Terminated do
  begin
    if WaitForSingleObject(FTickEvent, 1000) = WAIT_TIMEOUT then
    begin
          aRound := aloopRound;
          Synchronize(procedure
                      begin
                       // fmMain.memo2.Lines.Add(aRound);  //Current Mining Round :
                        fmMain.lbl_round.caption := 'Current Mining Round :' +aRound;
                      end
                     );
          if aRound = '0.9' then
          begin
            isRoundZero := false;
            if not isRoundNine then
             begin
             // voters_list.Clear;
              Synchronize(procedure
                            begin
                              fmMain.lbl_info.Caption := 'Move Vote! [Round = 0.9] '+
                              datetimetostr(now);
                              fmMain.memo1.clear;
                            end
                           );
              isRoundNine := true;
              moveVote_toJna(9);

             end;
          end
          else if aRound = '0.0' then
          begin
           isRoundNine := false;
            if not isRoundZero then
            begin

              Synchronize(procedure
                            begin
                              fmMain.lbl_info.Caption := 'Vote for Rep! [Round = 0.0] '+
                              datetimetostr(now);
                              fmMain.memo1.clear;
                            end
                           );
              isRoundZero := True;
              moveVote_toJna(0);
            end;

          end
          else
          begin
            isRoundNine := false;
            isRoundZero := false;
            if voters_list.Count > 0 then
            begin
              for I := voters_list.Count-1 downto 0 do
               begin
                  aaddr :=  voters_list.Names[i];
                  aenhance :=  voters_list.Values[voters_list.Names[i]];
                  if aenhance = aRound then
                   begin
                        Synchronize(procedure
                                      begin
                                        fmMain.memo3.Lines.Add(aaddr);
                                        fmMain.memo3.Lines.Add(aenhance);
                                        fmMain.memo3.Lines.Add('---------');
                                      end
                                     );
                        voters_list.Delete(i);
                   end;
               end;
            end;
          end;
    end;
  end;

end;

procedure TTimerThread.FinishThreadExecution;
begin
  Terminate;
  SetEvent(FTickEvent);
end;

procedure TTimerThread.moveVote_toJna(aRound : Integer);
var
  nthreads : array of TVoteForJnA;
  i : integer;
  ajump_time : integer;
  aconn : Tmyconnection;
  aquery : TMyquery;
  aaddr : String;
  aRecCount : Integer;
  arecNo : Integer;
  aenhance,aholder : String;

begin
     aconn := TMyconnection.Create(nil);
     try
      try
       aConn.Close;
       aconn.Options.UseUnicode := true;
       aConn.Server := fmMain.edt_host.text;
       aConn.Port := fmMain.spin_port.Value;
       aConn.Username := fmMain.edt_username.text;
       aConn.Password := fmMain.edt_password.text;
       aConn.Database := fmMain.edt_database.text;
       aConn.LoginPrompt := False;
       aConn.Open;
       if aconn.Connected then
        begin
           aquery := tmyquery.Create(nil);
           aquery.Connection := aconn;
           try
             with aquery do
              begin
                close;
                sql.Clear;
                sql.Add('select addr,jump,enhance,holder from ttc_auto_voter where can_SignIN like :signin');
                parambyname('signin').AsString := 'NO';
                open;
                if not isempty then
                 begin
                  aRecCount := RecordCount;
                  SetLength(nthreads,aRecCount);
                  arecno := 0;
                  first;
                  while not eof  do
                   begin
                    aaddr := fieldbyname('addr').AsString;
                    aholder := fieldbyname('holder').AsString;
                    if around = 9 then
                    begin
                     ajump_time := 30000;
                     aenhance := fieldbyname('enhance').AsString;
                     voters_list.values[aaddr] :=  aenhance;
                    end
                    else
                    begin
                      ajump_time := fieldbyname('jump').asinteger * 1000;
                    end;
                     nthreads[arecno]:= TVoteForJnA.Create(aaddr,aholder,ajump_time );
                     next;
                     arecno := arecno + 1;
                   end;
                 end;

              end;
           finally
             aquery.Free;
           end;
        end
        else
        begin
          Synchronize(procedure
                        begin
                          fmMain.memo1.Lines.Add('Not Connected');
                        end
                       );
        end;
       finally
         aconn.Free;
       end;
     except on e : exception do
       begin
                    Synchronize(procedure
                        begin
                          fmMain.memo1.Lines.Add(e.message);
                        end
                       );


       end;
     end;
end;



end.