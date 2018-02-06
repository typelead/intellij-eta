module FFI.Com.IntelliJ.Psi.Tree.IFileElementType where

import P
import FFI.Com.IntelliJ.Lang.Language

data {-# CLASS "com.intellij.psi.tree.IFileElementType" #-}
  IFileElementType = IFileElementType (Object# IFileElementType)
  deriving Class

foreign import java unsafe "@new"
  newIFileElementType :: (a <: Language) => a -> Java b IFileElementType
