module FFI.Com.IntelliJ.Ide.Util.ProjectWizard.JavaModuleBuilder where

import P

import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleBuilder (ModuleBuilder)
import FFI.Com.IntelliJ.OpenApi.Roots.ModifiableRootModel (ModifiableRootModel)

data JavaModuleBuilder = JavaModuleBuilder
  @com.intellij.ide.util.projectWizard.JavaModuleBuilder
  deriving Class

type instance Inherits JavaModuleBuilder = '[ModuleBuilder]

foreign import java unsafe setupRootModel
  :: ModifiableRootModel -> Java JavaModuleBuilder ()
