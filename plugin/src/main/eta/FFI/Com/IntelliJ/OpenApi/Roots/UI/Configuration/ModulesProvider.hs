module FFI.Com.IntelliJ.OpenApi.Roots.UI.Configuration.ModulesProvider where

import P

data ModulesProvider = ModulesProvider
  @com.intellij.openapi.roots.ui.configuration.ModulesProvider
  deriving Class

type instance Inherits ModulesProvider = '[Object]
