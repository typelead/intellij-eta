module Tests.EtaLexerTest where

import P
import IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer
import IntelliJ.TestFramework.LexerTestCase
import IntelliJ.TestFramework.UsefulTestCase

data {-# CLASS "com.typelead.EtaLexerTest extends com.intellij.testFramework.LexerTestCase" #-}
  EtaLexerTest = EtaLexerTest (Object# EtaLexerTest)
  deriving Class

type instance Inherits EtaLexerTest = '[LexerTestCase]

foreign export java "getDirPath" getDirPath :: Java EtaLexerTest JString
getDirPath :: Java EtaLexerTest JString
getDirPath = return dirPath

dirPath :: JString
dirPath = "src/test/resources/fixtures/eta"

foreign export java "createLexer" createLexer :: Java EtaLexerTest EtaLexer
createLexer = newEtaLexer

doTest :: Java EtaLexerTest ()
doTest = do
  testName <- getTestNameUpper
  let fileName = testName <> ".hs"
  text <- loadFile
  result <- printTokens text 0
  doCheckResult (expectPath <> jfileSeparator <> "expected") (testName <> ".txt") result
  where
  loadFile name = doLoadFile fileName

  doCheckResult :: JString -> JString -> JString -> Java a ()
  doCheckResult fullPath targetDataName tokenResult = do
    let text = trim tokenResult
        expectedFileName = fullPath <> jFileSeparator <> targetDataName

-- Adaptation of CabalLexerTestBase
-- doTest :: (a <: LexerTestCase) => Java a ()
-- doTest = do
--   testName <- getTestNameUpper
--   let fileName = testName <> ".hs"
--   text <- loadFile fileName
--   lexer <- createLexer
--   checkSegments text lexer
--   where
--   loadFile name = doLoadFile dirPath name
--
--   doLoadFile path name = do
--     text <- FileUtil.loadFile $ path <> "/" <> name
--     return $ trim $ StringUtil.convertLineSeparators text
--
--   checkSegments :: JString -> Lexer
--   checkSegments = undefined

foreign export java "testArrow00001" testArrow00001 :: Java EtaLexerTest ()
testArrow00001 :: Java EtaLexerTest ()
testArrow00001 = doTest
