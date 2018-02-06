module IntelliJ.Plugin.Eta.Project.Template.EtlasProjectTemplate where

import P.Base
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.AbstractModuleBuilder (AbstractModuleBuilder)
import FFI.Com.IntelliJ.OpenApi.UI.ValidationInfo (ValidationInfo)
import FFI.Com.IntelliJ.Platform.ProjectTemplate (ProjectTemplate)
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Resources.EtaIcons (etaFileIcon)
import FFI.Javax.Swing.Icon (Icon)
import IntelliJ.Plugin.Eta.Project.Module.EtlasModuleBuilder (newEtlasModuleBuilder)

-- TODO: This seems to use extends instead of implements, using the old way instead...
-- data EtlasProjectTemplate = EtlasProjectTemplate
--   @com.typelead.intellij.plugin.eta.project.template.EtlasProjectTemplate
--   deriving Class
--
-- type instance Inherits EtlasProjectTemplate = '[ProjectTemplate]

data {-# CLASS "com.typelead.intellij.plugin.eta.project.template.EtlasProjectTemplate implements com.intellij.platform.ProjectTemplate" #-}
  EtlasProjectTemplate = EtlasProjectTemplate (Object# EtlasProjectTemplate)
  deriving Class
  
-- Hack since we can't superCast
toProjectTemplate :: EtlasProjectTemplate -> ProjectTemplate
toProjectTemplate t = unsafeRuntimeCast t

foreign import java unsafe "@new" newEtlasProjectTemplate :: Java a EtlasProjectTemplate

foreign export java getName :: Java EtlasProjectTemplate JString
getName = return "Etlas"

foreign export java getDescription :: Java EtlasProjectTemplate JString
getDescription = return "Eta project compiled with the Etlas build tool"

foreign export java getIcon :: Java EtlasProjectTemplate Icon
getIcon = return etaFileIcon

foreign export java createModuleBuilder :: Java EtlasProjectTemplate AbstractModuleBuilder
createModuleBuilder = superCastJ newEtlasModuleBuilder

foreign export java validateSettings :: Java EtlasProjectTemplate ValidationInfo
validateSettings = return unsafeJNull
