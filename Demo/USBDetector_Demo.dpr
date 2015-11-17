program USBDetector_Demo;

uses
  Forms,
  F_Main in 'F_Main.pas' {FRM_Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFRM_Main, FRM_Main);
  Application.Run;
end.
