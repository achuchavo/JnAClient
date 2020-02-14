﻿unit ucodebasejna;


interface

  uses
     FMX.Controls,System.Classes,
     //Database Components for TMyConnection and TMyQuery
     Data.DB, DBAccess, MyAccess, MemDS,
     //for execeptions
     Sysutils,
     //for Indy
      IdComponent, IdTCPConnection,
     IdTCPClient, IdHTTP,
     //
     strutils,
     //for JSON

    System.JSON,
    System.JSON.Types,
    System.JSON.Writers,
    System.JSON.Builders,
    System.JSON.Readers
     ;
  type
    TCodeBase = Record
      public


        function is_connected_toAchuDB(aconn : TMyConnection) : Boolean;
        function logged_IN(aaddr : String;aquery:TMyQuery) : Boolean;
        function sToint(theString: String): integer;
        function sTofloat(theString: String): double;

        //RPC

        function import_key(akey,apwd : String) : String;
        function unlock_addr(aaddr,apwd : String) : Boolean;
        function lock_addr(aaddr : String) : Boolean;
        function send_vote(fromaddr,toaddr,apwd : String): Boolean;

        //
        procedure set_rpc_info;

        //database calls
        procedure update_pwd(aaddr,apwd : String);
        function  update_serverVote_status(aaddr,astatus : String) : Boolean;



      var
        my_addr : String;
        my_name : String;
        my_pwd  : String;
        can_signIn : String;
        can_serverVote : String;
        erro_msg : String;
        json_error : String;

       rpcip : string;
       rpcport : string;

    End;

  var
    codebase : TCodeBase;

implementation

{ TCodeBase }





function TCodeBase.import_key(akey, apwd: String): String;
var
  json: string;
  lHTTP: TIdHTTP;
  lParamList: TStringList;
  output:string;
  DataToSend : TStringStream;
  obj, data: TJSONObject;
  aaddr : String;
begin
    set_rpc_info;
    json :=    sLineBreak  +
               ' {' + sLineBreak  +
               ' "jsonrpc":"2.0",' + sLineBreak  +
               ' "method":"personal_importRawKey",' + sLineBreak  +
               ' "params":[' + sLineBreak  +
               ' "'+akey+'",' + sLineBreak  +
               ' "'+apwd+'"],"id":67},';
     DataToSend := TStringStream.Create(json, TEncoding.UTF8);
    try
      lHTTP := TIdHTTP.Create(nil);
      lHTTP.request.useragent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; MAAU)';
      try
        lHTTP.Request.ContentType := 'application/json';
        output := lHTTP.Post('http://'+rpcip+':'+rpcport+'/', DataToSend);


         if containstext(output,'error') then
          begin
            result := 'error';
            json_error := output;
          end
          else
          begin
            obj := TJSONObject.ParseJSONValue(output) as TJSONObject;
            try
               aaddr := obj.Values['result'].Value;
               result := aaddr;
            finally
              obj.free;
            end;
          end;
      finally
        lHTTP.Free;
      end;
   except on e : exception do
      begin
        result := 'error';
        erro_msg := e.message;
      end;

    end;
end;

function TCodeBase.is_connected_toAchuDB(aconn: TMyConnection): Boolean;
begin
        result := false;
        try
               aconn.Options.UseUnicode := true;
               aconn.Server := '49.142.215.132';
               aconn.Port := 3306;
               aconn.Username := 'chavo';
               aconn.Password := 'fedora';
               aconn.Database := 'chavobase';
               aconn.LoginPrompt := False;
               aconn.Open;
               result := true;
        except
        on E : Exception do
        begin
          //showmessage(E.ClassName + ' Error Message: ' + E.Message);
          result := false;
        end;

        end;

end;

function TCodeBase.lock_addr(aaddr: String): Boolean;
begin

end;

function TCodeBase.logged_IN(aaddr: String; aquery: TMyQuery): Boolean;
begin
        result := false;

        try
           with aquery do
             begin
               close;
               sql.Clear;
               sql.Add('SELECT addr,holder,pwd,can_signIN,can_serverVote ');
               sql.Add('from ');
               sql.Add('ttc_auto_voter ');
               sql.Add('where ');
              // sql.Add('can_signIN = :can_signIN ');
              // sql.Add('and ');
               sql.Add('addr = :addr ');
              // ParamByName('can_signIN').AsString := 'YES';
               ParamByName('addr').AsString := aaddr;
               open;
               if  not IsEmpty then
                begin
                 my_addr := FieldByName('addr').AsString;
                 my_name := FieldByName('holder').AsString;
                 my_pwd := FieldByName('pwd').AsString;
                 can_signIN := FieldByName('can_signIN').AsString;
                 can_serverVote := FieldByName('can_serverVote').AsString;
                 result := true;
                end
                else
                begin

                result := false;
                end;

               // if bon_state = 'ACTIVE' then
             end;
        except on E : Exception do
          begin
            result := false;
          end;

        end;
end;

function TCodeBase.send_vote(fromaddr, toaddr, apwd: String): Boolean;
begin

end;

procedure TCodeBase.set_rpc_info;
var
  aQuery : Tmyquery;
  str_canvote : string;
  aconn : TMyConnection;
