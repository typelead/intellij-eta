module FFI.Com.IntelliJ.Psi.Tree.TokenSet where

import P
import FFI.Com.IntelliJ.Psi.Tree.IElementType

data {-# CLASS "com.intellij.psi.tree.TokenSet" #-}
  TokenSet = TokenSet (Object# TokenSet)
  deriving Class

foreign import java unsafe "@static com.intellij.psi.tree.TokenSet.EMPTY"
  empty :: TokenSet

foreign import java unsafe "@static com.intellij.psi.tree.TokenSet.ANY"
  any :: TokenSet

foreign import java unsafe "@static com.intellij.psi.tree.TokenSet.create"
  createFromArray :: IElementTypeArray -> TokenSet

create :: [IElementType] -> TokenSet
create types = createFromArray $ pureJava $ arrayFromList $ types
