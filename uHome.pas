﻿unit uHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  //
  ucodebasejna,
  System.Threading,
  System.StrUtils,
  //
  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,
  //
    System.IOUtils,
    System.JSON,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Edit, Data.DB, MemDS, DBAccess, MyAccess, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  Tfmhome = class(TForm)
    tab_holder: TTabControl;
    tab_info: TTabItem;
    tab_manage: TTabItem;
    Rectangle1: TRectangle;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    edt_name: TEdit;
    edt_pwd1: TEdit;
    edt_pwd2: TEdit;
    btn_check: TButton;
    mem_pk: TMemo;
    chk_seepwd: TCheckBox;
    Text5: TText;
    chk_ismyaddr: TCheckBox;
    txt_info: TText;
    btn_mypage: TButton;
    txt_addr: TText;
    Text6: TText;
    txt_capital: TText;
    Text7: TText;
    Text8: TText;
    txt_name: TText;
    txt_airdrop: TText;
    txt_lotto: TText;
    Text12: TText;
    txt_jnaReward: TText;
    txt_join: TText;
    Text15: TText;
    txt_eventState: TText;
    RoundRect1: TRoundRect;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Image1: TImage;
    Image2: TImage;
    StyleBook1: TStyleBook;
    btn_startautoVote: TButton;
    rec_client: TRectangle;
    btn_stopVote: TButton;
    txt_eventCount: TText;
    txt_serverStatus: TText;
    procedure btn_checkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chk_seepwdChange(Sender: TObject);
    procedure chk_ismyaddrChange(Sender: TObject);
    procedure btn_startautoVoteClick(Sender: TObject);
    procedure btn_mypageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_stopVoteClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

    procedure updateUserInfo;

    var
      check_status : String;
      en_pwd : String;
      my_addr : String;
    const
       wei  = 1000000000000000000;
  end;

var
  fmhome: Tfmhome;

implementation
 uses
  ujnaclient;

{$R *.fmx}

procedure Tfmhome.btn_checkClick(Sender: TObject);
var
  aaddr : String;
begin
     if edt_pwd1.Text <> edt_pwd2.Text then
      begin
        ShowMessage('비밀번호 일지 않습니다!');
        exit;
      end;

      if  check_status = 'import' then
      begin
        //import
          if mem_pk.text = '' then
          begin
            ShowMessage('개인 키 입력하세요!');
            exit;;
          end;
         btn_check.enabled := false;
         aaddr := codebase.import_key(mem_pk.text,edt_pwd1.text);
         if aaddr = 'error' then
          begin
            ShowMessage('개인 키 확인 하세요!');
            btn_check.enabled := true;
            //edit1.Text := codebase.json_error;
          end
          else
          begin
            chk_ismyaddr.Text := '내 주소 ' +aaddr +' 맞습니다!';
            chk_ismyaddr.Visible := true;
            en_pwd := fmjnaclient.Encrypt(edt_pwd1.text);
            my_addr := aaddr;
          end;
      end
      else if check_status = 'unlock' then
      begin
          if codebase.unlock_addr(my_addr,edt_pwd1.text) then
          begin
            chk_ismyaddr.Text := '내 주소 ' +my_addr +' 맞습니다!';
            chk_ismyaddr.Visible := true;
            en_pwd := fmjnaclient.Encrypt(edt_pwd1.text);
            fmjnaclient.save_addrtoDevice(fmjnaclient.edtname.text);
          end
          else
          begin
            mem_pk.text := codebase.json_error;
          end;

      end
      else
      if check_status = 'join' then
      begin

      end;



end;

procedure Tfmhome.btn_mypageClick(Sender: TObject);
begin
    updateUserInfo;
    tab_holder.ActiveTab := tab_info;
end;

procedure Tfmhome.btn_startautoVoteClick(Sender: TObject);
var
  r: TRectangle;
begin
  // Find the background TRectangle style element for the button
  if codebase.update_serverVote_status(my_addr,'YES') then
  begin
     { r := (btn_startautovote.FindStyleResource('recStart') as TRectangle);
      if Assigned(r) then
      begin
        //r.Fill.Color := TAlphaColors.Blue;
        r.Fill.Color := $FFEAEBEB;
      end;     }
      btn_startautovote.Enabled := false;
  end
  else
  begin
  end;


end;

procedure Tfmhome.btn_stopVoteClick(Sender: TObject);
var
  r: TRectangle;
begin
  // Find the background TRectangle style element for the button
  if codebase.update_serverVote_status(my_addr,'NO') then
  begin
     { r := (btn_stopVote.FindStyleResource('recStart') as TRectangle);
      if Assigned(r) then
      begin
        //r.Fill.Color := TAlphaColors.Blue;
        r.Fill.Color := $FFEAEBEB;
      end; }
      btn_stopVote.Enabled := false;

  end
  else
  begin
  end;
end;

