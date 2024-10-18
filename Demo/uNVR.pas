unit uNVR;

interface

uses Vcl.Forms, System.SysUtils, WinApi.Windows, Vcl.Comctrls,
     Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Winapi.ActiveX, System.Classes,
     HCNetSDK;

type
  TNVR = class(TObject)
  private
    UserID: Integer;
    PlayHandle: LONG;
    function GetChannelXML: String;
    procedure GetChannelList;
    procedure CheckChannelState;
  protected
    FConnected: Boolean;
  public
    ChannelList: TStringList;
    StartDChannel, IPChanNum: Word;
    procedure Connect(RecorderIP, Port, UserName, Password, StreamPassword: String);
    procedure StartPlaying(aHWND: HWND; ChNo: Word);
    procedure StopPlaying;
    function GetErrorMsg: String;
    property Connected: Boolean Read FConnected;
    constructor Create;
    destructor  Destroy; override;
  end;

implementation

constructor TNVR.Create;
begin
  inherited Create;
  UserID := -1;
  ChannelList := TStringList.Create;

  NET_DVR_Init;
end;

destructor TNVR.Destroy;
begin
  if Userid >= 0 then NET_DVR_Logout_V30(UserID);
  NET_DVR_Cleanup;
  ChannelList.Free;
  inherited;
end;

procedure TNVR.Connect(RecorderIP, Port, UserName, Password, StreamPassword: String);
var
  DeviceInfo: NET_DVR_DEVICEINFO_V30;
  pIP, pUserName, pPassword: PAnsiChar;
begin
  pIP       := PAnsiChar(AnsiString(RecorderIP));
  pUserName := PAnsiChar(AnsiString(UserName));
  pPassword := PAnsiChar(AnsiString(Password));

  UserID := NET_DVR_Login_V30(pIP, Port.ToInteger, pUserName, pPassword, @DeviceInfo);
  if UserID >= 0 then
  begin
    FConnected := True;
    StartDChannel := DeviceInfo.byStartDChan;
    IPChanNum := DeviceInfo.byIPChanNum;
    StreamPassword := StreamPassword.Trim;
    if StreamPassword <> '' then //��������������ܣ�Ԥ�������ṩ�������ܵ�����
      NET_DVR_SetSDKSecretKey(UserID, PAnsiChar(AnsiString(StreamPassword)));

    ChannelList.Clear;
    GetChannelList;
    CheckChannelState
  end
  else
  begin
    FConnected := False;
    raise Exception.Create('����¼�������' + GetErrorMsg);
  end
end;

procedure TNVR.StartPlaying(aHWND: HWND; ChNo: Word);
var
  struPlayInfo: NET_DVR_PREVIEWINFO;
begin
  ZeroMemory(@struPlayInfo, SizeOf(struPlayInfo));
  struPlayInfo.hPlayWnd     := aHWND;    //��ҪSDK����ʱ�����Ϊ��Чֵ����ȡ��������ʱ����Ϊ��
  struPlayInfo.lChannel     := ChNo + StartDChannel - 1;       //Ԥ��ͨ����
  struPlayInfo.dwStreamType := 0;  //0-��������1-��������2-����3��3-����4���Դ�����
  struPlayInfo.dwLinkMode   := 4;  //0- TCP��ʽ��1- UDP��ʽ��2- �ಥ��ʽ��3- RTP��ʽ��4-RTP/RTSP��5-RSTP/HTTP
  struPlayInfo.bBlocked     := 1;  //0- ������ȡ����1- ����ȡ��
  PlayHandle := NET_DVR_RealPlay_V40(UserID, @struPlayInfo, nil, nil);
  if PlayHandle < 0 then
    raise Exception.Create('ʵʱԤ������: ' + GetErrorMsg);
end;

procedure TNVR.StopPlaying;
begin
  NET_DVR_StopRealPlay(PlayHandle);
end;

function TNVR.GetChannelXML: String;
var
  UrlBuf: TBytes;
  Input: NET_DVR_XML_CONFIG_INPUT;
  Output: NET_DVR_XML_CONFIG_OUTPUT;
  OutputBuf: array[0..64*1024-1] of Byte;
  StatusBuf: array[0..2*1024-1] of Byte;
