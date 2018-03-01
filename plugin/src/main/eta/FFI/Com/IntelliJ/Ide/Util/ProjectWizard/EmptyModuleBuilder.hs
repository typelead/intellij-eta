module FFI.Com.IntelliJ.Ide.Util.ProjectWizard.EmptyModuleBuilder where

import P

import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleBuilder (ModuleBuilder)

data EmptyModuleBuilder = EmptyModuleBuilder
  @com.intellij.ide.util.projectWizard.EmptyModuleBuilder
  deriving Class

type instance Inherits EmptyModuleBuilder = '[ModuleBuilder]
