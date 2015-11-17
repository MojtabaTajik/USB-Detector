unit F_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, USBDetect;

type
  TFRM_Main = class(TForm)
    USBDetector1: TUSBDetector;
    MEM_Status: TMemo;
    procedure USBDetector1Arrival(Sender: TObject; Drive: string);
    procedure USBDetector1Removed(Sender: TObject; Drive: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRM_Main: TFRM_Main;

implementation

{$R *.dfm}

procedure TFRM_Main.USBDetector1Arrival(Sender: TObject; Drive: string);
begin
  // Detect new USB device connected and return drive name
  MEM_Status.Lines.Add('+ New USB device arrival = ' + Drive);
end;

procedure TFRM_Main.USBDetector1Removed(Sender: TObject; Drive: string);
begin
  // Detect removed USB device disconnected and return drive name
  MEM_Status.Lines.Add('- Removed USB device = ' + Drive);
end;

end.
