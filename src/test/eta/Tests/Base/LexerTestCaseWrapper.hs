module Tests.Base.LexerTestCaseWrapper where

import P
import FFI.Com.IntelliJ.Lexer.Lexer
import FFI.Com.IntelliJ.RT.Execution.JUnit.FileComparisonFailure (newFileComparisonFailure)
import qualified FFI.Com.IntelliJ.OpenApi.Util.Text.StringUtil as StringUtil
import qualified FFI.Com.IntelliJ.OpenApi.Util.IO.FileUtil as FileUtil
import IntelliJ.TestFramework.UsefulTestCase
import IntelliJ.TestFramework.LexerTestCase (LexerTestCase)
import IntelliJ.TestFramework.VfsTestUtil (overwriteTestData)
import qualified JUnit.Framework.TestCase as T
import Tests.Utils

-- TODO: We currently have to work around not being able to access protected methods
-- by extending a wrapper class which changes the access level to public.
data LexerTestCaseWrapper = LexerTestCaseWrapper
  @com.typelead.intellij.test.LexerTestCaseWrapper
  deriving Class

type instance Inherits LexerTestCaseWrapper = '[LexerTestCase]

foreign import java unsafe createLexer
  :: (a <: LexerTestCaseWrapper)
  => Java a Lexer

foreign import java unsafe printTokens
  :: (a <: LexerTestCaseWrapper)
  => JString -> Int -> Java a JString

foreign import java unsafe getDirPath
  :: (a <: LexerTestCaseWrapper)
  => Java a JString

doTest :: (a <: LexerTestCaseWrapper) => Java a ()
doTest = do
  this <- withThis $ \t -> return (superCast t :: LexerTestCaseWrapper)
  testName <- this <.> getTestNameUpper
  dirPath <- this <.> getDirPath
  let fileName = testName <> ".hs"
  text <- loadFile dirPath fileName
  checkSegments text
  result <- printTokens text 0
  doCheckResult (myExpectPath dirPath <> jFileSeparator <> "expected") (testName <> ".txt") result
  where

  srcPath dirPath = dirPath <> jFileSeparator <> "sources"

  myExpectPath dirPath = dirPath <> jFileSeparator <> "lexer"

  loadFile dirPath name = doLoadFile (srcPath dirPath) name

  doLoadFile myFullDataPath name =
    StringUtil.convertLineSeparators <$>
      FileUtil.loadFile (myFullDataPath <> jFileSeparator <> name)

  doCheckResult :: forall a. JString -> JString -> JString -> Java a ()
  doCheckResult fullPath targetDataName tokenResult = run $ do
    expectedText <- trim <$> doLoadFile fullPath targetDataName
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
      T.fail $ ("No output text found. File " <> expectedFileName <> "created." :: JString)

checkSegments :: (a <: LexerTestCaseWrapper) => JString -> Java a ()
checkSegments text = do
  let len = jStringLength text
  lexer <- createLexer
  lexer <.> start (superCast text) 0 len 0
  (lexer <.> getTokenType) >>= (if len == 0 then assertNothing else assertJust)
  loop lexer 0
  where
  loop lexer lastEnd = do
    (lexer <.> getTokenStart) >>= assertEq lastEnd
    lastEnd' <- lexer <.> getTokenEnd
    lexer <.> advance
    typ <- lexer <.> getTokenType
    when (isJust typ) $ loop lexer lastEnd'
