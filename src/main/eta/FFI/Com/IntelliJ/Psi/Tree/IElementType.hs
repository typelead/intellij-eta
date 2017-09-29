module FFI.Com.IntelliJ.Psi.Tree.IElementType where

import P

data {-# CLASS "com.intellij.psi.tree.IElementType" #-}
  IElementType = IElementType (Object# IElementType)
  deriving Class

data {-# CLASS "com.intellij.psi.tree.IElementType[]" #-}
  IElementTypeArray = IElementTypeArray (Object# IElementTypeArray)
  deriving Class

instance JArray IElementType IElementTypeArray
