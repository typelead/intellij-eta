module FFI.Com.IntelliJ.Psi.FileViewProvider where

import P

data {-# CLASS "com.intellij.psi.FileViewProvider" #-}
  FileViewProvider = FileViewProvider (Object# FileViewProvider)
  deriving Class
