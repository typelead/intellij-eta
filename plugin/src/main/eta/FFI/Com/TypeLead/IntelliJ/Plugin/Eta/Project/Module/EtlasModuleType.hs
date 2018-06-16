module FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Project.Module.EtlasModuleType where

import P

import FFI.Com.IntelliJ.OpenApi.Module.ModuleType (ModuleType)
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.EmptyModuleBuilder (EmptyModuleBuilder)

data EtlasModuleType = EtlasModuleType
  @com.typelead.intellij.plugin.eta.project.module.EtlasModuleType
  deriving Class

type instance Inherits EtlasModuleType = '[ModuleType EmptyModuleBuilder]

{-# NOINLINE etlasModuleType #-}
foreign import java unsafe
  "@static com.typelead.intellij.plugin.eta.project.module.EtlasModuleType.getInstance"
  etlasModuleType :: EtlasModuleType
