module FFI.Com.IntelliJ.Lang.ASTNode where

import P.Base

import FFI.Com.IntelliJ.Psi.Tree.IElementType

data {-# CLASS "com.intellij.lang.ASTNode" #-}
  ASTNode = ASTNode (Object# ASTNode)
  deriving Class

foreign import java unsafe "@interface" getElementType :: Java ASTNode IElementType
