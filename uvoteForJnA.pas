unit uvoteForJnA;

interface
  uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    //
    dateutils,
    Dialogs;
  type
  TVoteForJnA = class(TThread)
  private
    FTickEvent: THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(voter_addr,holder : String;voter_jump_time : Integer);
    destructor Destroy; override;
    procedure FinishThreadExecution;
    procedure moveVote;
    var
      the_addr : String;
      the_jump_time : Integer;
      the_holder : String;
  end;

implementation
   uses
      uMain;

{ TVoteForJnA }

constructor TVoteForJnA.Create(voter_addr,holder: String; voter_jump_time: Integer);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FTickEvent := CreateEvent(nil, True, False, nil);
  the_addr := voter_addr;
  the_jump_time := voter_jump_time;
  the_holder := holder;

end;

destructor TVoteForJnA.Destroy;
begin
  CloseHandle(FTickEvent);
  inherited;
end;

procedure TVoteForJnA.Execute;
begin
  while not Terminated do
  begin
    if WaitForSingleObject(FTickEvent, the_jump_time) = WAIT_TIMEOUT then
    begin
      Synchronize(procedure
        begin
          fmMain.memo1.Lines.add(the_holder + ' !!! JUMP :->' + the_jump_time.ToString);
        end
      );
      FinishThreadExecution;
    end;
  end;

end;

procedure TVoteForJnA.FinishThreadExecution;
begin
    Terminate;
    SetEvent(FTickEvent);
end;

procedure TVoteForJnA.moveVote;
begin
     //
end;

end.
