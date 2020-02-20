program ThreadTest;

uses
  Vcl.Forms,
  Windows,
  uMain in 'uMain.pas' {fmMain},
  utimerThread in 'utimerThread.pas',
  uvoteForJnA in 'uvoteForJnA.pas',
  uvoteForRep in 'uvoteForRep.pas',
  Bcrypt in '..\bcrypt\Bcrypt.pas',
  AES128 in 'AES128.pas',
  ugetTierList in 'ugetTierList.pas';

{$R *.res}

var  MutexHandle: THandle;  //variable added to enabled open one instance

begin
 //being open on instance
  MutexHandle := CreateMutex(nil, TRUE, 'MyUniqueIdentifier');  //Anyidentifier you want here
  if MutexHandle <> 0 then
  begin
      if GetLastError = ERROR_ALREADY_EXISTS then
      begin
         MessageBox(0, 'Instance of this application is Already Running.',
                       'Application already running', MB_ICONINFORMATION);
         CloseHandle(MutexHandle);
         Halt;
      end
  end;
  //end open one instance
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
