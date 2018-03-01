module FFI.Com.IntelliJ.Lang.ASTNode where

import P

data {-# CLASS "com.intellij.lang.ASTNode" #-}
  ASTNode = ASTNode (Object# ASTNode)
  deriving Class