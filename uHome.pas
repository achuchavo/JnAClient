﻿unit uHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  //
  ucodebasejna,
  System.Threading,
  System.StrUtils,
  fmx.header,
  System.UIConsts,
  //
  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,
  //
    System.IOUtils,
    System.JSON,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Edit, Data.DB, MemDS, DBAccess, MyAccess, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, System.Rtti, FMX.Grid.Style, FMX.Grid,
  FMX.Layouts;

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
    dataG: TStringGrid;
    btn_getAirdrop: TButton;
    btn_getLotto: TButton;
    txt_hour: TText;
    Text9: TText;
    txt_day: TText;
    Text11: TText;
    Layout1: TLayout;
    aAnimate: TAniIndicator;
    procedure btn_checkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chk_seepwdChange(Sender: TObject);
    procedure chk_ismyaddrChange(Sender: TObject);
    procedure btn_startautoVoteClick(Sender: TObject);
    procedure btn_mypageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_stopVoteClick(Sender: TObject);
    procedure btn_getAirdropClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_getLottoClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

    procedure updateUserInfo;
    procedure updateCapital;
   // procedure getReward_Hist(atable,avalue,adate : String);
   procedure getAirdropHist;
   procedure getLottopHist;

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
            fmjnaclient.save_addrtoDevice(fmjnaclient.edtname.text);
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

procedure Tfmhome.btn_getAirdropClick(Sender: TObject);
begin
   getAirdropHist;
end;

procedure Tfmhome.btn_getLottoClick(Sender: TObject);
var
  aRec : TRectangle;
    r: TRectangle;
    aheader : Theader;
begin
   { aheader := (dataG.FindStyleResource('header') as Theader);
    if Assigned(aheader) then
    begin
      arec := TRectangle.Create(aheader);
      arec.Align := TAlignLayout.Client;
      arec.Fill.Color := claBlack;
      btn_getlotto.Text := 'header';
    end
    else
    begin
      btn_getlotto.Text := 'not assigned';
    end;  }
    getLottopHist;
end;

procedure Tfmhome.btn_mypageClick(Sender: TObject);
var

  aCapitalTask : Itask;
begin
    aCapitalTask := Ttask.create(procedure()
     begin
       aanimate.enabled := true;
       btn_mypage.Enabled := false;
       updateUserInfo;
       updateCapital;
       tab_holder.ActiveTab := tab_info;
     end);
    aCapitalTask.Start;




end;

procedure Tfmhome.btn_startautoVoteClick(Sender: TObject);
var
  r: TRectangle;
begin
  // Find the background TRectangle style element for the button
  if codebase.update_serverVote_status(my_addr,'YES') then
  begin
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
       fmjnaclient.save_addrtoDevice(fmjnaclient.edtname.text);
       aAnimate.Visible := true;
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

procedure Tfmhome.FormShow(Sender: TObject);
begin
    getAirdropHist;
end;

procedure Tfmhome.getAirdropHist;
var
  acol,acol2 : TStringColumn;
  i,arow : Integer;
  acolCount : Integer;
  Header: THeader;
  HeaderItem: THeaderItem;
  aconn : Tmyconnection;
  aquery : TMyquery;
  adate,aairdrop : String;
  awid : integer;
