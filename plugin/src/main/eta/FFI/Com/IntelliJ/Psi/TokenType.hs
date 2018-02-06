module FFI.Com.IntelliJ.Psi.TokenType where

import P
import FFI.Com.IntelliJ.Psi.Tree.IElementType

data {-# CLASS "com.intellij.psi.TokenType" #-}
  TokenType = TokenType (Object# TokenType)
  deriving Class

foreign import java unsafe "@static @field com.intellij.psi.TokenType.WHITE_SPACE"
  whiteSpace :: IElementType

foreign import java unsafe "@static @field com.intellij.psi.TokenType.BAD_CHARACTER"
  badCharacter :: IElementType

foreign import java unsafe "@static @field com.intellij.psi.TokenType.NEW_LINE_INDENT"
  newLineIndent :: IElementType

foreign import java unsafe "@static @field com.intellij.psi.TokenType.ERROR_ELEMENT"
  errorElement :: IElementType

foreign import java unsafe "@static @field com.intellij.psi.TokenType.CODE_FRAGMENT"
  codeFragment :: IElementType

foreign import java unsafe "@static @field com.intellij.psi.TokenType.DUMMY_HOLDER"
  dummyHolder :: IElementType
