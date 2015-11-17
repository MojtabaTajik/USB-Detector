object FRM_Main: TFRM_Main
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'USB Detector Demo by Mojtaba Tajik'
  ClientHeight = 212
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MEM_Status: TMemo
    Left = 8
    Top = 8
    Width = 441
    Height = 201
    BiDiMode = bdLeftToRight
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object USBDetector1: TUSBDetector
    OnArrival = USBDetector1Arrival
    OnRemoved = USBDetector1Removed
    Left = 40
    Top = 152
  end
end