begin
 btn_getAirdrop.Enabled := false;
 btn_getlotto.Enabled := true;
 try
     acolCount := dataG.ColumnCount;
     awid := round((dataG.Width-3)/2);
         for i:= dataG.ColumnCount-1 downto 0 do
       begin
         dataG.Columns[i].DisposeOf;
       end;
      //
      acol := TStringColumn.Create(self); //acol
      acol.Header := '날짜';
      acol.Width := awid;
      dataG.AddObject(acol);
      //
      acol2 := TStringColumn.Create(self); //acol
      acol2.Header := 'Airdrop';
      acol2.Width := awid;
      dataG.AddObject(acol2);
      //

     Header := THeader((dataG).FindStyleResource('header'));
     if Assigned(Header) then
      begin
        for I := 0 to Header.Count - 1 do
          begin
            HeaderItem := Header.Items[i];
            HeaderItem.Font.Size := 15;
            HeaderItem.FontColor := $FFFEFDFD;
            HeaderItem.Font.Style := [TFontStyle.fsBold];
            HeaderItem.TextSettings.HorzAlign := TTextAlign.Center;
            // new code line:
            HeaderItem.StyledSettings := HeaderItem.StyledSettings -
                                         [TStyledSetting.Size,
                                          TStyledSetting.Style,
                                          TStyledSetting.FontColor];
          end;
       // Header.Height := 48;
      end;

           //  aconn := TMyconnection.Create(nil);
             try
                try

                  { aConn.Close;
                   aconn.Options.UseUnicode := true;
                   aconn.Server := '49.142.215.132';
                   aconn.Port := 3306;
                   aconn.Username := 'chavo';
                   aconn.Password := 'fedora';
                   aconn.Database := 'chavobase';
                   aconn.LoginPrompt := False;
                   aconn.ConnectionTimeout :=4;
                   aconn.Open; }

                 if fmjnaclient.isConnected then
                  begin
                   aquery := tmyquery.Create(nil);
                   aquery.Connection := fmjnaclient.theconn;
                   try
                     with aquery do
                      begin
                        close;
                        sql.Clear;
                        sql.Add('select date_end as thedate,');
                        sql.Add('format(airdrop,2) as amt');
                        sql.Add('from ttc_event');
                        sql.Add('where addr like :addr');
                        sql.Add('and event_status = ''완료''');
                        sql.Add('order by date_end desc');
                        parambyname('addr').AsString := my_addr;
                        open;
                        dataG.RowCount := RecordCount;
                        if not isempty then
                        begin
                          first;
                          arow := 0;
                          while not eof do
                           begin
                             adate := formatdatetime('yy.mm.dd',fieldbyname('thedate').AsDateTime);
                             aairdrop := fieldbyname('amt').AsString;
                             dataG.Cells[0,arow] := adate;
                             dataG.Cells[1,arow] := aairdrop + ' TTC';
                             next;
                             arow := arow + 1;
                           end;
                        end;

                         for i  := 0 to dataG.ColumnCount-1 do
                          begin
                            dataG.Columns[i].Width := awid;
                          end;
                      end;
                   finally
                     aquery.Free;
                   end;
                 end
                 else
                 begin
                 end;
                finally
                 // aconn.Free;
                end;
             except on e : exception do
               begin
               // btn_getAirdrop.Enabled := true;
                 txt_serverstatus.Text := 'db ' + e.Message;
               end;

             end;

 except on e : exception
  do
  begin
    //btn_getAirdrop.Enabled := true;
    txt_serverstatus.Text := e.Message;
  end;

 end;
end;

procedure Tfmhome.getLottopHist;
var
  acol,acol2,acol3 : TStringColumn;
  i,arow : Integer;
  acolCount : Integer;
  Header: THeader;
  HeaderItem: THeaderItem;
  aconn : Tmyconnection;
  aquery : TMyquery;
  adate,areward,arank : String;
  awid : integer;
