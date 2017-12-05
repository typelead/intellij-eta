module IntelliJ.TestFramework.LexerTestCase where

import P
import FFI.Com.IntelliJ.Lexer.Lexer
import qualified FFI.Com.IntelliJ.OpenApi.Util.Text.StringUtil as StringUtil
import qualified FFI.Com.IntelliJ.OpenApi.Util.IO.FileUtil as FileUtil
import IntelliJ.TestFramework.UsefulTestCase

data {-# CLASS "com.intellij.testFramework.LexerTestCase" #-}
  LexerTestCase = LexerTestCase (Object# LexerTestCase)
  deriving Class

type instance Inherits LexerTestCase = '[Object, UsefulTestCase]

foreign import java unsafe "printTokens" printTokens
  :: (a <: LexerTestCase)
  => JString -> Int -> Protected (Java a JString)
