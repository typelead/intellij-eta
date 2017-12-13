module FFI.Com.IntelliJ.Psi.Tree.IElementType where

import P

data {-# CLASS "com.intellij.psi.tree.IElementType" #-}
  IElementType = IElementType (Object# IElementType)
  deriving Class

foreign import java unsafe getIndex :: IElementType -> Short

instance Ord IElementType where
  x <= y = getIndex x <= getIndex y

instance Eq IElementType where
  x == y = getIndex x == getIndex y

data {-# CLASS "com.intellij.psi.tree.IElementType[]" #-}
  IElementTypeArray = IElementTypeArray (Object# IElementTypeArray)
  deriving Class

instance JArray IElementType IElementTypeArray
