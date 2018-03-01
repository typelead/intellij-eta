module FFI.Com.IntelliJ.ExtApi.Psi.ASTWrapperPsiElement where

import P

import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Psi.PsiElement

data {-# CLASS "com.intellij.extapi.psi.ASTWrapperPsiElement" #-}
  ASTWrapperPsiElement = ASTWrapperPsiElement (Object# ASTWrapperPsiElement)
  deriving Class

type instance Inherits ASTWrapperPsiElement = '[PsiElement]

foreign import java unsafe "@new" newASTWrapperPsiElement
  :: ASTNode -> Java a ASTWrapperPsiElement
