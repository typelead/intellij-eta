module IntelliJ.TestFramework.LexerTestCase where

import P
import FFI.Com.IntelliJ.Lexer.Lexer
import qualified FFI.Com.IntelliJ.OpenApi.Util.Text.StringUtil as StringUtil
import qualified FFI.Com.IntelliJ.OpenApi.Util.IO.FileUtil as FileUtil
import IntelliJ.TestFramework.UsefulTestCase

data LexerTestCase = LexerTestCase
  @com.intellij.testFramework.LexerTestCase
  deriving Class

type instance Inherits LexerTestCase = '[Object, UsefulTestCase]

foreign import java unsafe createLexer
  :: (a <: LexerTestCase)
  => Java a Lexer

foreign import java unsafe printTokens
  :: (a <: LexerTestCase)
  => JString -> Int -> Java a JString

foreign import java unsafe getDirPath
  :: (a <: LexerTestCase)
  => Java a JString
