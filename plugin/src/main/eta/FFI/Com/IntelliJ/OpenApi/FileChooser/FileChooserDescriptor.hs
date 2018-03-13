module FFI.Com.IntelliJ.OpenApi.FileChooser.FileChooserDescriptor where

import P.Base

data FileChooserDescriptor = FileChooserDescriptor
  @com.intellij.openapi.fileChooser.FileChooserDescriptor
  deriving Class
