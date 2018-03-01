module FFI.Com.IntelliJ.Ide.Util.ProjectWizard.WizardContext where

import P

data WizardContext = WizardContext
  @com.intellij.ide.util.projectWizard.WizardContext
  deriving Class

type instance Inherits WizardContext = '[Object]

foreign import java unsafe isCreatingNewProject
  :: Java WizardContext Bool