begin
 btn_getlotto.Enabled := false;
 btn_getAirdrop.Enabled := true;
 try
     acolCount := dataG.ColumnCount;
     awid := round((dataG.Width-10)/3);
     if acolCount > 0 then
      begin
         for i:= dataG.ColumnCount-1 downto 0 do
       begin
         dataG.Columns[i].DisposeOf;
       end;
      end;
      //
      acol := TStringColumn.Create(self); //acol
      acol.Header := '날짜';
      acol.Width := awid;
      dataG.AddObject(acol);
      //
      acol2 := TStringColumn.Create(self); //acol
      acol2.Header := '보상';
      acol2.Width := awid;
      dataG.AddObject(acol2);
      //
      acol3 := TStringColumn.Create(self); //acol
      acol3.Header := 'RANK';
      acol3.Width := awid;
      dataG.AddObject(acol3);

     Header := THeader((dataG).FindStyleResource('header'));
     if Assigned(Header) then
      begin
        for I := 0 to Header.Count - 1 do
          begin
            HeaderItem := Header.Items[i];
            HeaderItem.Font.Size := 14;
            HeaderItem.FontColor := $FFFEFDFD;
            HeaderItem.Font.Style := [TFontStyle.fsBold];
            HeaderItem.TextSettings.HorzAlign := TTextAlign.Center;
            // new code line:
            HeaderItem.StyledSettings := HeaderItem.StyledSettings -
                                         [TStyledSetting.Size,
                                          TStyledSetting.Style,
                                          TStyledSetting.FontColor];
          end;
       // Header.Height := 48;
      end;



           //  aconn := TMyconnection.Create(nil);
             try
                try

                 if fmjnaclient.isConnected then
                  begin
                   aquery := tmyquery.Create(nil);
                   aquery.Connection := fmjnaclient.theconn;
                   try
                     with aquery do
                      begin
                        close;
                        sql.Clear;
                        sql.Add('select date_start as thedate,');
                        sql.Add('format(ttc_lotto,2) as amt,');
                        sql.Add('CONCAT(win_rank ,'' 등'') as arank');
                        sql.Add('from ttc_lotto ');
                        sql.Add('where addr like :addr');
                        sql.Add('order by date_start desc');
                        parambyname('addr').AsString := my_addr;
                        open;
                        dataG.RowCount := RecordCount;
                        if not isempty then
                        begin
                          first;
                          arow := 0;
                          while not eof do
                           begin
                             adate := formatdatetime('yy.mm.dd',fieldbyname('thedate').AsDateTime);
                             areward := fieldbyname('amt').AsString;
                             arank := fieldbyname('arank').AsString;
                             dataG.Cells[0,arow] := adate;
                             dataG.Cells[1,arow] := areward + ' TTC';
                             dataG.Cells[2,arow] := arank;
                             next;
                             arow := arow + 1;
                           end;
                        end;
                         for i  := 0 to dataG.ColumnCount-1 do
                          begin
                            dataG.Columns[i].Width := awid;
                          end;
                      end;
                   finally
                     aquery.Free;
                   end;
                 end
                 else
                 begin
                 end;
                finally
                 // aconn.Free;
                end;
             except on e : exception do
               begin
               // btn_getAirdrop.Enabled := true;
                 txt_serverstatus.Text := 'db ' + e.Message;
               end;

             end;

 except on e : exception
  do
  begin
    //btn_getAirdrop.Enabled := true;
    txt_serverstatus.Text := e.Message;
  end;

 end;

end;

procedure Tfmhome.updateCapital;
 var
  aCapitalTask : Itask;
