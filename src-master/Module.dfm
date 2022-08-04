object Donnees: TDonnees
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object connection: TADOConnection
    Left = 32
    Top = 24
  end
  object tmgetToken: TTimer
    Enabled = False
    OnTimer = tmgetTokenTimer
    Left = 104
    Top = 72
  end
end
