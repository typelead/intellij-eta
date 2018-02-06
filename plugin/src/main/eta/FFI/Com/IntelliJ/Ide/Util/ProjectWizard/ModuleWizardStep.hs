module FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleWizardStep where

import P

data ModuleWizardStep = ModuleWizardStep
  @com.intellij.ide.util.projectWizard.ModuleWizardStep
  deriving Class

type instance Inherits ModuleWizardStep = '[Object]

data ModuleWizardStepArray = ModuleWizardStepArray
  @com.intellij.ide.util.projectWizard.ModuleWizardStep[]
  deriving Class

instance JArray ModuleWizardStep ModuleWizardStepArray

foreign import java unsafe updateDataModel
  :: (a <: ModuleWizardStep) => Java a ()
