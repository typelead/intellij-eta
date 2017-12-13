module FFI.Com.IntelliJ.OpenApi.Vfs.VirtualFile where

import P

data {-# CLASS "com.intellij.openapi.vfs.VirtualFile" #-}
  VirtualFile = VirtualFile (Object# VirtualFile)
  deriving Class
