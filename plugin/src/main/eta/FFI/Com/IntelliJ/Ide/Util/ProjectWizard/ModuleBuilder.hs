module FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleBuilder where

import Prelude
import Java
import FFI.Com.IntelliJ.OpenApi.Module.Module
import FFI.Com.IntelliJ.OpenApi.Roots.ModifiableRootModel
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.AbstractModuleBuilder (AbstractModuleBuilder)

data ModuleBuilder = ModuleBuilder
  @com.intellij.ide.util.projectWizard.ModuleBuilder
  deriving Class

type instance Inherits ModuleBuilder = '[AbstractModuleBuilder]

foreign import java unsafe "addModuleConfigurationUpdater"
  addModuleConfigurationUpdaterJava
  :: (a <: ModuleBuilder)
  => ModuleConfigurationUpdater -> Java a ()

addModuleConfigurationUpdater
  :: (a <: ModuleBuilder)
  => (Module -> ModifiableRootModel -> Java x ())
  -> Java a ()
addModuleConfigurationUpdater f =
  addModuleConfigurationUpdaterJava $ newModuleConfigurationUpdater f

data ModuleConfigurationUpdater = ModuleConfigurationUpdater
  @com.intellij.ide.util.projectWizard.ModuleBuilder$ModuleConfigurationUpdater
  deriving Class

foreign import java unsafe "@wrapper @abstract update" newModuleConfigurationUpdater
  :: (Module -> ModifiableRootModel -> Java a ())
  -> ModuleConfigurationUpdater
