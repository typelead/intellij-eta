module FFI.Com.TypeLead.IntelliJ.Plugin.Cabal.Project.Module.CabalPackageSettingsStep where

import P.Base
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleBuilder
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleWizardStep
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.WizardContext
import FFI.Com.TypeLead.IntelliJ.Plugin.Cabal.Project.Module.NewCabalProjectForm

data CabalPackageSettingsStep = CabalPackageSettingsStep
  @com.typelead.intellij.plugin.cabal.project.module.CabalPackageSettingsStep
  deriving Class

type instance Inherits CabalPackageSettingsStep = '[ModuleWizardStep]

foreign import java unsafe "@new" newCabalPackageSettingsStep
  :: ModuleBuilder -> WizardContext -> NewCabalProjectForm -> Java a CabalPackageSettingsStep
