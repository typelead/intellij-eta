module FFI.Com.IntelliJ.Lexer.Lexer where

import P
import FFI.Com.IntelliJ.Psi.Tree.IElementType

data {-# CLASS "com.intellij.lexer.Lexer" #-}
  Lexer = Lexer (Object# Lexer)
  deriving Class

type instance Inherits Lexer = '[Object]

foreign import java "start" start
  :: (a <: Lexer) => CharSequence -> Int -> Int -> Int -> Public (Java a ())

foreign import java "getState" getState
  :: (a <: Lexer) => Public (Java a Int)

-- Separate method which returns Maybe instead of @Nullable IElementType
-- When Eta FFI supports Maybe in the return type, we can get rid of the
-- getTokenTypeJava method in favor of this one.
getTokenType :: (a <: Lexer) => Public (Java a (Maybe IElementType))
getTokenType = Public $ maybeFromJava <$> unPublic getTokenTypeJava

foreign import java "getTokenType" getTokenTypeJava
  :: (a <: Lexer) => Public (Java a IElementType)

foreign import java "getTokenStart" getTokenStart
  :: (a <: Lexer) => Public (Java a Int)

foreign import java "getTokenEnd" getTokenEnd
  :: (a <: Lexer) => Public (Java a Int)

foreign import java "advance" advance
  :: (a <: Lexer) => Public (Java a ())

foreign import java "getBufferSequence" getBufferSequence
  :: (a <: Lexer) => Public (Java a CharSequence)

foreign import java "getBufferEnd" getBufferEnd
  :: (a <: Lexer) => Public (Java a Int)
