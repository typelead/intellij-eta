module IntelliJ.Plugin.Util.Wizard
  ( EtaModuleWizardStep
  , MkModuleWizardStep(..)
  , mkModuleWizardStep
  ) where

import P

import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.ModuleWizardStep
import FFI.Javax.Swing.JComponent

import Foreign.StablePtr

data MkModuleWizardStep = MkModuleWizardStep
  { mkModuleWizardStepUpdateDataModel :: Java EtaModuleWizardStep ()
  , mkModuleWizardStepGetComponent :: Java EtaModuleWizardStep JComponent
  }

mkModuleWizardStep :: MkModuleWizardStep -> Java a ModuleWizardStep
mkModuleWizardStep impl = do
  ptr <- io $ newStablePtr impl
  wizStep <- newEtaModuleWizardStep
  wizStep <.> setMyImplPtr ptr
  return $ superCast wizStep

data AbstractEtaModuleWizardStep = AbstractEtaModuleWizardStep
  @com.typelead.intellij.plugin.eta.util.AbstractEtaModuleWizardStep
  deriving Class

type instance Inherits AbstractEtaModuleWizardStep = '[ModuleWizardStep]

data EtaModuleWizardStep = EtaModuleWizardStep
  @com.typelead.intellij.plugin.eta.util.EtaModuleWizardStep
  deriving Class

type instance Inherits EtaModuleWizardStep = '[AbstractEtaModuleWizardStep]

foreign import java unsafe "@new" newEtaModuleWizardStep
  :: Java a EtaModuleWizardStep

foreign import java unsafe "@field myImplPtr" setMyImplPtr
  :: (StablePtr MkModuleWizardStep) -> Java EtaModuleWizardStep ()

foreign import java unsafe "@field myImplPtr" myImplPtr
  :: Java EtaModuleWizardStep (StablePtr MkModuleWizardStep)

withImpl :: (MkModuleWizardStep -> Java EtaModuleWizardStep a) -> Java EtaModuleWizardStep a
withImpl f = do
  ptr <- myImplPtr
  impl <- io $ deRefStablePtr ptr
  f impl

foreign export java "updateDataModel" updateDataModelImpl :: Java EtaModuleWizardStep ()
updateDataModelImpl = withImpl mkModuleWizardStepUpdateDataModel

foreign export java "getComponent" getComponentImpl :: Java EtaModuleWizardStep JComponent
getComponentImpl = withImpl mkModuleWizardStepGetComponent