begin
  //����------------------------------------------------------------------------
  UrlBuf := TEncoding.UTF8.GetBytes('GET /ISAPI/ContentMgmt/InputProxy/channels'#13#10);

  ZeroMemory(@Input, SizeOf(Input));
  Input.dwSize := SizeOf(Input);

  Input.lpRequestUrl := @UrlBuf[0];
  Input.dwRequestUrlLen := Length(UrlBuf);

  //���------------------------------------------------------------------------
  ZeroMemory(@Output, SizeOf(Output));
  Output.dwSize := SizeOf(Output);

  ZeroMemory(@OutputBuf, SizeOf(OutputBuf));
  Output.lpOutBuffer := @OutputBuf;
  Output.dwOutBufferSize := SizeOf(OutputBuf);

  ZeroMemory(@StatusBuf, SizeOf(StatusBuf));
  Output.lpStatusBuffer := @StatusBuf;
  Output.dwStatusSize := SizeOf(StatusBuf);

  NET_DVR_STDXMLConfig(UserID, @Input, @OutPut);

  //���----------------------------------------------------------------------------
  Result := TEncoding.UTF8.GetString(OutputBuf)
end;

procedure TNVR.GetChannelList;
var
  S: String;
  I: Integer;
  ChNo: UInt16;
  Xml: IXMLDocument;
  Rootnode: IXMLNode;
  Nodelist: IXMLNodeList;
begin
  Xml := TXMLDocument.Create(nil);
  TXMLDocument(Xml).DOMVendor := DOMVendors.Find('MSXML');

  S := GetChannelXML;
  Xml.LoadFromXML(S);
  Rootnode := Xml.DocumentElement;
  Nodelist := Rootnode.ChildNodes;
  for I := 0 to Nodelist.Count - 1 do
  begin
    ChNo := NodeList[I].ChildNodes.FindNode('id').NodeValue;
    ChannelList.Add(ChNo.ToString);
  end;
  Xml.Active := False;
end;

procedure TNVR.CheckChannelState;
var
  I, J, ChNo, dwList: DWORD;
  WorkState40: NET_DVR_WORKSTATE_V40;
  ChannelState: NET_DVR_CHANNELSTATE_V30;
  struWorkStateCond: NET_DVR_GETWORKSTATE_COND;
begin
  dwList := 0;
  FillChar(struWorkStateCond, SizeOf(struWorkStateCond), #0);
  struWorkStateCond.dwSize := SizeOf(NET_DVR_GETWORKSTATE_COND);
  struWorkStateCond.byFindChanByCond := 0;
  struWorkStateCond.byFindHardByCond := 0;

  NET_DVR_GetDeviceConfig(UserID, NET_DVR_GET_WORK_STATUS, 1 ,
                 @struWorkStateCond, SizeOf(NET_DVR_GETWORKSTATE_COND), @dwList,
                 @WorkState40      , SizeOf(NET_DVR_WORKSTATE_V40   ));

  for I := ChannelList.Count - 1 downto 0 do
  begin
    ChNo := ChannelList[I].ToInteger;
    for J := 0 to MAX_CHANNUM_V40 - 1 do
    begin
      ChannelState := WorkState40.struChanStatic[J];
      if (ChannelState.dwChannelNo = Cardinal(ChNo + StartDChannel - 1)) then
      begin
        if(ChannelState.bySignalStatic   <> 0) or
          (ChannelState.byHardwareStatic <> 0) then
        begin
          ChannelList.Delete(I);
        end;
        Break;
      end;
    end
  end;
end;

function TNVR.GetErrorMsg: String;
var
  ErrNo: Integer;
begin
  ErrNo := NET_DVR_GetLastError;
  Result := '������� = ' + ErrNo.ToString + ', ' + '������Ϣ = ' +
                    String(AnsiString(NET_DVR_GetErrorMsg(@ErrNo)));
end;

end.
