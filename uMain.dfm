object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Thread Test'
  ClientHeight = 861
  ClientWidth = 1155
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'NanumGothic'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1155
    Height = 861
    ActivePage = page_main
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 752
    object page_main: TTabSheet
      Caption = 'MAIN'
      ExplicitLeft = 8
      ExplicitTop = 30
      object lbl_info: TLabel
        Left = 3
        Top = 59
        Width = 270
        Height = 20
        Caption = 'Information Of Current Vote Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'NanumGothic'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl_round: TLabel
        Left = 872
        Top = 19
        Width = 257
        Height = 35
        AutoSize = False
        Caption = 'Current Mining Round :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8388863
        Font.Height = -19
        Font.Name = 'NanumGothic'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btn_terminate: TButton
        Left = 989
        Top = 752
        Width = 140
        Height = 65
        Caption = 'Terminate APP'
        TabOrder = 0
        OnClick = btn_terminateClick
      end
      object btn_thread_test: TButton
        Left = 3
        Top = 12
        Width = 190
        Height = 41
        Caption = 'START MAIN THREAD'
        TabOrder = 1
        OnClick = btn_thread_testClick
      end
      object Button1: TButton
        Left = 3
        Top = 795
        Width = 217
        Height = 33
        Caption = 'Show Notification Create'
        TabOrder = 2
        OnClick = Button1Click
      end
      object Memo1: TMemo
        Left = 3
        Top = 88
        Width = 409
        Height = 701
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'NanumGothic'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object Memo2: TMemo
        Left = 439
        Top = 88
        Width = 170
        Height = 701
        TabOrder = 4
      end
      object Memo3: TMemo
        Left = 631
        Top = 88
        Width = 498
        Height = 658
        TabOrder = 5
      end
      object btn_stop: TButton
        Left = 222
        Top = 12
        Width = 190
        Height = 41
        Caption = 'STOP MAIN THREAD'
        TabOrder = 6
        OnClick = btn_stopClick
      end
    end
    object page_Manage: TTabSheet
      Caption = 'Manage'
      ImageIndex = 1
      ExplicitHeight = 722
    end
    object page_db: TTabSheet
      Caption = 'DB'
      ImageIndex = 2
      ExplicitHeight = 722
      object grp_db: TGroupBox
        Left = 368
        Top = 152
        Width = 353
        Height = 369
        Caption = 'Database Info'
        TabOrder = 0
        Visible = False
        object Label1: TLabel
          Left = 64
          Top = 64
          Width = 41
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'HOST :'
        end
        object Label2: TLabel
          Left = 64
          Top = 99
          Width = 41
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'PORT :'
        end
        object Label3: TLabel
          Left = 24
          Top = 136
          Width = 81
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'USERNAME :'
        end
        object Label4: TLabel
          Left = 24
          Top = 176
          Width = 81
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'PASSWORD :'
        end
        object Label5: TLabel
          Left = 24
          Top = 216
          Width = 81
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'DATABASE :'
        end
        object edt_host: TEdit
          Left = 123
          Top = 57
          Width = 145
          Height = 23
          BevelEdges = [beBottom]
          BevelInner = bvNone
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 0
          Text = '49.142.215.132'
        end
        object edt_username: TEdit
          Left = 123
          Top = 131
          Width = 145
          Height = 23
          BevelEdges = [beBottom]
          BevelInner = bvNone
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 1
          Text = 'chavo'
        end
        object edt_password: TEdit
          Left = 123
          Top = 170
          Width = 145
          Height = 23
          BevelEdges = [beBottom]
          BevelInner = bvNone
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 2
          Text = 'fedora'
        end
        object edt_database: TEdit
          Left = 123
          Top = 213
          Width = 145
          Height = 23
          BevelEdges = [beBottom]
          BevelInner = bvNone
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 3
          Text = 'chavobase'
        end
        object spin_port: TSpinEdit
          Left = 123
          Top = 101
          Width = 122
          Height = 24
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 3306
        end
        object btn_connect: TButton
          Left = 120
          Top = 264
          Width = 153
          Height = 41
          Caption = 'CONNECT'
          TabOrder = 5
          OnClick = btn_connectClick
        end
      end
      object edt_db_pwd: TEdit
        Left = 488
        Top = 88
        Width = 121
        Height = 23
        PasswordChar = '#'
        TabOrder = 1
        OnChange = edt_db_pwdChange
      end
    end
  end
  object TrayIcon1: TTrayIcon
    BalloonHint = 'Hintos'
    BalloonTitle = 'Minimized'
    Visible = True
    OnClick = TrayIcon1Click
    Left = 48
    Top = 24
  end
  object jvNot: TJvDesktopAlert
    Location.Top = 20
    Location.Left = 30
    Location.Width = 400
    Location.Height = 100
    HeaderText = 'Header Here'
    MessageText = 'MessageText Goes Here'
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -13
    HeaderFont.Name = 'Segoe UI'
    HeaderFont.Style = [fsBold]
    ShowHint = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Buttons = <>
    Left = 504
    Top = 552
  end
end
