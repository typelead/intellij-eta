module FFI.Com.IntelliJ.Psi.PsiFile where

import P

data {-# CLASS "com.intellij.psi.PsiFile" #-}
  PsiFile = PsiFile (Object# PsiFile)
  deriving Class
