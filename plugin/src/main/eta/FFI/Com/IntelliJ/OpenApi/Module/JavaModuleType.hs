module FFI.Com.IntelliJ.OpenApi.Module.JavaModuleType where

import P

import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleBuilder (ModuleBuilder)
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.JavaModuleBuilder (JavaModuleBuilder)
import FFI.Com.IntelliJ.OpenApi.Module.ModuleType (ModuleType)

data JavaModuleType = JavaModuleType
  @com.intellij.openapi.module.JavaModuleType
  deriving Class

type instance Inherits JavaModuleType = '[ModuleType JavaModuleBuilder]

foreign import java unsafe
  "@static com.intellij.openapi.module.JavaModuleType.getModuleType"
  getJavaModuleType :: Java a (ModuleType ModuleBuilder)
