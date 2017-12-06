module Tests.EtaLexerTest where

import P
import FFI.Com.IntelliJ.Lexer.Lexer (Lexer)
import FFI.Com.IntelliJ.RT.Execution.JUnit.FileComparisonFailure
import qualified FFI.Com.IntelliJ.OpenApi.Util.IO.FileUtil as FileUtil
import FFI.Com.IntelliJ.OpenApi.Util.Text.StringUtil
import IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer
import qualified JUnit.Framework.TestCase as TestCase
import IntelliJ.TestFramework.LexerTestCase
import IntelliJ.TestFramework.UsefulTestCase
import IntelliJ.TestFramework.VfsTestUtil

-- TODO: We currently have to work around not being able to access protected methods
-- by extending a wrapper class which changes the access level to public.
data {-# CLASS "com.typelead.intellij.test.LexerTestCaseWrapper" #-}
  LexerTestCaseWrapper = LexerTestCaseWrapper (Object# LexerTestCaseWrapper)
  deriving Class

type instance Inherits LexerTestCaseWrapper = '[LexerTestCase]

data {-# CLASS "com.typelead.EtaLexerTest" #-}
  EtaLexerTest = EtaLexerTest (Object# EtaLexerTest)
  deriving Class

type instance Inherits EtaLexerTest = '[LexerTestCaseWrapper]

foreign export java "getDirPath" getDirPath :: Java EtaLexerTest JString
getDirPath :: Java EtaLexerTest JString
getDirPath = return dirPath

dirPath :: JString
dirPath = "src/test/resources/fixtures/eta"

foreign export java "createLexer" createLexer :: Java EtaLexerTest Lexer
createLexer = superCast <$> newEtaLexer

doTest :: Java EtaLexerTest ()
doTest = do
  this <- getThis
  testName <- this <.> getTestNameUpper
  let fileName = testName <> ".hs"
  text <- loadFile fileName
  result <- this <.> printTokens text 0
  doCheckResult (myExpectPath <> jFileSeparator <> "expected") (testName <> ".txt") result
  where
  srcPath = dirPath <> jFileSeparator <> "sources"

  myExpectPath = dirPath <> jFileSeparator <> "lexer"

  loadFile name = doLoadFile srcPath name

  doLoadFile myFullDataPath name =
    convertLineSeparators . trim <$> FileUtil.loadFile (myFullDataPath <> jFileSeparator <> name)

  doCheckResult :: forall a. JString -> JString -> JString -> Java a ()
  doCheckResult fullPath targetDataName tokenResult = run $ do
    expectedText <- doLoadFile fullPath targetDataName
    when (expectedText /= text) $ throwFileComparisonFailure expectedText
    where
    text = trim tokenResult

    expectedFileName = fullPath <> jFileSeparator <> targetDataName

    throwFileComparisonFailure :: forall a. JString -> Java a ()
    throwFileComparisonFailure expectedText =
      throwJavaM $
        newFileComparisonFailure
          targetDataName expectedText text expectedFileName

    run :: forall b. (forall a. Java a ()) -> Java b ()
    run f = io $ catch (java f) $ \(e :: FileNotFoundException) -> java $ do
      overwriteTestData expectedFileName text
      TestCase.fail $ ("No output text found. File " <> expectedFileName <> "created." :: JString)

foreign export java "testArrow00001" testArrow00001 :: Java EtaLexerTest ()
testArrow00001 :: Java EtaLexerTest ()
testArrow00001 = doTest
