module FFI.Com.IntelliJ.Lexer.Lexer where

import P
import FFI.Com.IntelliJ.Psi.Tree.IElementType

data {-# CLASS "com.intellij.lexer.Lexer" #-}
  Lexer = Lexer (Object# Lexer)
  deriving Class

type instance Inherits Lexer = '[Object]

foreign import java "start" start
  :: (a <: Lexer) => CharSequence -> Int -> Int -> Int -> Java a ()

foreign import java "getState" getState
  :: (a <: Lexer) => Java a Int

-- Separate method which returns Maybe instead of @Nullable IElementType
-- When Eta FFI supports Maybe in the return type, we can get rid of the
-- getTokenTypeJava method in favor of this one.
getTokenType :: (a <: Lexer) => Java a (Maybe IElementType)
getTokenType = maybeFromJava <$> getTokenTypeJava

foreign import java "getTokenType" getTokenTypeJava
  :: (a <: Lexer) => Java a IElementType

foreign import java "getTokenStart" getTokenStart
  :: (a <: Lexer) => Java a Int

foreign import java "getTokenEnd" getTokenEnd
  :: (a <: Lexer) => Java a Int

foreign import java "advance" advance
  :: (a <: Lexer) => Java a ()

foreign import java "getBufferSequence" getBufferSequence
  :: (a <: Lexer) => Java a CharSequence

foreign import java "getBufferEnd" getBufferEnd
  :: (a <: Lexer) => Java a Int
