module FFI.Com.IntelliJ.Lang.PsiParser where

import P

data {-# CLASS "com.intellij.lang.PsiParser" #-}
  PsiParser = PsiParser (Object# PsiParser)
  deriving Class
