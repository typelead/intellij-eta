module FFI.Com.IntelliJ.OpenApi.Module.ModuleType where

import P

import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleBuilder
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleWizardStep
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.SettingsStep

data ModuleType a = ModuleType
  (@com.intellij.openapi.module.ModuleType a)
  deriving Class

foreign import java unsafe modifyProjectTypeStep
  :: SettingsStep
  -> ModuleBuilder
  -> Java (ModuleType ModuleBuilder) ModuleWizardStep
