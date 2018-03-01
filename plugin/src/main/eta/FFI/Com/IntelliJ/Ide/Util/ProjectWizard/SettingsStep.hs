module FFI.Com.IntelliJ.Ide.Util.ProjectWizard.SettingsStep where

import P
import FFI.Javax.Swing.JComponent

data SettingsStep = SettingsStep
  @com.intellij.ide.util.projectWizard.SettingsStep
  deriving Class

foreign import java unsafe "@interface" addSettingsField
  :: (s <: SettingsStep, c <: JComponent)
  => JString -> c -> Java s ()