begin

  try
     rpcip := '52.79.243.253';
     rpcport := '5000';
     aconn := tmyconnection.Create(nil);
    try
     if is_connected_toAchuDB(aconn) then
      begin
         aquery := TMyquery.Create(nil);
         aquery.Connection := aconn;
         try
            with aquery do
              begin
                close;
                sql.Clear;
                sql.Add('select jnaip,jnaport from jnarpc ');
                sql.Add('where usecase like :usecase order by id desc limit 1 ');
                parambyname('usecase').asstring := 'Server';
                open;
                if not isempty then
                 begin
                   rpcip := fieldbyname('jnaip').AsString;
                   rpcport := fieldbyname('jnaport').AsInteger.ToString;
                 end;
              end;
         finally
           aquery.Free;
         end;

      end;

    finally
      aconn.free;
    end;
  except on e : exception do
    begin
     rpcip := '52.79.243.253';
     rpcport := '5000';
    end;

  end;
end;

function TCodeBase.sTofloat(theString: String): double;
var
 convertedInt : double;
begin
     if thestring = '' then
       begin
         thestring := '0';
       end;
     try
     convertedInt := strtofloat(StringReplace(theString,',','',[rfReplaceAll, rfIgnoreCase]));
     result :=  convertedInt;
     except
     on E : Exception
       do
       begin
         result := 0;

       end;

     end;
end;

function TCodeBase.sToint(theString: String): integer;
var
 convertedInt : integer;
begin
     if thestring = '' then
       begin
         thestring := '0';
       end;
     try
     convertedInt := strtoInt(StringReplace(theString,',','',[rfReplaceAll, rfIgnoreCase]));
     result :=  convertedInt;
     except
     on E : Exception
       do
       begin
         result := 0;

       end;

     end;

end;

function TCodeBase.unlock_addr(aaddr,apwd : String): Boolean;
var
  json: string;
  lHTTP: TIdHTTP;
  lParamList: TStringList;
  output:string;
  DataToSend : TStringStream;
  loopaddr : String;
begin
  result := false;
  set_rpc_info;
  loopaddr := aaddr;
  json :=    sLineBreak  +
             ' {' + sLineBreak  +
             ' "jsonrpc":"2.0",' + sLineBreak  +
             ' "method":"personal_unlockAccount",' + sLineBreak  +
             ' "params":[' + sLineBreak  +
             ' "'+aaddr+'",' + sLineBreak  +
             ' "'+apwd+'"],"id":67},';
   DataToSend := TStringStream.Create(json, TEncoding.UTF8);
  try
    lHTTP := TIdHTTP.Create(nil);
    lHTTP.request.useragent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; MAAU)';
    try
      lHTTP.Request.ContentType := 'application/json';
      output := lHTTP.Post('http://'+rpcip+':'+rpcport+'/', DataToSend);

    finally
      freeandnil(lHTTP);
    end;
  finally
    freeandnil(DataToSend);
  end;

   json := output;
   if containstext(json,'error') then
    begin
      {if unlock_count = 4 then
       begin
         result := false;
         unlock_count := 0;
         exit;
       end;
      unlock_addr(loopaddr);
      unlock_count := unlock_count + 1; }
      json_error := output;
      result := false;
    end
    else
    begin
      result := true;
    end;

end;

procedure TCodeBase.update_pwd(aaddr, apwd: String);
var
  aQuery : Tmyquery;
  str_canvote : string;
  aconn : TMyConnection;
begin

  try
     aconn := tmyconnection.Create(nil);
    try
     if is_connected_toAchuDB(aconn) then
      begin
         aquery := TMyquery.Create(nil);
         aquery.Connection := aconn;
         try
            with aquery do
              begin
                close;
                sql.Clear;
                sql.Add('update ttc_auto_voter ');
                sql.Add('set pwd =:pwd, can_signIN =:can_signIN where addr =:addr');
                parambyname('addr').asstring := aaddr;
                parambyname('pwd').asstring := apwd;
                parambyname('can_signIN').asstring := 'YES';
                execsql;
              end;
         finally
           aquery.Free;
         end;

      end;

    finally
      aconn.free;
    end;
  except on e : exception do
    begin
    end;

  end;
end;

function TCodeBase.update_serverVote_status(aaddr, astatus: String): Boolean;
var
  aQuery : Tmyquery;
  str_canvote : string;
  aconn : TMyConnection;
begin
  result := false;
  try
     aconn := tmyconnection.Create(nil);
    try
     if is_connected_toAchuDB(aconn) then
      begin
         aquery := TMyquery.Create(nil);
         aquery.Connection := aconn;
         try
            with aquery do
              begin
                close;
                sql.Clear;
                sql.Add('update ttc_auto_voter ');
                sql.Add('set can_serverVote =:can_serverVote where addr =:addr');
                parambyname('addr').asstring := aaddr;
                parambyname('can_serverVote').asstring := astatus;
                execsql;
                can_serverVote := astatus;
                result := true;
              end;
         finally
           aquery.Free;
         end;

      end;

    finally
      aconn.free;
    end;
  except on e : exception do
    begin
      result := true;
    end;

  end;
end;

end.

