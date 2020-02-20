object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Thread Test'
  ClientHeight = 729
  ClientWidth = 1282
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
    Width = 1282
    Height = 729
    ActivePage = page_main
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 1155
    ExplicitHeight = 861
    object page_main: TTabSheet
      Caption = 'MAIN'
      ExplicitWidth = 1147
      ExplicitHeight = 831
      object pnl_top: TPanel
        Left = 0
        Top = 0
        Width = 1274
        Height = 41
        Align = alTop
        BevelEdges = [beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 1147
        object lbl_round: TLabel
          AlignWithMargins = True
          Left = 1014
          Top = 3
          Width = 257
          Height = 33
          Align = alRight
          AutoSize = False
          Caption = 'Current Mining Round :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 8388863
          Font.Height = -19
          Font.Name = 'NanumGothic'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 872
          ExplicitTop = 4
          ExplicitHeight = 35
        end
        object btn_thread_test: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 190
          Height = 33
          Align = alLeft
          Caption = 'START MAIN THREAD'
          TabOrder = 0
          OnClick = btn_thread_testClick
          ExplicitTop = -2
          ExplicitHeight = 41
        end
        object btn_stop: TButton
          AlignWithMargins = True
          Left = 199
          Top = 3
          Width = 190
          Height = 33
          Align = alLeft
          Caption = 'STOP MAIN THREAD'
          TabOrder = 1
          OnClick = btn_stopClick
          ExplicitLeft = 222
          ExplicitTop = -2
          ExplicitHeight = 41
        end
        object Button2: TButton
          Left = 456
          Top = 10
          Width = 75
          Height = 25
          Caption = 'Button2'
          TabOrder = 2
          Visible = False
          OnClick = Button2Click
        end
      end
      object pnl_bottom: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 655
        Width = 1268
        Height = 41
        Align = alBottom
        BevelEdges = [beTop]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 1141
        object Button1: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 217
          Height = 33
          Align = alLeft
          Caption = 'Show Notification Create'
          TabOrder = 0
          Visible = False
          OnClick = Button1Click
          ExplicitTop = 6
        end
        object btn_terminate: TButton
          AlignWithMargins = True
          Left = 1125
          Top = 3
          Width = 140
          Height = 33
          Align = alRight
          Caption = 'Terminate APP'
          TabOrder = 1
          OnClick = btn_terminateClick
          ExplicitLeft = 989
          ExplicitTop = 6
        end
      end
      object pnl_client: TPanel
        Left = 0
        Top = 41
        Width = 1274
        Height = 611
        Align = alClient
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 2
        ExplicitLeft = 480
        ExplicitTop = 328
        ExplicitWidth = 185
        ExplicitHeight = 41
        object pnl_client_right: TPanel
          Left = 0
          Top = 0
          Width = 569
          Height = 611
          Align = alLeft
          BevelEdges = [beRight]
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 0
          object lbl_info: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 561
            Height = 20
            Align = alTop
            Caption = 'Information Of Current Vote Status'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'NanumGothic'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            ExplicitLeft = 27
            ExplicitTop = 35
            ExplicitWidth = 270
          end
          object Memo1: TMemo
            AlignWithMargins = True
            Left = 167
            Top = 29
            Width = 397
            Height = 579
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'NanumGothic'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            ExplicitLeft = 3
            ExplicitWidth = 618
          end
          object Memo2: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 29
            Width = 158
            Height = 579
            Align = alLeft
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'NanumGothic'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
          end
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 572
          Top = 3
          Width = 699
          Height = 605
          Align = alClient
          BevelEdges = []
          BevelOuter = bvNone
          Caption = 'Panel1'
          TabOrder = 1
          ExplicitLeft = 480
          ExplicitTop = 288
          ExplicitWidth = 185
          ExplicitHeight = 41
          object Memo3: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 44
            Width = 383
            Height = 558
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = 3355443
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'NanumGothic'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            ExplicitTop = 29
            ExplicitWidth = 382
            ExplicitHeight = 573
          end
          object mem_tier: TMemo
            AlignWithMargins = True
            Left = 392
            Top = 44
            Width = 304
            Height = 558
            Align = alRight
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = 3355443
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'NanumGothic'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            ExplicitTop = 29
            ExplicitHeight = 573
          end
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 699
            Height = 41
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            object lbl_info_hist: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 383
              Height = 35
              Align = alLeft
              Caption = 'Information Of Current Vote Status'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'NanumGothic'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object lbl_tierList: TLabel
              AlignWithMargins = True
              Left = 638
              Top = 3
              Width = 58
              Height = 35
              Align = alRight
              Alignment = taRightJustify
              Caption = 'Tier List'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'NanumGothic'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
              ExplicitLeft = 426
              ExplicitHeight = 20
            end
          end
        end
      end
    end
    object page_Manage: TTabSheet
      Caption = 'Manage'
      ImageIndex = 1
      ExplicitWidth = 1147
      ExplicitHeight = 831
    end
    object page_db: TTabSheet
      Caption = 'DB'
      ImageIndex = 2
      ExplicitWidth = 1147
      ExplicitHeight = 831
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
  object LbRijndael1: TLbRijndael
    CipherMode = cmECB
    KeySize = ks128
    Left = 568
    Top = 440
  end
end
