module FFI.Com.TypeLead.IntelliJ.Utils.Parser.SimplePsiParser where

import P

import FFI.Com.IntelliJ.Lang.PsiParser

data {-# CLASS "com.typelead.intellij.utils.parser.SimplePsiParser" #-}
  SimplePsiParser = SimplePsiParser (Object# SimplePsiParser)
  deriving Class

type instance Inherits SimplePsiParser = '[PsiParser]

foreign import java unsafe "@new" newSimplePsiParser :: Java a SimplePsiParser
