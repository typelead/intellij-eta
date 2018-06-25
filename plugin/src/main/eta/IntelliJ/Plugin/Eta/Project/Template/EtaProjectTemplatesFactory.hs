module IntelliJ.Plugin.Eta.Project.Template.EtaProjectTemplatesFactory where

import P.Base
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.WizardContext (WizardContext)
import FFI.Com.IntelliJ.Platform.ProjectTemplate (ProjectTemplateArray)
import FFI.Com.IntelliJ.Platform.ProjectTemplatesFactory (ProjectTemplatesFactory)
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Resources.EtaIcons (etaFileIcon)
import FFI.Javax.Swing.Icon (Icon)
import IntelliJ.Plugin.Eta.Project.Template.EtlasProjectTemplate (newEtlasProjectTemplate, toProjectTemplate)

data EtaProjectTemplatesFactory = EtaProjectTemplatesFactory
  @com.typelead.intellij.plugin.eta.project.template.EtaProjectTemplatesFactory
  deriving Class

type instance Inherits EtaProjectTemplatesFactory = '[ProjectTemplatesFactory]

foreign export java getGroups :: Java EtaProjectTemplatesFactory JStringArray
getGroups = arrayFromList ["Eta"]

foreign export java createTemplates
  :: JString
  -> WizardContext
  -> Java EtaProjectTemplatesFactory ProjectTemplateArray
createTemplates
  :: JString
  -> WizardContext
  -> Java EtaProjectTemplatesFactory ProjectTemplateArray
createTemplates _ _ = do
  t <- newEtlasProjectTemplate
  arrayFromList [toProjectTemplate t]

foreign export java "getGroupIcon" getGroupIcon :: JString -> Java EtaProjectTemplatesFactory Icon
getGroupIcon _ = return etaFileIcon
