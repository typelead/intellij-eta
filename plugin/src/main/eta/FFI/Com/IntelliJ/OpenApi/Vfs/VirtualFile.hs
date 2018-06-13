module FFI.Com.IntelliJ.OpenApi.Vfs.VirtualFile where

import P.Base

data {-# CLASS "com.intellij.openapi.vfs.VirtualFile" #-}
  VirtualFile = VirtualFile (Object# VirtualFile)
  deriving Class

foreign import java unsafe "getPath" getPath :: Java VirtualFile JString
