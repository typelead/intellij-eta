module IntelliJ.Plugin.Eta.Project.Module.EtlasModuleBuilder where

import P

import           FFI.Com.IntelliJ.Ide.Util.ProjectWizard.EmptyModuleBuilder (EmptyModuleBuilder)
import           FFI.Com.IntelliJ.Ide.Util.ProjectWizard.JavaModuleBuilder (JavaModuleBuilder)
import qualified FFI.Com.IntelliJ.Ide.Util.ProjectWizard.JavaModuleBuilder as JavaModuleBuilder
import           FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleBuilder (addModuleConfigurationUpdater)
import           FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleWizardStep (ModuleWizardStep, ModuleWizardStepArray, updateDataModel)
import           FFI.Com.IntelliJ.Ide.Util.ProjectWizard.SettingsStep (SettingsStep, addSettingsField)
import           FFI.Com.IntelliJ.Ide.Util.ProjectWizard.WizardContext (WizardContext, isCreatingNewProject)
import           FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Project.Module.EtlasModuleType (getEtlasModuleType)
import qualified FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Settings.EtaBuildSettings as EtaBuildSettings
import           FFI.Com.IntelliJ.OpenApi.Module.JavaModuleType (getJavaModuleType)
import           FFI.Com.IntelliJ.OpenApi.Module.ModuleType (ModuleType, modifyProjectTypeStep)
import           FFI.Com.IntelliJ.OpenApi.Roots.ContentEntry (getUrl, addExcludeFolderStr)
import           FFI.Com.IntelliJ.OpenApi.Roots.ModifiableRootModel (ModifiableRootModel, getContentEntries)
import           FFI.Com.IntelliJ.OpenApi.Roots.UI.Configuration.ModulesProvider (ModulesProvider)
import           FFI.Com.IntelliJ.OpenApi.UI.TextFieldWithBrowseButton (TextFieldWithBrowseButton, newTextFieldWithBrowseButton)
import           FFI.Com.IntelliJ.UI.TextAccessor (getText)
import           FFI.Javax.Swing.JComponent

import           IntelliJ.Plugin.Util.Wizard

data EtlasModuleBuilder = EtlasModuleBuilder
  @com.typelead.intellij.plugin.eta.project.module.EtlasModuleBuilder
  deriving Class

type instance Inherits EtlasModuleBuilder = '[JavaModuleBuilder]

foreign import java unsafe "@new" newEtlasModuleBuilder :: Java a EtlasModuleBuilder

foreign export java getModuleType
  :: Java EtlasModuleBuilder (ModuleType EmptyModuleBuilder)
getModuleType = return (superCast getEtlasModuleType)

foreign export java createWizardSteps
  :: WizardContext
  -> ModulesProvider
  -> Java EtlasModuleBuilder ModuleWizardStepArray
createWizardSteps
  :: WizardContext
  -> ModulesProvider
  -> Java EtlasModuleBuilder ModuleWizardStepArray
createWizardSteps wizardContext _modulesProvider = do
  _isNewProj <- wizardContext <.> isCreatingNewProject
  -- TODO
  arrayFromList []
--   if isNewProj then do
--     this <- getThis
--     arrayFromList =<< sequence [newEtlasStep this wizardContext]
--   else
--     arrayFromList []

foreign export java modifySettingsStep
  :: SettingsStep
  -> Java EtlasModuleBuilder ModuleWizardStep
modifySettingsStep settingsStep = do
  this <- getThis
  superCastJ $ newEtaStep this settingsStep

foreign export java setupRootModel :: ModifiableRootModel -> Java EtlasModuleBuilder ()
setupRootModel rootModel = do
  this <- getThis
  (superCast this) <.> JavaModuleBuilder.setupRootModel rootModel
  addExcludedRoots
  where
  addExcludedRoots = do
    entries <- rootModel <.> getContentEntries >- arrayToList
    forM_ entries $ \contentEntry -> do
      url <- contentEntry <.> getUrl
      contentEntry <.> addExcludeFolderStr (url <> "/dist")

-- TODO
-- newEtlasStep :: EtlasModuleBuilder -> WizardContext -> Java a ModuleWizardStep
-- newEtlasStep moduleBuilder wizardContext = mkModuleWizardStep MkModuleWizardStep {..}
--   where
--   mkModuleWizardStepUpdateDataModel = undefined
--   mkModuleWizardStepGetComponent = undefined

newEtaStep :: EtlasModuleBuilder -> SettingsStep -> Java a ModuleWizardStep
newEtaStep moduleBuilder settingsStep = do
  component <- emptyJComponent
  let mkModuleWizardStepGetComponent = return component

  javaStep <- getJavaModuleType >- modifyProjectTypeStep settingsStep (superCast moduleBuilder)

  etaPathField <- newPathField "eta"
  settingsStep <.> addSettingsField "Eta path:" etaPathField
  etlasPathField <- newPathField "etlas"
  settingsStep <.> addSettingsField "Etlas path:" etlasPathField

  let mkModuleWizardStepUpdateDataModel = do
        javaStep <.> updateDataModel
        moduleBuilder <.> addModuleConfigurationUpdater (\_module rootModel -> do
          project <- rootModel <.> getProject
          buildSettings <- EtaBuildSettings.getInstance project
          (etaPathField <.> getText) >>= (\s -> buildSettings <.> EtaBuildSettings.setEtaPath s)
          (etlasPathField <.> getText) >>= (\s -> buildSettings <.> EtaBuildSettings.setEtlasPath s)
          )

  mkModuleWizardStep MkModuleWizardStep {..}
  where
  -- TODO: Need to GuiUtil.addFolderListener, locateExecutableByGuessing, etc.
  newPathField :: JString -> Java a TextFieldWithBrowseButton
  newPathField _name = newTextFieldWithBrowseButton
