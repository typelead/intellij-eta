module FFI.Com.IntelliJ.OpenApi.UI.TextFieldWithBrowseButton where

import Java
import FFI.Com.IntelliJ.UI.TextAccessor
import FFI.Javax.Swing.JComponent

data TextFieldWithBrowseButton = TextFieldWithBrowseButton
  @com.intellij.openapi.ui.TextFieldWithBrowseButton
  deriving Class

type instance Inherits TextFieldWithBrowseButton = '[JComponent, TextAccessor]

foreign import java unsafe "@new" newTextFieldWithBrowseButton
  :: Java a TextFieldWithBrowseButton