procedure Tfmhome.chk_ismyaddrChange(Sender: TObject);
begin
    if chk_ismyaddr.IsChecked then
     begin
       codebase.update_pwd(my_addr,en_pwd);
       btn_mypage.Visible := true;
     end
     else
     begin
       btn_mypage.Visible := false;
     end;
end;

procedure Tfmhome.chk_seepwdChange(Sender: TObject);
begin
      if chk_seepwd.IsChecked then
       begin
         edt_pwd1.Password := false;
         edt_pwd2.Password := false;
       end
       else
       begin
         edt_pwd1.Password := true;
         edt_pwd2.Password := true;
       end;
end;

procedure Tfmhome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Application.Terminate;
end;

procedure Tfmhome.FormCreate(Sender: TObject);
begin
    chk_ismyaddr.Visible := false;
    txt_info.Visible := false;
    btn_mypage.Visible := false;
end;

procedure Tfmhome.updateUserInfo;
 var
  atask : Itask;
begin

  atask := Ttask.create(procedure()
      var
      hacer: boolean;
      aconn : Tmyconnection;
      aquery : TMyquery;
      LIdHTTP: TIdHTTP;
      resp: TMemoryStream;
      lReader: TStringReader;
      webdata : string;
      str_balance : string;
      ether_balance : double;
      wei_balance : extended;
      obj, data: TJSONObject;
      his_capital : String;
      aserverVote : String;
     begin
       hacer := false;
        REPEAT
          begin
             sleep(3500);
             // Update Capital
             try
               LIdHTTP:= TIdHTTP.Create(nil);
               LIdHTTP.request.useragent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; MAAU)';
               resp := TMemoryStream.Create;
                        try
                          lReader := TStringReader.Create(LIdHTTP.Get('https://api.ttcnet.io/api/wallet/address/'
                                      +my_addr));
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
                his_capital :=  formatfloat('#,###.###',ether_balance);

              finally
                obj.Free;
              end;
              except on e : exception do
              begin
                his_capital := e.Message;
              end;
              end;
              TThread.Synchronize(TThread.CurrentThread,procedure()
                          begin
                           fmHome.txt_capital.text := his_capital + ' TTC';
                          end);

            //
            txt_addr.text := AnsiLeftStr(codebase.my_addr, 10)+  '...'+AnsiRightStr(codebase.my_addr, 10);

            //
            txt_name.Text := codebase.my_name;

             //
             //upate JnA Info
             aconn := TMyconnection.Create(nil);
             try
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
                        sql.Add('format(sum(a.airdrop)+b.ttc_lotto,2) as totalSum,');
                        sql.Add('c.can_serverVote');
                        sql.Add('from ttc_event a');
                        sql.Add('left join ( select sum(ttc_lotto) as ttc_lotto,');
                        sql.Add('addr from ttc_lotto');
                        sql.Add('where addr like :addr1');
                        sql.Add('group by addr) as b on a.addr = b.addr');
                        sql.Add('left join ttc_auto_voter c on c.addr = a.addr');
                        //left join ttc_auto_voter c on c.addr = a.addr
                        sql.Add('where a.addr like :addr2');
                        sql.Add('and a.event_status = ''완료'';');
                        parambyname('addr1').AsString := my_addr;
                        parambyname('addr2').AsString := my_addr;
                        open;
                        aserverVote := fieldbyname('can_serverVote').asstring;
                        //이벤트 완료 건수 :
                       TThread.Synchronize(TThread.CurrentThread,procedure()
                          begin
                              //Remeber to wrap them inside a Syncronize
                              //이번트 개입일 : 2019-07-01
                           fmHome.txt_airdrop.text := fieldbyname('airdropSum').asstring + ' TTC';
                           fmHome.txt_lotto.text := fieldbyname('ttc_lotto').asstring + ' TTC';
                           fmHome.txt_jnareward.text := fieldbyname('totalSum').asstring + ' TTC';
                           fmHome.txt_join.text := '이벤트 가입일 : ' +
                                                 formatdatetime('yyyy.mm.dd',fieldbyname('joinDate').asdatetime);
                           fmHome.txt_eventcount.text := '이벤트 완료 건수 : ' +
                                                   fieldbyname('eventCount').asinteger.tostring;
                           if aserverVote = 'YES' then
                            begin
                              fmhome.btn_startautoVote.Enabled:= false;
                              fmhome.btn_stopVote.Enabled:= true;
                              txt_serverstatus.Text := '자동 투표 진행 하고 있습니다!';
                              txt_serverstatus.TextSettings.FontColor := $FF048059;
                            end
                            else
                            begin
                              fmhome.btn_startautoVote.Enabled:= true;
                              fmhome.btn_stopVote.Enabled:= false;
                              txt_serverstatus.Text := '자동 투표 중지 되었습니다!';
                              txt_serverstatus.TextSettings.FontColor := $FFA92D4B;
                              //자동 투표 중지 되었습니다!
                            end;

                          end);

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
        UNTIL hacer = true;;
     end);

 atask.Start;

end;

end.
