﻿unit ujnaclient;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  Strutils,
  ucodebasejna,
  System.IOutils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, LbCipher,
  LbClass, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Edit, FMX.Objects, Data.DB, MemDS, DBAccess, MyAccess, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,IdSSLOpenSSLHeaders;

type
  Tfmjnaclient = class(TForm)
    LbRijndael1: TLbRijndael;
    edtName: TEdit;
    btn_enter: TButton;
    Text1: TText;
    StyleBook1: TStyleBook;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btn_enterClick(Sender: TObject);
    procedure edtNameClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     function NeedEncrypt(): Boolean;
     function Encrypt(aStr: String): String;
     function Decrypt(aStr: String): String;
     procedure save_addrtoDevice(aaddr : String);

     function loaad_addrfromDevice : String;
    var
      localNeedEncrypt: Boolean;
  end;

var
  fmjnaclient: Tfmjnaclient;

implementation
 uses
   uHome;

{$R *.fmx}



{ TForm1 }

procedure Tfmjnaclient.btn_enterClick(Sender: TObject);
var
  myconn : TMyconnection;
  aquery : TMyquery;
begin
   if edtname.text = '' then
    begin
      Showmessage('주소 입력하세요!');
      exit;
    end;
    btn_enter.enabled := false;
    myconn := tmyconnection.Create(self);
    try
      if  codebase.is_connected_toAchuDB(myconn) then
       begin
         aquery := tmyquery.Create(self);
         aquery.Connection := myconn;
        if codebase.logged_IN(edtname.text,aquery) then
         begin
          // ShowMessage(arec.my_pwd);
           if codebase.my_pwd <> '' then
            begin
              fmHome := Tfmhome.Create(self);
              InputBox('비밀번호',#31 + '비밀번호','',
                procedure(const AResult: TModalResult; const AValue: string)
                begin
                 case AResult of
                { Detect which button was pushed and show a different message }
                   mrOk:
                    begin
                    // AValue is the result of the inputbox dialog
                     if Avalue = Decrypt(codebase.my_pwd) then
                     begin
                       save_addrtoDevice(edtname.text);
                       fmHome.check_status := 'user';
                       fmHome.tab_holder.ActiveTab := fmHome.tab_info;
                       fmhome.txt_name.text := codebase.my_name;
                       fmhome.my_addr := codebase.my_addr;
                       fmhome.updateUserInfo;

                       fmHome.show;
                       hide;
                     end
                     else
                     begin

                     end;
                     //btn_enter.Text:= AValue;
                    end;
                    mrCancel:
                    begin
                    end;
                 end;
                end
                );
            end
            else if (codebase.my_pwd = '') and (codebase.can_signIN = 'YES') then
            begin
               fmHome := Tfmhome.Create(self);
               fmHome.check_status := 'unlock';
               fmHome.tab_holder.ActiveTab := fmHome.tab_manage;
               fmHome.mem_pk.enabled := false;
               fmHome.edt_name.text := codebase.my_name;
               fmHome.edt_name.enabled := false;
               fmhome.my_addr := codebase.my_addr;
               fmHome.txt_info.Text := '*비밀번호 입력시 확인 하세요!';
               fmhome.txt_info.Visible := true;
               fmHome.show;
            end
            else if (codebase.my_pwd = '') and (codebase.can_signIN = 'NO') then
            begin
               fmHome := Tfmhome.Create(self);
               fmHome.tab_holder.ActiveTab := fmHome.tab_manage;
               fmHome.mem_pk.enabled := true;
               fmHome.edt_name.text := codebase.my_name;
               fmHome.edt_name.enabled := false;
               fmHome.check_status := 'import';
               fmHome.txt_info.Text := '*개인 키 랑 비밀번호 입력시 확인 하세요!';
               fmhome.txt_info.Visible := true;
               fmHome.show;
            end;
         end
         else
         begin
               fmHome.txt_info.Text := '*정보 다 입력 하세요!';
               fmHome := Tfmhome.Create(self);
               fmHome.check_status := 'join';
               fmHome.show;

         end;

       end
       else
       begin
         ShowMessage('NOT Connected');
       end;
     finally
      myconn.free;
    end;
      btn_enter.enabled := true;
end;

function Tfmjnaclient.Decrypt(aStr: String): String;
begin
  Result := aStr;
  if RightStr(aStr, 2) = '==' then
    Result := LbRijndael1.DecryptString(aStr)
  else
    localNeedEncrypt := True;
end;

procedure Tfmjnaclient.edtNameClick(Sender: TObject);
var
InputString: string;
begin
   { InputString:= FMX.Dialogs.InputBox('Password', 'Password', 'Enter Password');
    btn_enter.Text:= InputString;

       InputBox('비밀번호',#31 + '비밀번호','',
        procedure(const AResult: TModalResult; const AValue: string)
        begin
         case AResult of
        //Detect which button was pushed and show a different message
           mrOk:
            begin
            // AValue is the result of the inputbox dialog
            btn_enter.Text:= AValue;
            end;
            mrCancel:
            begin
            end;
         end;
        end
        );    }
end;

function Tfmjnaclient.Encrypt(aStr: String): String;
begin
  Result := aStr;
  if RightStr(aStr, 2) = '==' then
    Exit;
  Result := LbRijndael1.EncryptString(aStr);
end;

procedure Tfmjnaclient.FormCreate(Sender: TObject);
begin
      LbRijndael1.GenerateKey('JISUNACHU');
      LbRijndael1.CipherMode := cmECB;
      LbRijndael1.KeySize := ks128;
      //uncomment the following line when compiling on ANdroid
     // IdOpenSSLSetLibPath(System.IOUtils.TPath.GetDocumentsPath);

end;

procedure Tfmjnaclient.FormShow(Sender: TObject);
begin
   edtname.text := loaad_addrfromDevice;
end;

function Tfmjnaclient.loaad_addrfromDevice: String;
var
  alist : TStringlist;
begin
   result := '';
   try
     alist := Tstringlist.Create;
     try
       alist.LoadFromFile(System.IOUtils.TPath.Combine(System.IOUtils.tpath.getdocumentspath,
       'myaddr.txt'));
       result := alist[0];
     finally
        alist.Free;
     end;
   except on e : exception do
     begin
       result := '';
     end;

   end;
end;

function Tfmjnaclient.NeedEncrypt: Boolean;
begin
      Result := localNeedEncrypt;
      localNeedEncrypt := False;
end;

procedure Tfmjnaclient.save_addrtoDevice(aaddr: String);
var
  alist : Tstringlist;
begin
    alist := tstringlist.Create;
    try
       alist.Add(aaddr);
       //path here is Documents
       alist.SaveToFile(System.IOUtils.TPath.Combine(System.IOUtils.tpath.getdocumentspath,
                        'myaddr.txt'));
    finally
      alist.Free;
    end;
end;

end.
