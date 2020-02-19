unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  //
  utimerThread,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Notification, JvBaseDlg, JvDesktopAlert, Data.DB, DBAccess, MyAccess,
  MemDS, Vcl.ComCtrls, Vcl.Samples.Spin, LbCipher, LbClass;

type
  TfmMain = class(TForm)
    Memo1: TMemo;
    btn_thread_test: TButton;
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
    LbRijndael1: TLbRijndael;
    lbl_info_hist: TLabel;
    pnl_top: TPanel;
    pnl_bottom: TPanel;
    pnl_client: TPanel;
    pnl_client_right: TPanel;
    Panel1: TPanel;
    Button2: TButton;
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
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure OnClose(Sender:TObject);
    procedure WMSysCommand(VAR Msg: TWMSysCommand);
  public
    { Public declarations }

    function isConnected(aConn : TMyConnection) : Boolean;
    procedure show_notif(aheader,amsg : String);

    //open one instance
   // procedure WMRestoreApp(var Msg: TMessage);

    var

      tabs: Array [0..2] of Integer;
      WM_FINDINSTANCE: Integer;

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
  if MessageDlg('End Auto Vote?' , mtConfirmation, mbYesNo, 0) = mrYes then
        begin
          btn_stop.Enabled := false;
          btn_thread_test.Enabled := true;
           if Assigned(FTimerThread) then
          FTimerThread.FinishThreadExecution;
        end;
end;

procedure TfmMain.btn_terminateClick(Sender: TObject);
begin
 if MessageDlg('Close App? Current Auto Vote App will Close!' , mtConfirmation, mbYesNo, 0) = mrYes then
        begin
    application.Terminate;
        end;
end;

procedure TfmMain.btn_thread_testClick(Sender: TObject);
begin
  tabs[0] := 15 * 4; //name
  tabs[1] := 30 * 4; //Type
  tabs[2] := 50 * 4;  //Rep
  if MessageDlg('Start Auto Vote?' , mtConfirmation, mbYesNo, 0) = mrYes then
        begin
    memo1.Lines.Clear;
    btn_thread_test.Enabled := false;
    btn_stop.Enabled := true;
    FTimerThread := TTimerThread.Create('One');
        end;
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

procedure TfmMain.Button2Click(Sender: TObject);
var
  the_holder : String;
  atrimMiner,the_round : string;
begin
       { tabs[0] := 15 * 4; //name
        tabs[1] := 30 * 4; //Type
        tabs[2] := 50 * 4;  //Rep  }
      the_holder := 'JISU ';
      atrimminer := 't0d504';
      the_round := '0.9';
      the_holder := 'JISU MIPAD';
      atrimminer := 't0d504...112326';
      the_round := '0.9';
      Memo1.Lines.Add(''+the_holder+''#9'Move To'#9''+
                          atrimMiner+''#9''+the_round+'');

      Memo1.Perform( EM_SETTABSTOPS, 4, LongInt(@tabs));
      Memo1.Refresh;
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
    LbRijndael1.GenerateKey('JISUNACHU');

end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
   if Assigned(FTimerThread) then
    FTimerThread.FinishThreadExecution;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
        tabs[0] := 10 * 4; //name
        tabs[1] := 40 * 4; //Type
        tabs[2] := 70 * 4;  //Rep
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
