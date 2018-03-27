module FFI.Com.TypeLead.IntelliJ.Plugin.Cabal.Project.Module.NewCabalProjectForm where

import P.Base
import FFI.Javax.Swing.JComponent (JComponent)

data NewCabalProjectForm = NewCabalProjectForm
  @com.typelead.intellij.plugin.cabal.project.module.NewCabalProjectForm
  deriving Class

foreign import java unsafe "@new" newNewCabalProjectForm
  :: Java a NewCabalProjectForm

foreign import java unsafe getContentPane
  :: Java NewCabalProjectForm JComponent
