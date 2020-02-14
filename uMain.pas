unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  //
  utimerThread,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Notification, JvBaseDlg, JvDesktopAlert, Data.DB, DBAccess, MyAccess,
  MemDS, Vcl.ComCtrls, Vcl.Samples.Spin;

type
  TfmMain = class(TForm)
    Memo1: TMemo;
    btn_thread_test: TButton;
    Memo2: TMemo;
    TrayIcon1: TTrayIcon;
    btn_terminate: TButton;
    jvNot: TJvDesktopAlert;
    Button1: TButton;
    PageControl1: TPageControl;
    page_main: TTabSheet;
    page_Manage: TTabSheet;
    page_db: TTabSheet;
    grp_db: TGroupBox;
    edt_db_pwd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edt_host: TEdit;
    edt_username: TEdit;
    edt_password: TEdit;
    edt_database: TEdit;
    spin_port: TSpinEdit;
    btn_connect: TButton;
    Memo3: TMemo;
    btn_stop: TButton;
    lbl_info: TLabel;
    lbl_round: TLabel;
    procedure btn_thread_testClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure btn_terminateClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure edt_db_pwdChange(Sender: TObject);
    procedure btn_connectClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
  private
    { Private declarations }
    procedure OnClose(Sender:TObject);
    procedure WMSysCommand(VAR Msg: TWMSysCommand);
  public
    { Public declarations }

    function isConnected(aConn : TMyConnection) : Boolean;
    procedure show_notif(aheader,amsg : String);

var
   FTimerThread: TTimerThread;
  end;

var
  fmMain: TfmMain;
  RemoteCanClose : boolean = false;

implementation

{$R *.dfm}

procedure TfmMain.btn_connectClick(Sender: TObject);
var
  aConn : TMyConnection;
begin
    aconn := tmyconnection.Create(self);

    try
       if isConnected(aconn) then
        begin
          ShowMessage('Connected');
        end
        else
        begin
          ShowMessage('Not Connected');
        end;

    finally
      aconn.Free;

    end;
end;

procedure TfmMain.btn_stopClick(Sender: TObject);
begin
    btn_stop.Enabled := false;
    btn_thread_test.Enabled := true;
     if Assigned(FTimerThread) then
    FTimerThread.FinishThreadExecution;
end;

procedure TfmMain.btn_terminateClick(Sender: TObject);
begin
    application.Terminate;
end;

procedure TfmMain.btn_thread_testClick(Sender: TObject);
begin
    memo1.Lines.Clear;
    btn_thread_test.Enabled := false;
    btn_stop.Enabled := true;
    FTimerThread := TTimerThread.Create('One');
end;

procedure TfmMain.Button1Click(Sender: TObject);
var
  anotif : TJvDesktopAlert;
begin
    anotif := TJvDesktopAlert.Create(Self);
    anotif.AutoFree := true;
    anotif.HeaderText := 'Thread APP';
    anotif.MessageText := 'CREATED nOT ification';
    anotif.Location.Position := dapBottomRight;
    anotif.Execute;
end;

procedure TfmMain.edt_db_pwdChange(Sender: TObject);
begin
    if edt_db_pwd.Text = 'jisunachu' then
     begin
       grp_db.Visible := true;
     end
     else
     begin
       grp_db.Visible := false;
     end;
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     CanClose := RemoteCanClose;
     fmMain.Show;         // X will not work again unless this done before hide
     fmMain.Hide;
     show_notif('JnA Auto Vote','Program Minimized to System Tray!');
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
   // ReportMemoryLeaksOnShutdown := True;
    Application.OnMinimize:=OnClose;

end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
   if Assigned(FTimerThread) then
    FTimerThread.FinishThreadExecution;
end;

function TfmMain.isConnected(aConn: TMyConnection): Boolean;
begin
        result := false;
        try
               aConn.Close;
               aconn.Options.UseUnicode := true;
               aConn.Server := edt_host.text;
               aConn.Port := spin_port.Value;
               aConn.Username := edt_username.text;
               aConn.Password := edt_password.text;
               aConn.Database := edt_database.text;
               aConn.LoginPrompt := False;
               aConn.Open;
               result := true;
        except
        on E : Exception do
        begin
          //showmessage(E.ClassName + ' Error Message: ' + E.Message);
          result := false;
        end;

        end;
end;

procedure TfmMain.OnClose(Sender: TObject);
begin
      Hide;
      show_notif('JnA Auto Vote','Program Minimized to System Tray!')
end;

procedure TfmMain.show_notif(aheader, amsg: String);
var
  the_notif : TJvDesktopAlert;
begin
    the_notif := TJvDesktopAlert.Create(Self);
    the_notif.AutoFree := true;
    the_notif.HeaderText := aheader;
    the_notif.MessageText := amsg;
    the_notif.Location.Position := dapBottomRight;
    the_notif.Execute;
end;

procedure TfmMain.TrayIcon1Click(Sender: TObject);
begin

     if Visible
     then begin // Application is visible, so minimize it to TrayIcon
               Application.Minimize; // This is to minimize the whole application
          end
     else begin // Application is not visible, so show it
               Show; // This is to show it from taskbar
               Application.Restore; // This is to restore the whole application
               Application.BringToFront();
          end;
end;

procedure TfmMain.WMSysCommand(var Msg: TWMSysCommand);
begin
     if Msg.CmdType = SC_CLOSE then          // - button  (upper right of form next to X button)
        RemoteCanClose := False;
end;

end.