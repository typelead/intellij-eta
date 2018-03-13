module IntelliJ.Plugin.Util.GuiUtil where

import P
import FFI.Com.IntelliJ.OpenApi.UI.TextFieldWithBrowseButton (TextFieldWithBrowseButton, addBrowseFolderListener)
import FFI.Com.IntelliJ.OpenApi.FileChooser.FileChooserDescriptorFactory (createSingleLocalFileDescriptor)

addFolderListener :: TextFieldWithBrowseButton -> JString -> Java a ()
addFolderListener textField name = do
  descriptor <- createSingleLocalFileDescriptor
  textField <.> addBrowseFolderListener title description project descriptor
  where
  title = "Select " <> name <> " path"
  description = ""
  project = unsafeJNull
