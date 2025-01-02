object ServerContainer1: TServerContainer1
  OldCreateOrder = True
  Height = 678
  Width = 1038
  object DSServer1: TDSServer
    Left = 240
    Top = 28
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 500
    Top = 28
  end
end