begin

  aCapitalTask := Ttask.create(procedure()
      var
      hacer: boolean;
      LIdHTTP: TIdHTTP;
      resp: TMemoryStream;
      lReader: TStringReader;
      webdata : string;
      str_balance : string;
      ether_balance : double;
      wei_balance : extended;
      obj, data: TJSONObject;
      his_capital : String;
     begin
       hacer := false;
        REPEAT
          begin
             sleep(6000);
             // Update Capital
             try

              LIdHTTP:= TIdHTTP.Create(nil);
              LidHttp.ConnectTimeout := 5000;
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
          end;
        UNTIL hacer = true;;
     end);

 aCapitalTask.Start;
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
      aserverVote : String;
      aeventStatus : string;
      aday,ahour,averify : String;
      aday_per,ahour_per : string;
     begin
       hacer := false;
        REPEAT
          begin
             sleep(4000);

            //
            TThread.Synchronize(TThread.CurrentThread,procedure()
              begin
                txt_addr.text := AnsiLeftStr(codebase.my_addr, 10)+
                           '...'+AnsiRightStr(codebase.my_addr, 10);
                txt_name.Text := codebase.my_name;
              end);
            //upate JnA Info
            // aconn := TMyconnection.Create(nil);
             try
                try

                 {  aConn.Close;
                   aconn.Options.UseUnicode := true;
                   aconn.Server := '49.142.215.132';
                   aconn.Port := 3306;
                   aconn.Username := 'chavo';
                   aconn.Password := 'fedora';
                   aconn.Database := 'chavobase';
                   aconn.LoginPrompt := False;
                   aconn.ConnectionTimeout :=4;
                   aconn.Open; }

                 if fmjnaclient.isConnected then
                  begin

                   aquery := tmyquery.Create(nil);
                   aquery.Connection := fmjnaclient.theconn;
                   try
                     with aquery do
                      begin
                        close;
                        sql.Clear;
                        sql.Add('select count(a.addr) as eventCount,');
                        sql.Add('min(a.date_start) as joinDate,');
                        sql.Add('c.event_status,');
                        sql.Add('format(b.ttc_lotto,2) as ttc_lotto,  ');
                        sql.Add('format(sum(a.airdrop),2) as airdropSum,');
                        sql.Add('format(sum(a.airdrop)+b.ttc_lotto,2) as totalSum,');
                        sql.Add('d.can_serverVote');
                        sql.Add('from ttc_event a');
                        //join for lotto sum
                        sql.Add('left join ( select sum(ttc_lotto) as ttc_lotto,');
                        sql.Add('addr from ttc_lotto');
                        sql.Add('where addr like :addr1');
                        sql.Add('group by addr) as b on a.addr = b.addr');
                        //join for event status
                        sql.Add('left join (select event_status,addr from ttc_event');
                        sql.Add('where addr like :addr3');
                        sql.Add('order by id desc limit 1) as c on a.addr = c.addr');
                        //join for can server vote
                        sql.Add('left join ttc_auto_voter d on d.addr = a.addr');
                        sql.Add('where a.addr like :addr2');
                        sql.Add('and a.event_status = ''완료'';');
                        parambyname('addr1').AsString := my_addr;
                        parambyname('addr2').AsString := my_addr;
                        parambyname('addr3').AsString := my_addr;
                        open;
                        aserverVote := fieldbyname('can_serverVote').asstring;
                        aeventStatus  := fieldbyname('event_status').asstring;
                        //이벤트 완료 건수 :

                      if not isEmpty then
                       begin
                       TThread.Synchronize(TThread.CurrentThread,procedure()
                          begin
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

                            if aeventStatus = '진행' then
                             begin
                                txt_eventState.Text := '진행';
                             end
                             else
                             begin
                                txt_eventState.Text := '미참석';
                             end;
                          end);
                       end;

                        close;
                        sql.Clear;
                        sql.add('select format(a.my_ttc,3) as now_ttc,');
                        sql.add('format(b.my_ttc,3) as then_ttc,');
                        sql.add('format(c.my_ttc,3) as day_ttc,');
                        sql.add('concat(format(a.my_ttc - b.my_ttc,3),'' TTC'') as hourgain,');
                        sql.add('concat(format(a.my_ttc - c.my_ttc,3),'' TTC'') as daygain,');
                        sql.add('case');
                        sql.add('when ((a.my_ttc - b.my_ttc)/a.my_ttc)*100 > 0');
                        sql.add('then concat(''+'',format(((a.my_ttc - b.my_ttc)/a.my_ttc)*100,4),''%'')');
                        sql.add('when ((a.my_ttc - b.my_ttc)/a.my_ttc)*100 < 0');
                        sql.add('then concat(''-'',format(((a.my_ttc - b.my_ttc)/a.my_ttc)*100,4),''%'')');
                        sql.add('else concat(format(((a.my_ttc - b.my_ttc)/a.my_ttc)*100,4),''%'')');
                        sql.add('end as hour_rate,');
                        sql.add('case');
                        sql.add('when ((a.my_ttc - c.my_ttc)/a.my_ttc)*100 > 0');
                        sql.add('then concat(''+'',format(((a.my_ttc - c.my_ttc)/a.my_ttc)*100,4),''%'')');
                        sql.add('when ((a.my_ttc - c.my_ttc)/a.my_ttc)*100 < 0');
                        sql.add('then concat(''-'',format(((a.my_ttc - c.my_ttc)/a.my_ttc)*100,4),''%'')');
                        sql.add('else concat(format(((a.my_ttc - c.my_ttc)/a.my_ttc)*100,4),''%'')');
                        sql.add('end as day_rate');
                        sql.add('from ttc_auto_vote a');
                        sql.add('left join (select addr_from,my_ttc from ttc_auto_vote');
                        sql.add('where addr_from like :addr1');
                        sql.add('and vote_timestamp >= date_sub(NOW(),interval 1 hour)');
                        sql.add('and my_ttc is not null');
                        sql.add('order by id asc limit 1) as b on a.addr_from = b.addr_from');
                        sql.add('left join (select addr_from,my_ttc from ttc_auto_vote');
                        sql.add('where addr_from like :addr2');
                        sql.add('and vote_timestamp >= date_sub(NOW(),interval 24 hour)');
                        sql.add('and my_ttc is not null');
                        sql.add('order by id asc limit 1) as c on a.addr_from = c.addr_from');
                        sql.add('where a.addr_from like :addr3');
                        sql.add('and a.my_ttc is not null');
                        sql.add('order by id desc limit 1;');
                        parambyname('addr1').AsString := my_addr;
                        parambyname('addr2').AsString := my_addr;
                        parambyname('addr3').AsString := my_addr;
                        open;
                        if not isempty then
                        begin
                          aday := FieldByName('daygain').AsString;
                          aday_per := FieldByName('day_rate').AsString;
                          ahour := FieldByName('hourgain').AsString;
                          ahour_per := FieldByName('hour_rate').AsString;
                          //verify and update hour
                          averify  := AnsiLeftStr(ahour_per, 1);
                          TThread.Synchronize(TThread.CurrentThread,procedure()
                          begin
                            if averify = '+' then
                            begin
                               txt_hour.TextSettings.FontColor := claRed;
                               txt_hour.Text := ahour_per + '( ' +ahour +' )';
                            end
                            else
                            if averify = '-' then
                            begin
                              txt_hour.TextSettings.FontColor := claBlue;
                               txt_hour.Text := ahour_per + '( ' +ahour +' )';
                            end
                            else
                            begin
                              txt_hour.TextSettings.FontColor := claBlack;
                              txt_hour.Text := ahour_per + '( ' +ahour +' )';
                            end;

                          end);
                          //verify and update day
                          //added to git

                          averify  := AnsiLeftStr(aday_per, 1);
                          TThread.Synchronize(TThread.CurrentThread,procedure()
                          begin
                            if averify = '+' then
                            begin
                               txt_day.TextSettings.FontColor := claRed;
                               txt_day.Text := aday_per + '( ' +aday +' )';
                            end
                            else
                            if averify = '-' then
                            begin
                              txt_day.TextSettings.FontColor := claBlue;
                               txt_day.Text := aday_per + '( ' +aday +' )';
                            end
                            else
                            begin
                              txt_day.TextSettings.FontColor := claBlack;
                              txt_day.Text := aday_per + '( ' +aday +' )';
                            end;

                          end);

                        end;
                      end;
                   finally
                     aquery.Free;
                   end;
                 end
                 else
                 begin
                   //txt_name.Text := 'not connected';
                 end;

                finally
                  //aconn.Free;
                end;
             except on e : exception do
               begin
                 // fmHome.txt_capital.text := e.Message;
               end;

             end;
          end;
        UNTIL hacer = true;;
     end);

 atask.Start;

end;

end.
