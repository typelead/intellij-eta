module FFI.Com.IntelliJ.OpenApi.Roots.ContentEntry where

import P

import FFI.Com.IntelliJ.OpenApi.Vfs.VirtualFile
import FFI.Com.IntelliJ.OpenApi.Roots.ExcludeFolder

data ContentEntry = ContentEntry
  @com.intellij.openapi.roots.ContentEntry
  deriving Class

type instance Inherits ContentEntry = '[Object]

data ContentEntryArray = ContentEntryArray
  @com.intellij.openapi.roots.ContentEntry[]
  deriving Class

instance JArray ContentEntry ContentEntryArray

foreign import java unsafe "@interface" getUrl
  :: Java ContentEntry JString

foreign import java unsafe "@interface" getFile
  :: Java ContentEntry VirtualFile

foreign import java unsafe "@interface addExcludeFolder" addExcludeFolderStr
  :: JString -> Java ContentEntry ExcludeFolder

foreign import java unsafe "@interface addExcludeFolder" addExcludeFolderVFile
  :: VirtualFile -> Java ContentEntry ExcludeFolder

