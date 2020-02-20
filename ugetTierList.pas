unit ugetTierList;

interface
  uses
    //Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  GridsEh,Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
    //
    dateutils,
    strutils,
    shellapi,
    //
    //TMyCOnnection Units
    Data.DB, DBAccess, MyAccess,
    //TMyQuery Units
    MemDS,
    //
    System.JSON,
    System.JSON.Types,
    System.JSON.Writers,
    System.JSON.Builders,
    System.JSON.Readers,
    IdBaseComponent, IdComponent, IdTCPConnection,
    IdTCPClient, IdHTTP,IdGlobal,
    LbCipher,
    LbClass,
    Dialogs;
type
  TTierList = class(TThread)
  private
    FTickEvent: THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(around: String);
    destructor Destroy; override;
    procedure FinishThreadExecution;
     //
     function get_miner_with_low_votes : boolean;

     //
    // function MySortProc(List: TStringList; Index1, Index2: integer): integer;
    var

      theround : String;

      err_msg : String;



      localNeedEncrypt: Boolean;

       const
         wei = 1000000000000000000;
         one_wei = 1000000000;
  end;

implementation
    uses
      uMain;
{ TTierList }
function MySortProc(List: TStringList; Index1, Index2: integer): integer;
var
  Value1, Value2: Double;
begin
 // Value1 := StrToInt(List[Index1]);
 // Value2 := StrToInt(List[Index2]);
  Value1 := StrToFloat(List.Values[List.Names[Index1]]);
  Value2 := StrToFloat(List.Values[List.Names[Index2]]);
  //List.Values[List.Names[Index1]]
  if Value1 > Value2 then
    Result := -1
  else if Value2 > Value1 then
    Result := 1
  else
    Result := 0;
end;

constructor TTierList.Create(around: String);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  theround := around;
  FTickEvent := CreateEvent(nil, True, False, nil);
end;

destructor TTierList.Destroy;
begin
  CloseHandle(FTickEvent);
  inherited;
end;

procedure TTierList.Execute;
var
  atrimMiner : String;
begin
  while not Terminated do
  begin
    if WaitForSingleObject(FTickEvent, 2000) = WAIT_TIMEOUT then
    begin
      get_miner_with_low_votes;
      FinishThreadExecution;
    end;
  end;
end;

procedure TTierList.FinishThreadExecution;
begin
    Terminate;
    SetEvent(FTickEvent);
end;

function TTierList.get_miner_with_low_votes: boolean;
var
  json: string;
  lHTTP: TIdHTTP;
  lParamList: TStringList;
  DataToSend : TStringStream;
  obj, data: TJSONObject;
  asigners : TJsonArray;
  i : integer;
  asigner,output : string;
  ttc_signers : Tstringlist;
  ttc_tally : Tstringlist;
  imine,lowmine : string;

  //
  tally: TJSONObject;
  aaddr,avotes : string;
  dbl_votes : extended;
  Index,arow: Integer;
  //

  miner_votes : double;
  vote_diff : double;
  imine_vote : double;
  lowest_mine : double;
  //
  aminer,aminer_concat,addr_concat : String;
begin
   result := false;
   try
    ttc_signers := Tstringlist.Create;
    ttc_tally := Tstringlist.Create;
    //GET SIGNERS
    ttc_signers.Clear;
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
        lHTTP := TIdHTTP.Create(nil);
        lHTTP.request.useragent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; MAAU)';
        try
          lHTTP.Request.ContentType := 'application/json';
          output := lHTTP.Post('http://rpc-tokyo.ttcnet.io', DataToSend);
        finally
          lHTTP.Free;
        end;
      finally
        lParamList.Free;
        DataToSend.Free;
      end;
      obj := TJSONObject.ParseJSONValue(output) as TJSONObject;
      try
         data := obj.Values['result'] as TJSONObject;
         try
           asigners := data.Values['signers'] as TJsonArray;
           try
             for i := 0 to asigners.Size-1 do
              begin
                  asigner :=  trim(StringReplace(asigners.Get(i).ToString,'"','',[rfReplaceAll]));
                  ttc_signers.Add(asigner);
              end;
           finally
           end;
         finally
         end;
      finally
        obj.free;
      end;

      //GET tally
        ttc_tally.Clear;
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
          lHTTP := TIdHTTP.Create(nil);
          lHTTP.request.useragent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; MAAU)';
          try
            lHTTP.Request.ContentType := 'application/json';
            output := lHTTP.Post('http://rpc-tokyo.ttcnet.io', DataToSend);
          finally
            lHTTP.Free;
          end;
        finally
          lParamList.Free;
          DataToSend.Free;
        end;


        obj := TJSONObject.ParseJSONValue(output) as TJSONObject;
        try
           data := obj.Values['result'] as TJSONObject;
           try
             tally := data.Values['tally'] as TJSONObject;
             try
               arow := 1;
               for I := 0 to tally.size-1 do
               begin
                 aaddr := tally.Get(i).JsonString.ToString;
                 aaddr := trim(StringReplace(aaddr,'"','',[rfReplaceAll]));
                 ttc_signers.Sort;
                 if ttc_signers.Find(aaddr, Index) then
                  begin
                     avotes := tally.Get(i).JsonValue.ToString;
                     dbl_votes := (strtofloat(avotes)/wei);
                     ttc_tally.values[aaddr] :=  dbl_votes.ToString;
                     arow := arow +1;
                  end;
               end;
             finally
             end;
           finally
           end;
        finally
           obj.Free;
        end;

      // Process Tally Data
      ttc_tally.CustomSort(MySortProc);


       //update tier miner UI
        Synchronize(procedure
          begin
            fmMain.mem_tier.Lines.clear;
            fmmain.lbl_tierList.Caption := 'Tier List R'+theround;
          end
        );

       for I := 0 to ttc_tally.Count-1 do
        begin
          imine_vote := strtofloat(ttc_tally.Values[ttc_tally.Names[I]]);
          imine :=   formatfloat('#,###,###.###',imine_vote);
          aminer :=  ttc_tally.Names[I];
          aminer_concat := AnsiLeftStr(aminer, 6)+  '...'+AnsiRightStr(aminer, 6);
          Synchronize(procedure
            begin
              fmMain.mem_tier.Lines.Add(''+inttostr(i+1)+''#9''+aminer_concat+''#9''+imine);

              fmMain.mem_tier.Perform( EM_SETTABSTOPS, 4, LongInt(@fmMain.tier_tabs));
              fmMain.mem_tier.Refresh;
            end
          );
        end;


   except on e : exception do
    begin
      result := false;
      err_msg := e.Message;
    end;

   end;
end;

end.
