unit USBDetect;

////////////////////////////////////////////////////
///                                              ///
///  USB Detector component     Ver 2.0.0.0      ///
///                                              ///
///  Written by Mojtaba Tajik ( Silversoft )     ///
///  Released on 10/13/2010                      ///
///  E-Mail : Tajik1991@gmail.com                ///
///                                              ///
////////////////////////////////////////////////////

interface

uses
  Windows, Forms, SysUtils, Classes, Messages, dialogs;

type
  TUSBEvent= Procedure (Sender: TObject; Drive: String) of Object;

type
  TUSBDetector = class(TComponent)
  private
    { Private declarations }
    FWindowHandle: HWND;
    FArrival, FRemoved: TUSBEvent;
    procedure WndProc(var Msg: TMessage);
  protected
    { Protected declarations }
    procedure WMDEVICECHANGE(Var Msg: TMessage); Message WM_DEVICECHANGE;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    Property OnArrival: TUSBEvent read FArrival write FArrival;
    Property OnRemoved: TUSBEvent read FRemoved write FRemoved;
  end;

procedure Register;

// Device constants
const
  DBT_DEVICEARRIVAL          =  $00008000;
  DBT_DEVICEREMOVECOMPLETE   =  $00008004;
  DBT_DEVTYP_VOLUME          =  $00000002;
// Device structs
type
  _DEV_BROADCAST_HDR         =  packed record
     dbch_size:              DWORD;
     dbch_devicetype:        DWORD;
     dbch_reserved:          DWORD;
  end;
  DEV_BROADCAST_HDR          =  _DEV_BROADCAST_HDR;
  TDevBroadcastHeader        =  DEV_BROADCAST_HDR;
  PDevBroadcastHeader        =  ^TDevBroadcastHeader;
type
  _DEV_BROADCAST_VOLUME      =  packed record
     dbch_size:              DWORD;
     dbch_devicetype:        DWORD;
     dbch_reserved:          DWORD;
     dbcv_unitmask:          DWORD;
     dbcv_flags:             WORD;
  end;
  DEV_BROADCAST_VOLUME       =  _DEV_BROADCAST_VOLUME;
  TDevBroadcastVolume        =  DEV_BROADCAST_VOLUME;
  PDevBroadcastVolume        =  ^TDevBroadcastVolume;

implementation

procedure Register;
begin
  RegisterComponents('NAP', [TUSBDetector]);
end;

{ TUSBDetector }

constructor TUSBDetector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWindowHandle := AllocateHWnd(WndProc);
end;

destructor TUSBDetector.Destroy;
begin
  DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TUSBDetector.WMDEVICECHANGE(var Msg: TMessage);
var
  lpdbhHeader: PDevBroadcastHeader;
  lpdbvData:   PDevBroadcastVolume;
  dwIndex:     Integer;
  lpszDrive:   String;
begin
  inherited;
  // Get the device notification header
  lpdbhHeader:=PDevBroadcastHeader(Msg.lParam);
  // Handle the message
  case Msg.WParam of
     DBT_DEVICEARRIVAL:    {a USB drive was connected}
     begin
        if (lpdbhHeader^.dbch_devicetype = DBT_DEVTYP_VOLUME) then
        begin
           lpdbvData:=PDevBroadcastVolume(Msg.lParam);
           for dwIndex :=0 to 25 do
           begin
              if ((lpdbvData^.dbcv_unitmask shr dwIndex) = 1) then
              begin
                 lpszDrive:=lpszDrive+Chr(65+dwIndex)+ ':';
                 Break;
              end;
           end;
           if Assigned(OnArrival) then
            OnArrival(Self, lpszDrive);
        end;
     end;
     DBT_DEVICEREMOVECOMPLETE:    {a USB drive was removed}
     begin
        if (lpdbhHeader^.dbch_devicetype = DBT_DEVTYP_VOLUME) then
        begin
           lpdbvData:=PDevBroadcastVolume(Msg.lParam);
           for dwIndex:=0 to 25 do
           begin
              if ((lpdbvData^.dbcv_unitmask shr dwIndex) = 1) then
              begin
                 lpszDrive:=lpszDrive+Chr(65+dwIndex)+ ':';
                 Break;
              end;
           end;
           if Assigned(OnRemoved) then
            OnRemoved(Self, lpszDrive);
        end;
     end;
  end;
end;

procedure TUSBDetector.WndProc(var Msg: TMessage);
begin
  if (Msg.Msg = WM_DEVICECHANGE) then
  begin
    try
      WMDeviceChange(Msg);
    except
      Application.HandleException(Self);
    end;
  end
end;

end.
