module Tests.EtaLexerTest where

import P
import IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer
import IntelliJ.TestFramework.LexerTestCase

data {-# CLASS "com.typelead.EtaLexerTest extends com.intellij.testFramework.LexerTestCase" #-}
  EtaLexerTest = EtaLexerTest (Object# EtaLexerTest)
  deriving Class

type instance Inherits EtaLexerTest = '[LexerTestCase]

-- This shouldn't be used as we override getPathToTestDataFile
foreign export java "getDirPath" getDirPath :: Java EtaLexerTest JString
getDirPath :: Java EtaLexerTest JString
getDirPath = return $ unsafeNull

foreign export java "createLexer" createLexer :: Java EtaLexerTest EtaLexer
createLexer = newEtaLexer

foreign export java "testArrow00001" testArrow00001 :: Java EtaLexerTest ()
testArrow00001 :: Java EtaLexerTest ()
testArrow00001 = doTest
