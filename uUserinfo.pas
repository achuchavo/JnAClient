﻿unit uUserinfo;

interface
  uses
     SysUtils, Variants, Classes,
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
    System.JSON;
  type
  TTimerThread_UserInfo = class(TThread)
  private
    FTickEvent: THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(someText : String);
    destructor Destroy; override;
    procedure FinishThreadExecution;
    procedure UpdateUserInfo;
    function get_ttc(aaddr : String) : String;
    var
      user_addr : String;
    const
       wei  = 1000000000000000000;
  end;
implementation
  uses
    ucodebasejna,uhome;

{ TTimerThread }


constructor TTimerThread_UserInfo.Create(someText : String);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FTickEvent := CreateEvent(nil, True, False, nil);
  user_addr := someText;
end;

destructor TTimerThread_UserInfo.Destroy;
begin
  CloseHandle(FTickEvent);
  inherited;
end;

procedure TTimerThread_UserInfo.Execute;
var
  aRound : String;
  i : Integer;
  aaddr,aenhance : String;
begin
  while not Terminated do
  begin
    if WaitForSingleObject(FTickEvent, 5000) = WAIT_TIMEOUT then
    begin
      updateUserinfo;
    end;
  end;

end;

procedure TTimerThread_UserInfo.FinishThreadExecution;
begin
  Terminate;
  SetEvent(FTickEvent);
end;




function TTimerThread_UserInfo.get_ttc(aaddr: String): String;
var
  LIdHTTP: TIdHTTP;
  resp: TMemoryStream;
  lReader: TStringReader;
  webdata : string;
  str_balance : string;
  ether_balance : double;
  wei_balance : extended;
  obj, data: TJSONObject;
begin
         result := '0.0';
         try
           LIdHTTP:= TIdHTTP.Create(nil);
           LIdHTTP.request.useragent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; MAAU)';
           resp := TMemoryStream.Create;
                    try
                      lReader := TStringReader.Create(LIdHTTP.Get('https://api.ttcnet.io/api/wallet/address/'
                                  +aaddr));
                          while lReader.Peek > 0 do
                          begin
                            webdata := lReader.ReadLine;
                          end;
                    finally
                      LIdHTTP.Free;
                      resp.Free;
                    end;
           obj := TJSONObject.ParseJSONValue(webdata) as TJSONObject;
          try
            data := obj.Values['data'] as TJSONObject;
            str_balance := data.Values['balance'].Value;
            wei_balance := strtofloat(trim(str_balance));
            ether_balance :=  wei_balance/wei;
            result :=  formatfloat('#,###.###',ether_balance);

          finally
            obj.Free;
          end;
          except on e : exception do
          begin
            result := e.Message;
          end;
          end;
end;

procedure TTimerThread_UserInfo.UpdateUserInfo;
var
  aconn : Tmyconnection;
  aquery : TMyquery;
  his_capital : String;
begin
     aconn := TMyconnection.Create(nil);
     try
        his_capital := get_ttc(user_addr);
        try
           aConn.Close;
           aconn.Options.UseUnicode := true;
           aconn.Server := '49.142.215.132';
           aconn.Port := 3306;
           aconn.Username := 'chavo';
           aconn.Password := 'fedora';
           aconn.Database := 'chavobase';
           aconn.LoginPrompt := False;
           aconn.Open;

       if aconn.Connected then
        begin
           aquery := tmyquery.Create(nil);
           aquery.Connection := aconn;
           try
             with aquery do
              begin
                close;
                sql.Clear;
                sql.Add('select count(a.addr) as eventCount,');
                sql.Add('min(a.date_start) as joinDate,');
                sql.Add('format(b.ttc_lotto,2) as ttc_lotto,  ');
                sql.Add('format(sum(a.airdrop),2) as airdropSum,');
                sql.Add('format(sum(a.airdrop)+b.ttc_lotto,2) as totalSum');
                sql.Add('from ttc_event a');
                sql.Add('left join ( select sum(ttc_lotto) as ttc_lotto,');
                sql.Add('addr from ttc_lotto');
                sql.Add('where addr like :addr1');
                sql.Add('group by addr) as b on a.addr = b.addr');
                sql.Add('where a.addr like :addr2');
                sql.Add('and a.event_status = ''완료'';');
                parambyname('addr1').AsString := user_addr;
                parambyname('addr2').AsString := user_addr;
                open;

               Synchronize(procedure
                          begin
                           fmHome.txt_airdrop.text := fieldbyname('airdropSum').asstring + ' TTC';
                           fmHome.txt_lotto.text := fieldbyname('ttc_lotto').asstring + ' TTC';
                           fmHome.txt_jnareward.text := fieldbyname('totalSum').asstring + ' TTC';
                           fmHome.txt_capital.text := his_capital + ' TTC';
                          end
                         );

              end;
           finally
             aquery.Free;
           end;
        end;

        finally
          aconn.Free;
        end;
     except on e : exception do
       begin

       end;

     end;
end;

end.
