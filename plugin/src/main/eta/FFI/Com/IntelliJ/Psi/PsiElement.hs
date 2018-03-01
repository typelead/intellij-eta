module FFI.Com.IntelliJ.Psi.PsiElement where

import P

data {-# CLASS "com.intellij.psi.PsiElement" #-}
  PsiElement = PsiElement (Object# PsiElement)
  deriving Class

