module IntelliJ.TestFramework.LexerTestCase where

import P
import Java.StringUtils (trim)
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

dirPath :: JString
dirPath = "src/test/resources/fixtures/eta/sources"

doTest :: (a <: LexerTestCase) => Java a ()
doTest = do
  this <- getThis
  testName <- this <.> getTestNameUpper
  let fileName = testName <> ".hs"
  text <- loadFile fileName
  undefined
  where
  --loadFile :: Java a JString
  loadFile name = doLoadFile dirPath name

  --doLoadFile :: JString -> JString -> Java a JString
  doLoadFile path name = do
    text <- FileUtil.loadFile $ path <> "/" <> name
    return $ trim $ StringUtil.convertLineSeparators text

  checkSegments :: JString -> Lexer
  checkSegments = undefined
