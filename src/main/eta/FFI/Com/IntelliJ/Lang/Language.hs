module FFI.Com.IntelliJ.Lang.Language where

import P

data {-# CLASS "com.intellij.lang.Language" #-}
  Language = Language (Object# Language)
  deriving Class