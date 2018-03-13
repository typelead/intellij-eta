module FFI.Com.IntelliJ.OpenApi.FileChooser.FileChooserDescriptorFactory where

import P.Base
import FFI.Com.IntelliJ.OpenApi.FileChooser.FileChooserDescriptor (FileChooserDescriptor)

data FileChooserDescriptorFactory = FileChooserDescriptorFactory
  @com.intellij.openapi.fileChooser.FileChooserDescriptorFactory
  deriving Class

foreign import java unsafe
  "@static com.intellij.openapi.fileChooser.FileChooserDescriptorFactory.createSingleLocalFileDescriptor"
  createSingleLocalFileDescriptor :: Java a FileChooserDescriptor
