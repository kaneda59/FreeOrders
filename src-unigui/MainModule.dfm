object UniMainModule: TUniMainModule
  OldCreateOrder = False
  OnCreate = UniGUIMainModuleCreate
  OnDestroy = UniGUIMainModuleDestroy
  Theme = 'uni_emerald'
  MonitoredKeys.Keys = <>
  Height = 150
  Width = 215
  object tmgetToken: TUniTimer
    Enabled = False
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = tmgetTokenTimer
    Left = 120
    Top = 72
  end
end
